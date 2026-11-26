#!/usr/bin/env python3
"""Write the Hoard plate into the iPhone and Apple TV icon files of ~/Projects/hoard-apple (a Swiftfin fork).

    python3 hoard_apple.py

plates.py export covers icon sets, web icons and SVGs; these files are other shapes, so they are drawn here:
  iPhone   the Icon Composer layer (1024 square, no alpha) and the in-app plate images (the Mac tile at 400 and 600 px)
  Apple TV the layered icon (back: the diagram on a wide tile; front: the focal object alone, so it floats on parallax)
           and the Top Shelf stills (the whole plate centred on a wide tile)
The focal object is taken to be everything from the first cream-stroked group to the end of hoard.svg.
"""
import json
import re
import subprocess
import tempfile
from pathlib import Path

import plates

REPO = Path.home() / "Projects/hoard-apple"
TV = REPO / "Swiftfin tvOS/Resources/Assets.xcassets/App Icon & Top Shelf Image.brandassets"
TILE = json.loads((plates.PLATES / "elements.json").read_text())["elements"]["earth"]["tile"]


def parts():
    body = plates.body("hoard")
    cut = body.index('<g fill="none" stroke="#e8dcc0"')
    return body[:cut], body[cut:]


def wide(inner, w, h, side, tile=True):
    s = side * h
    bg = f'<rect width="{w}" height="{h}" fill="{TILE}"/>' if tile else ""
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}">{bg}'
            f'<svg x="{(w - s) / 2}" y="{(h - s) / 2}" width="{s}" height="{s}" viewBox="0 0 120 120">{inner}</svg></svg>')


def draw(svg, out, w, h):
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / "in.svg"
        src.write_text(svg)
        subprocess.run(["resvg", "-w", str(w), "-h", str(h), str(src), str(out)], check=True)
    print(out.relative_to(REPO))


def main():
    back, front = parts()
    back = re.sub(r'<rect x="0" y="0" width="120" height="120"[^>]*/>', "", back)  # the wide tile replaces the square one
    plates.render(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">{plates.body("hoard")}</svg>',
                  REPO / "Swiftfin/Resources/AppIcons/AppIcon-hoard.icon/Assets/Plate.png", 1024, flat=True)
    for name in ("hoard-launch", "jellyfin-blob-blue"):
        for scale, px in (("2x", 400), ("3x", 600)):
            plates.render(plates.mac_svg("hoard"), REPO / f"Shared/Resources/Assets.xcassets/{name}.imageset/hoard-plate@{scale}.png", px)
    icon, store = TV / "App Icon.imagestack", TV / "App Icon - App Store.imagestack"
    for stack, layer, file, w, h in ((icon, "Back", "back.png", 400, 240), (icon, "Back", "back@2x.png", 800, 480),
                                     (icon, "Front", "front.png", 400, 240), (icon, "Front", "front@2x.png", 800, 480),
                                     (store, "Back", "1280x768-back.png", 1280, 768), (store, "Front", "512.png", 1280, 768)):
        inner, tile = (back, True) if layer == "Back" else (front, False)
        draw(wide(inner, w, h, .93, tile), stack / f"{layer}.imagestacklayer/Content.imageset/{file}", w, h)
    whole = back + front
    for folder, sizes in (("Top Shelf Image", ((1920, 720), (3840, 1440))), ("Top Shelf Image Wide", ((2320, 720), (4640, 1440)))):
        for (w, h), files in zip(sizes, (("top shelf.png", "top shelf-1.png"), ("Untitled-1.png", "Untitled-2.png"))):
            for f in files:
                draw(wide(whole, w, h, .8), TV / f"{folder}.imageset" / f, w, h)


if __name__ == "__main__":
    main()
