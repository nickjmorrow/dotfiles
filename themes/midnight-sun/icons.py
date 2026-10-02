"""Midnight Sun iPhone icons: a navy tile with a sun-yellow glyph for each app in icons.json.

For each app this writes, under ios/ (git-ignored):
  png/<name>.png             1024px square icon (iOS rounds the corners itself)
  shortcuts/<name>.shortcut  signed Shortcuts file whose only action opens the app

Private apps and menus can go in ~/.config/midnight-sun/icons.local.json (same format).
Each entry in "menus" gets one icon too, whose shortcut shows a menu of its apps: a folder
stand-in, since iOS folders can't have their own icon.

and copies the PNGs to the iCloud Drive folder "Midnight Sun icons", where the phone's
"Add to Home Screen" file picker can reach them. A shortcut never changes with the palette,
so it is only signed again when its app changes.

Glyphs come from Simple Icons (CC0) and Phosphor (MIT), pinned below and cached in glyphs/
so a rebuild needs no network. Apps with no glyph get their App Store icon, recoloured from
navy (dark) to sun (light). Needs resvg (Homebrew) and macOS's shortcuts CLI.
"""
import base64
import json
import plistlib
import re
import shutil
import subprocess
import tempfile
import time
import uuid
import urllib.parse
import urllib.request
from pathlib import Path

HERE = Path(__file__).resolve().parent
GLYPHS = HERE / "glyphs"
OUT = HERE / "ios"
CACHE = OUT / "cache"
LOCAL = Path.home() / ".config/midnight-sun/icons.local.json"
ICLOUD = Path.home() / "Library/Mobile Documents/com~apple~CloudDocs/Midnight Sun icons"

SIMPLE_ICONS = "16.33.0"
PHOSPHOR = "2.1.1"
SIZE = 1024
# Share of the tile the glyph's viewBox fills. Phosphor's viewBox has built-in padding.
GLYPH_SCALE = {"simple": 0.50, "phosphor": 0.66}


def fetch(url):
    req = urllib.request.Request(url, headers={"User-Agent": "midnight-sun-icons"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read()


def cached(path, url):
    if not path.exists():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(fetch(url))
    return path.read_bytes()


def simple_titles():
    url = f"https://cdn.jsdelivr.net/npm/simple-icons@{SIMPLE_ICONS}/data/simple-icons.json"
    data = json.loads(cached(CACHE / f"simple-icons-{SIMPLE_ICONS}.json", url))
    icons = data if isinstance(data, list) else data["icons"]
    return {i["title"].casefold(): i["slug"] for i in icons}


def glyph_for(app, titles):
    """('simple', slug) | ('phosphor', name) | ('artwork', None)"""
    if "glyph" in app:
        kind, _, name = app["glyph"].partition(":")
        return kind, name or None
    slug = titles().get(app["name"].casefold())
    return ("simple", slug) if slug else ("artwork", None)


def glyph_svg(kind, name):
    if kind == "simple":
        url = f"https://cdn.jsdelivr.net/npm/simple-icons@{SIMPLE_ICONS}/icons/{name}.svg"
    else:
        url = f"https://cdn.jsdelivr.net/npm/@phosphor-icons/core@{PHOSPHOR}/assets/regular/{name}.svg"
    return cached(GLYPHS / kind / f"{name}.svg", url).decode()


def tile_svg(kind, name, tile, sun):
    src = glyph_svg(kind, name)
    view_box = re.search(r'viewBox="([^"]+)"', src).group(1)
    inner = re.sub(r"^.*?<svg[^>]*>|</svg>\s*$", "", src, flags=re.S)
    box = SIZE * GLYPH_SCALE[kind]
    at = (SIZE - box) / 2
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{SIZE}" height="{SIZE}">'
            f'<rect width="{SIZE}" height="{SIZE}" fill="{tile}"/>'
            f'<svg x="{at}" y="{at}" width="{box}" height="{box}" viewBox="{view_box}" '
            f'fill="{sun}" color="{sun}">{inner}</svg></svg>')


def channel(hex_color, i):
    return int(hex_color[1 + 2 * i:3 + 2 * i], 16) / 255


def artwork_svg(app, tile, sun):
    """The App Store icon in greyscale, then dark → tile and light → sun."""
    path = CACHE / "artwork" / f"{app['bundle']}.png"
    if not path.exists():
        q = urllib.parse.urlencode({"bundleId": app["bundle"], "country": "us"})
        results = json.loads(fetch(f"https://itunes.apple.com/lookup?{q}"))["results"]
        if not results:
            raise SystemExit(f"icons: no App Store entry for {app['name']} ({app['bundle']})")
        url = re.sub(r"/\d+x\d+bb\.\w+$", f"/{SIZE}x{SIZE}bb.png", results[0]["artworkUrl512"])
        cached(path, url)
    data = base64.b64encode(path.read_bytes()).decode()
    funcs = "".join(
        f'<feFunc{c} type="table" tableValues="{channel(tile, i):.4f} {channel(sun, i):.4f}"/>'
        for i, c in enumerate("RGB"))
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{SIZE}" height="{SIZE}">'
            f'<filter id="duo" color-interpolation-filters="sRGB">'
            f'<feColorMatrix type="saturate" values="0"/><feComponentTransfer>{funcs}</feComponentTransfer>'
            f'</filter><image width="{SIZE}" height="{SIZE}" filter="url(#duo)" '
            f'href="data:image/png;base64,{data}"/></svg>')


def render(svg, out):
    out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile("w", suffix=".svg") as f:
        f.write(svg)
        f.flush()
        subprocess.run(["resvg", "-w", str(SIZE), "-h", str(SIZE), f.name, str(out)], check=True)


def open_app(app):
    selected = {"BundleIdentifier": app["bundle"], "Name": app["name"]}
    return {"WFWorkflowActionIdentifier": "is.workflow.actions.openapp",
            "WFWorkflowActionParameters": {"WFAppIdentifier": app["bundle"], "WFSelectedApp": selected}}


def open_url(url):
    text = {"Value": {"string": url, "attachmentsByRange": {}}, "WFSerializationType": "WFTextTokenString"}
    return {"WFWorkflowActionIdentifier": "is.workflow.actions.openurl",
            "WFWorkflowActionParameters": {"WFInput": text}}


def menu_actions(menu):
    """Choose from Menu with one item per app, each opening its app (bundle) or website (url)."""
    group = str(uuid.uuid5(uuid.NAMESPACE_URL, "midnight-sun-menu:" + menu["name"])).upper()

    def step(mode, **params):
        return {"WFWorkflowActionIdentifier": "is.workflow.actions.choosefrommenu",
                "WFWorkflowActionParameters": {"GroupingIdentifier": group, "WFControlFlowMode": mode, **params}}

    actions = [step(0, WFMenuPrompt=menu["name"], WFMenuItems=[a["name"] for a in menu["apps"]])]
    for app in menu["apps"]:
        target = open_app(app) if "bundle" in app else open_url(app["url"])
        actions += [step(1, WFMenuItemTitle=app["name"]), target]
    return actions + [step(2)]


def shortcut(name, actions, out):
    """Sign a shortcut with these actions; skipped when they haven't changed."""
    stamp = out.with_suffix(".actions")
    key = json.dumps(actions, sort_keys=True)
    if out.exists() and stamp.exists() and stamp.read_text() == key:
        return
    workflow = {
        "WFWorkflowClientVersion": "2607",
        "WFWorkflowMinimumClientVersion": 900,
        "WFWorkflowMinimumClientVersionString": "900",
        "WFWorkflowIcon": {"WFWorkflowIconStartColor": 255, "WFWorkflowIconGlyphNumber": 59511},
        "WFWorkflowTypes": [],
        "WFWorkflowInputContentItemClasses": [],
        "WFWorkflowImportQuestions": [],
        "WFWorkflowActions": actions,
    }
    out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(suffix=".shortcut") as f:
        plistlib.dump(workflow, f, fmt=plistlib.FMT_BINARY)
        f.flush()
        # Signing goes through Apple's servers and now and then fails for no reason; retry.
        for attempt in range(3):
            run = subprocess.run(["shortcuts", "sign", "--mode", "anyone", "--input", f.name,
                                  "--output", str(out)], capture_output=True, text=True)
            if run.returncode == 0:
                break
            time.sleep(2 * (attempt + 1))
        else:
            raise SystemExit(f"icons: couldn't sign {name}: {run.stderr.strip()}")
    stamp.write_text(key)


def build(palette):
    tile, sun = palette["surface"]["navy900"], palette["accent"]["sun"]
    config = json.loads((HERE / "icons.json").read_text())
    apps, menus = config["apps"], config.get("menus", [])
    if LOCAL.exists():  # private apps and menus, kept out of this public repo
        local = json.loads(LOCAL.read_text())
        apps, menus = apps + local.get("apps", []), menus + local.get("menus", [])
    index = {}

    def titles():
        if not index:
            index.update(simple_titles())
        return index

    counts = {}
    for app in apps:
        kind, name = glyph_for(app, titles)
        svg = artwork_svg(app, tile, sun) if kind == "artwork" else tile_svg(kind, name, tile, sun)
        render(svg, OUT / "png" / f"{app['name']}.png")
        shortcut(app["name"], [open_app(app)], OUT / "shortcuts" / f"{app['name']}.shortcut")
        counts[kind] = counts.get(kind, 0) + 1
    for menu in menus:
        kind, name = menu["glyph"].split(":")
        render(tile_svg(kind, name, tile, sun), OUT / "png" / f"{menu['name']}.png")
        shortcut(menu["name"], menu_actions(menu), OUT / "shortcuts" / f"{menu['name']}.shortcut")

    if ICLOUD.parent.exists():
        ICLOUD.mkdir(exist_ok=True)
        for png in (OUT / "png").glob("*.png"):
            shutil.copy2(png, ICLOUD / png.name)
    print("icons:", len(apps), "apps", counts, "+", len(menus), "menus")
