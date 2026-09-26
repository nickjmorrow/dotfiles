#!/usr/bin/env python3
"""Generate every app's Midnight Sun theme from palette.json.

Outputs (all committed, so a fresh machine needs no build step):
  logseq.css                              palette block between the palette:start/end markers
  iterm-profile.json                      iTerm2 dynamic profile
  vscode/themes/midnight-sun-color-theme.json   VS Code color theme
  linear.txt                              values to enter in Linear's custom theme
"""
import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
P = json.loads((HERE / "palette.json").read_text())
S, T, A, X, SYN = P["surface"], P["text"], P["accent"], P["ansi"], P["syntax"]


def rgba(hex_color, alpha):
    r, g, b = (int(hex_color[i:i + 2], 16) for i in (1, 3, 5))
    return f"rgba({r}, {g}, {b}, {alpha})"


def alpha_hex(hex_color, alpha):
    return f"{hex_color}{round(alpha * 255):02x}"


# ── Logseq ──────────────────────────────────────────────────────────────
def build_logseq():
    names = {
        "--ms-navy-950": S["navy950"], "--ms-navy-900": S["navy900"],
        "--ms-navy-850": S["navy850"], "--ms-navy-800": S["navy800"],
        "--ms-navy-700": S["navy700"], "--ms-navy-600": S["navy600"],
        "--ms-text": T["primary"], "--ms-text-dim": T["dim"],
        "--ms-text-faint": T["faint"], "--ms-sun": A["sun"],
        "--ms-sun-bright": A["sunBright"],
        "--ms-sun-soft": rgba(A["sun"], 0.16), "--ms-sun-faint": rgba(A["sun"], 0.08),
    }
    block = "".join(f"  {k}: {v};\n" for k, v in names.items())
    path = HERE / "logseq.css"
    css = path.read_text()
    css = re.sub(
        r"(  /\* palette:start[^\n]*\n).*?(  /\* palette:end \*/)",
        lambda m: m.group(1) + block + m.group(2),
        css, flags=re.S)
    path.write_text(css)


# ── iTerm2 ──────────────────────────────────────────────────────────────
def iterm_color(hex_color):
    r, g, b = (int(hex_color[i:i + 2], 16) / 255 for i in (1, 3, 5))
    return {"Red Component": r, "Green Component": g, "Blue Component": b,
            "Alpha Component": 1, "Color Space": "sRGB"}


def build_iterm():
    order = ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"]
    profile = {
        "Name": "Midnight Sun",
        "Guid": "6d1e2a4c-midnight-sun-roland",
        "Dynamic Profile Parent Name": "Default",
        "Normal Font": "FiraCodeNerdFontMono-Regular 14",
        "Background Color": iterm_color(S["navy900"]),
        "Foreground Color": iterm_color(T["primary"]),
        "Bold Color": iterm_color(T["bright"]),
        "Cursor Color": iterm_color(A["sun"]),
        "Cursor Text Color": iterm_color(S["navy900"]),
        "Cursor Guide Color": iterm_color(S["navy800"]),
        "Selection Color": iterm_color(S["navy600"]),
        "Selected Text Color": iterm_color(T["bright"]),
        "Link Color": iterm_color(A["sun"]),
        "Badge Color": iterm_color(A["sun"]),
        "Tab Color": iterm_color(S["navy900"]),
        "Use Tab Color": True,
    }
    for i, name in enumerate(order):
        profile[f"Ansi {i} Color"] = iterm_color(X[name])
        profile[f"Ansi {i + 8} Color"] = iterm_color(X["bright" + name[0].upper() + name[1:]])
    (HERE / "iterm-profile.json").write_text(json.dumps({"Profiles": [profile]}, indent=2) + "\n")


# ── VS Code ─────────────────────────────────────────────────────────────
def build_vscode():
    sun, bg = A["sun"], S["navy900"]
    colors = {
        "editor.background": bg,
        "editor.foreground": T["primary"],
        "editorLineNumber.foreground": T["faint"],
        "editorLineNumber.activeForeground": sun,
        "editorCursor.foreground": sun,
        "editor.selectionBackground": S["navy600"],
        "editor.inactiveSelectionBackground": S["navy700"],
        "editor.lineHighlightBackground": S["navy850"],
        "editor.findMatchBackground": alpha_hex(sun, 0.35),
        "editor.findMatchHighlightBackground": alpha_hex(sun, 0.16),
        "editor.wordHighlightBackground": alpha_hex(sun, 0.12),
        "editorBracketMatch.background": alpha_hex(sun, 0.16),
        "editorBracketMatch.border": alpha_hex(sun, 0.5),
        "editorIndentGuide.background1": S["navy700"],
        "editorIndentGuide.activeBackground1": S["navy600"],
        "editorWhitespace.foreground": S["navy700"],
        "editorGutter.background": bg,
        "editorWidget.background": S["navy850"],
        "editorWidget.border": S["navy700"],
        "editorSuggestWidget.background": S["navy850"],
        "editorSuggestWidget.selectedBackground": S["navy700"],
        "editorSuggestWidget.highlightForeground": sun,
        "editorHoverWidget.background": S["navy850"],
        "editorGroupHeader.tabsBackground": S["navy950"],
        "editorGroup.border": S["navy800"],
        "tab.activeBackground": bg,
        "tab.activeForeground": T["primary"],
        "tab.activeBorderTop": sun,
        "tab.inactiveBackground": S["navy950"],
        "tab.inactiveForeground": T["faint"],
        "tab.border": S["navy950"],
        "activityBar.background": S["navy950"],
        "activityBar.foreground": T["primary"],
        "activityBar.inactiveForeground": T["faint"],
        "activityBar.activeBorder": sun,
        "activityBarBadge.background": sun,
        "activityBarBadge.foreground": S["navy950"],
        "sideBar.background": S["navy950"],
        "sideBar.foreground": T["dim"],
        "sideBarTitle.foreground": T["primary"],
        "sideBarSectionHeader.background": S["navy950"],
        "sideBarSectionHeader.foreground": T["primary"],
        "list.activeSelectionBackground": S["navy700"],
        "list.activeSelectionForeground": T["bright"],
        "list.inactiveSelectionBackground": S["navy800"],
        "list.hoverBackground": S["navy850"],
        "list.highlightForeground": sun,
        "list.focusOutline": alpha_hex(sun, 0.5),
        "titleBar.activeBackground": S["navy950"],
        "titleBar.activeForeground": T["primary"],
        "titleBar.inactiveBackground": S["navy950"],
        "titleBar.inactiveForeground": T["faint"],
        "statusBar.background": S["navy950"],
        "statusBar.foreground": T["dim"],
        "statusBar.debuggingBackground": sun,
        "statusBar.debuggingForeground": S["navy950"],
        "statusBar.noFolderBackground": S["navy950"],
        "statusBarItem.remoteBackground": sun,
        "statusBarItem.remoteForeground": S["navy950"],
        "panel.background": S["navy950"],
        "panel.border": S["navy800"],
        "panelTitle.activeBorder": sun,
        "panelTitle.activeForeground": T["primary"],
        "panelTitle.inactiveForeground": T["faint"],
        "terminal.background": bg,
        "terminal.foreground": T["primary"],
        "terminalCursor.foreground": sun,
        "terminal.selectionBackground": S["navy600"],
        "input.background": S["navy850"],
        "input.border": S["navy700"],
        "input.placeholderForeground": T["faint"],
        "inputOption.activeBorder": sun,
        "dropdown.background": S["navy850"],
        "dropdown.border": S["navy700"],
        "button.background": sun,
        "button.foreground": S["navy950"],
        "button.hoverBackground": A["sunBright"],
        "button.secondaryBackground": S["navy700"],
        "button.secondaryForeground": T["primary"],
        "badge.background": sun,
        "badge.foreground": S["navy950"],
        "focusBorder": alpha_hex(sun, 0.6),
        "textLink.foreground": sun,
        "textLink.activeForeground": A["sunBright"],
        "progressBar.background": sun,
        "scrollbarSlider.background": alpha_hex(S["navy600"], 0.6),
        "scrollbarSlider.hoverBackground": S["navy600"],
        "scrollbarSlider.activeBackground": alpha_hex(sun, 0.4),
        "widget.shadow": "#00000066",
        "quickInput.background": S["navy850"],
        "quickInputList.focusBackground": S["navy700"],
        "peekView.border": sun,
        "peekViewEditor.background": S["navy850"],
        "peekViewResult.background": S["navy950"],
        "peekViewTitle.background": S["navy950"],
        "gitDecoration.modifiedResourceForeground": sun,
        "gitDecoration.untrackedResourceForeground": X["green"],
        "gitDecoration.deletedResourceForeground": X["red"],
        "gitDecoration.ignoredResourceForeground": T["faint"],
        "editorGutter.modifiedBackground": sun,
        "editorGutter.addedBackground": X["green"],
        "editorGutter.deletedBackground": X["red"],
        "editorError.foreground": X["red"],
        "editorWarning.foreground": X["yellow"],
        "editorInfo.foreground": X["blue"],
        "breadcrumb.foreground": T["faint"],
        "breadcrumb.focusForeground": T["primary"],
        "minimap.background": bg,
    }
    for i, name in enumerate(["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"]):
        cap = name[0].upper() + name[1:]
        colors[f"terminal.ansi{cap}"] = X[name]
        colors[f"terminal.ansiBright{cap}"] = X["bright" + cap]

    def tok(scope, fg, style=None):
        s = {"foreground": fg}
        if style:
            s["fontStyle"] = style
        return {"scope": scope, "settings": s}

    token_colors = [
        tok(["comment", "punctuation.definition.comment"], T["faint"], "italic"),
        tok(["keyword", "storage.type", "storage.modifier", "keyword.control"], A["sun"]),
        tok(["keyword.operator", "punctuation"], T["dim"]),
        tok(["string", "string.template"], X["green"]),
        tok(["constant.numeric", "constant.language", "constant.character"], SYN["orange"]),
        tok(["entity.name.function", "support.function", "meta.function-call"], X["blue"]),
        tok(["entity.name.type", "entity.name.class", "support.type", "support.class"], X["cyan"]),
        tok(["variable", "meta.definition.variable"], T["primary"]),
        tok(["variable.parameter"], X["brightWhite"], "italic"),
        tok(["variable.other.property", "support.type.property-name", "meta.object-literal.key"], X["white"]),
        tok(["entity.name.tag"], A["sun"]),
        tok(["entity.other.attribute-name"], X["magenta"]),
        tok(["meta.decorator", "entity.name.function.decorator"], X["magenta"]),
        tok(["markup.heading", "entity.name.section"], A["sun"], "bold"),
        tok(["markup.bold"], T["bright"], "bold"),
        tok(["markup.italic"], T["primary"], "italic"),
        tok(["markup.inline.raw", "markup.fenced_code"], A["sunBright"]),
        tok(["markup.underline.link", "string.other.link"], A["sun"]),
        tok(["invalid"], X["red"]),
    ]
    theme = {"name": P["name"], "type": "dark", "colors": colors, "tokenColors": token_colors,
             "semanticHighlighting": True}
    (HERE / "vscode/themes/midnight-sun-color-theme.json").write_text(json.dumps(theme, indent=2) + "\n")


# ── Linear ──────────────────────────────────────────────────────────────
def build_linear():
    (HERE / "linear.txt").write_text(
        "Linear → Settings → Preferences → Interface theme → Custom\n"
        f"Background: {S['navy900']}\nText:       {T['primary']}\nAccent:     {A['sun']}\n")


if __name__ == "__main__":
    build_logseq()
    build_iterm()
    build_vscode()
    build_linear()
    print("Built Midnight Sun for Logseq, iTerm2, VS Code and Linear.")
