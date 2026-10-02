# Midnight Sun

Navy-tinted dark with a sunshine-yellow accent, shared across apps.

- **Edit** `palette.json`, then run `./build.py` to regenerate every app's file.
- **Logseq**: paste `logseq.css` into Settings → General → Custom theme → Edit custom.css (dark mode).
- **iTerm2**: `iterm-profile.json` is a dynamic profile, symlinked by `link.sh` and set as the default profile.
- **VS Code**: `vscode/` is a local theme extension, symlinked into `~/.vscode/extensions` by `link.sh`.
- **Linear**: enter the values in `linear.txt` under Settings → Preferences → Interface theme → Custom.
- **iPhone icons**: `build.py` also runs `icons.py`. For each app in `icons.json` it draws a navy tile with a sun-yellow glyph (Simple Icons logo, or Phosphor for Apple's apps and apps without one) and signs a Shortcuts file that opens the app. Output goes to `ios/` (git-ignored), and the PNGs are copied to iCloud Drive → `Midnight Sun icons`. Needs `resvg` (Brewfile) and macOS's `shortcuts` command.
  - **New app:** add it to `icons.json` (its bundle id is in `https://itunes.apple.com/lookup?bundleId=…` results, or search by name), run `./build.py`, open `ios/shortcuts/<App>.shortcut` on the Mac and click Add Shortcut. It syncs to the phone through iCloud.
  - **On the phone, once per app:** Shortcuts → the shortcut's ⋯ → its name → Add to Home Screen → Image → Choose File → `Midnight Sun icons/<App>.png` → Add. Then move the real app off the home screen (it stays in the App Library).
  - **Palette change:** `./build.py` rewrites the PNGs, but the phone keeps the image it was given, so each icon has to be added again. Themed icons never show notification badges.
  - A self-hosted MDM would update them silently, but Apple only issues MDM push certificates to organisations, not for personal devices.
