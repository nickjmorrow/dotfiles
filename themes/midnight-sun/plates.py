#!/usr/bin/env python3
"""Keep the engraved plate icons (glyphs/plates/*.svg) in line with the plate-icons skill.

  plates.py lint                 every plate against the rules a script can check; exit 1 on a failure
  plates.py retile [name ...]    move plates to their element's tile and second colour (all when none named)
  plates.py markers [name ...]   redraw each plate's top marker (its <g id="marker">) as its element's
  plates.py sheet OUT.png [--ref REF] [--only fire,air] [name ...]
                                 contact sheet by element at 180, 60 and 29 px; with --ref, that git
                                 revision's version sits beside today's
  plates.py mac [name ...]       draw mac/<name>.png (824 px tile, radius 185, on 1024 with a soft shadow)
                                 for every plate that already has a PNG there (or the ones named)

Which element a plate has, and each element's colours, are in glyphs/plates/elements.json.
The rules themselves (shapes, rings, markers, the diagram grammar) are in the plate-icons skill; lint
checks only what a script can see: canvas, tile, colours and the unbroken outer ring.
Needs resvg and Google Chrome (both already used by this theme).
"""
import argparse
import html
import json
import re
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path

HERE = Path(__file__).resolve().parent
PLATES = HERE / "glyphs" / "plates"
MAC = HERE / "mac"
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
HEX = re.compile(r"#[0-9a-fA-F]{6}\b")


def manifest():
    m = json.loads((PLATES / "elements.json").read_text())
    m["seconds"] = {e["second"] for e in m["elements"].values() if e["second"]}
    m["tiles"] = {e["tile"] for e in m["elements"].values()} | set(m["old_tiles"])
    return m


def names(m, picked, only=None):
    out = sorted(picked) if picked else sorted(m["plates"])
    unknown = [n for n in out if n not in m["plates"]]
    if unknown:
        sys.exit(f"not in elements.json: {', '.join(unknown)}")
    return [n for n in out if not only or m["plates"][n] in only]


def colours(svg):
    return {c.lower() for c in HEX.findall(svg)}


# ---- lint ----------------------------------------------------------------------------------------------------------

def problems(name, svg, m):
    el = m["elements"][m["plates"][name]]
    found = []
    try:
        root = ET.fromstring(svg)
    except ET.ParseError as e:
        return [f"not valid SVG: {e}"]
    if root.get("viewBox") != "0 0 120 120":
        found.append(f"viewBox is {root.get('viewBox')!r}, not '0 0 120 120'")
    ns = "{http://www.w3.org/2000/svg}"
    rects = [r for r in root.iter(f"{ns}rect") if r.get("width") == "120" and r.get("height") == "120"]
    tile = rects[0].get("fill", "").lower() if rects else None
    if tile != el["tile"]:
        found.append(f"tile is {tile}, its element's is {el['tile']}")
    ok = {el["tile"], *m["ink"].values(), *(m["allow"].get(name, []))} | ({el["second"]} if el["second"] else set())
    extra = sorted(colours(svg) - ok)
    if extra:
        found.append("colours outside its element: " + ", ".join(extra))
    whole = [c for c in root.iter(f"{ns}circle")
             if c.get("cx") == "60" and c.get("cy") == "60" and 43.5 <= float(c.get("r", 0)) <= 47
             and not c.get("stroke-dasharray")]
    if not whole and name not in m.get("no_ring", {}):
        found.append("no unbroken outer ring (a plain circle at 60,60 with r 44-47)")
    return found


def lint(args):
    m = manifest()
    missing = sorted(p.stem for p in PLATES.glob("*.svg") if p.stem not in m["plates"])
    bad = 0
    for n in missing:
        print(f"{n}: has no element in elements.json"); bad += 1
    for n in names(m, args.names):
        for p in problems(n, (PLATES / f"{n}.svg").read_text(), m):
            print(f"{n} ({m['plates'][n]}): {p}"); bad += 1
    print(f"{bad} problem(s) in {len(m['plates'])} plates" if bad else f"all {len(m['plates'])} plates pass")
    return 1 if bad else 0


# ---- retile --------------------------------------------------------------------------------------------------------

def retile(args):
    """The mechanical part of a move: the tile colour, and any other element's second colour becomes this
    element's (brass on fire, which has none). Shapes, rings and markers still need a redraw by hand."""
    m = manifest()
    for n in names(m, args.names):
        el = m["elements"][m["plates"][n]]
        keep = set(m["allow"].get(n, []))
        path = PLATES / f"{n}.svg"
        svg = path.read_text()

        def swap(match):
            c = match.group(0).lower()
            if c in m["tiles"]:
                return el["tile"]
            if c in m["seconds"] and c not in keep:
                return el["second"] or m["ink"]["brass"]
            return match.group(0)

        new = HEX.sub(swap, svg)
        if new != svg:
            path.write_text(new)
            print(f"{n}: moved to {m['plates'][n]}")
    return 0


# ---- markers -------------------------------------------------------------------------------------------------------

MARKER = re.compile(r'<g id="marker">.*?</g>', re.S)


def marker_svg(element, m):
    """The small sign above the ring, one per element (the skill's "Top marker" row)."""
    ink, tile = m["ink"], m["elements"][element]["tile"]
    return '<g id="marker">' + {
        "fire": f'<path d="M60 5 L64 12 H56 Z" fill="none" stroke="{ink["vermilion"]}" stroke-width="1" stroke-linejoin="round"/>',
        "earth": f'<path d="M60 3 L64 8.5 L60 14 L56 8.5 Z" fill="{tile}" stroke="{ink["brass"]}" stroke-width="1" stroke-linejoin="round"/>',
        "air": f'<path d="M60 2.5 L61.3 6.7 L65.5 8 L61.3 9.3 L60 13.5 L58.7 9.3 L54.5 8 L58.7 6.7 Z" fill="{ink["cream"]}"/>',
        "water": f'<path d="M60 2.5 A6 6 0 1 0 60 14.5 A7.5 7.5 0 0 1 60 2.5 Z" fill="{ink["cream"]}" transform="rotate(-20 60 8.5)"/>',
    }[element] + "</g>"


def markers(args):
    """A plate with a marker keeps it in <g id="marker">; this redraws each one as its element's marker.
    A plate without that group has no marker (or a special one) and is left alone."""
    m = manifest()
    for n in names(m, args.names):
        path = PLATES / f"{n}.svg"
        svg = path.read_text()
        new = MARKER.sub(lambda _: marker_svg(m["plates"][n], m), svg)
        if new != svg:
            path.write_text(new)
            print(f"{n}: marker redrawn")
    return 0


# ---- contact sheet -------------------------------------------------------------------------------------------------

def sheet(args):
    m = manifest()
    only = set(args.only.split(",")) if args.only else None
    picked = names(m, args.names, only)
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)

        def src(n, ref=None):
            if not ref:
                return (PLATES / f"{n}.svg").as_uri()
            rel = (PLATES / f"{n}.svg").relative_to(HERE)
            old = subprocess.run(["git", "-C", str(HERE), "show", f"{ref}:./{rel}"], capture_output=True, text=True)
            if old.returncode:
                return None
            (tmp / f"{n}.svg").write_text(old.stdout)
            return (tmp / f"{n}.svg").as_uri()

        def cell(n):
            now, was = src(n), src(n, args.ref) if args.ref else None
            big = "".join(f"<img src='{u}' width=180 height=180>" for u in (was, now) if u)
            small = "".join(f"<img src='{u}' width={s} height={s} style='border-radius:{s * .22:.0f}px'>"
                            for u in (was, now) if u for s in (60, 29))
            return f"<div class=c>{big}<br>{small}<br>{html.escape(n)}</div>"

        rows = ""
        for e in m["elements"]:
            group = [n for n in picked if m["plates"][n] == e]
            if group:
                rows += f"<h3>{e} {m['elements'][e]['tile']}</h3>" + "".join(cell(n) for n in group)
        per = 2 if args.ref else 1
        page = ("<style>body{margin:8px;background:#888;font:13px sans-serif}h3{margin:10px 0 2px;clear:both}"
                f".c{{float:left;text-align:center;margin:4px;width:{184 * per}px}}img{{margin:2px}}</style>" + rows
                + "<div style='clear:both'></div>")
        (tmp / "sheet.html").write_text(page)
        cols = max(1, 1500 // (184 * per + 8))
        height = sum(46 + -(-len([n for n in picked if m["plates"][n] == e]) // cols) * 290
                     for e in m["elements"] if any(m["plates"][n] == e for n in picked)) + 30
        subprocess.run([CHROME, "--headless", "--disable-gpu", "--hide-scrollbars", "--allow-file-access-from-files",
                        "--force-device-scale-factor=2", f"--window-size=1520,{height}",
                        f"--screenshot={Path(args.out).resolve()}", (tmp / "sheet.html").as_uri()],
                       check=True, capture_output=True)
    print(args.out)
    return 0


# ---- mac icons -----------------------------------------------------------------------------------------------------

def mac(args):
    m = manifest()
    picked = names(m, args.names) if args.names else [n for n in sorted(m["plates"]) if (MAC / f"{n}.png").exists()]
    for n in picked:
        inner = re.sub(r"<\?xml[^>]*\?>", "", (PLATES / f"{n}.svg").read_text())
        inner = re.sub(r"<svg\b", '<svg x="100" y="100"', inner, count=1)
        inner = re.sub(r'\swidth="[^"]*"', ' width="824"', inner, count=1)
        inner = re.sub(r'\sheight="[^"]*"', ' height="824"', inner, count=1)
        wrap = ('<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024"><defs>'
                '<clipPath id="tile"><rect x="100" y="100" width="824" height="824" rx="185"/></clipPath>'
                '<filter id="sh" x="-20%" y="-20%" width="140%" height="140%">'
                '<feDropShadow dx="0" dy="10" stdDeviation="14" flood-color="#000" flood-opacity=".3"/></filter></defs>'
                '<rect x="100" y="100" width="824" height="824" rx="185" fill="#000" filter="url(#sh)"/>'
                f'<g clip-path="url(#tile)">{inner}</g></svg>')
        with tempfile.NamedTemporaryFile("w", suffix=".svg") as f:
            f.write(wrap); f.flush()
            subprocess.run(["resvg", "-w", "1024", "-h", "1024", f.name, str(MAC / f"{n}.png")], check=True)
        print(f"mac/{n}.png")
    return 0


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="what", required=True)
    for name, fn in (("lint", lint), ("retile", retile), ("markers", markers), ("mac", mac)):
        s = sub.add_parser(name); s.add_argument("names", nargs="*"); s.set_defaults(fn=fn)
    s = sub.add_parser("sheet"); s.add_argument("out"); s.add_argument("names", nargs="*")
    s.add_argument("--ref"); s.add_argument("--only"); s.set_defaults(fn=sheet)
    args = p.parse_args()
    return args.fn(args)


if __name__ == "__main__":
    sys.exit(main())
