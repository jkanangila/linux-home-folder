#!/usr/bin/env bash
set -euo pipefail

APP_NAME="caelestia-keybinds"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/${APP_NAME}"
BIN_DIR="${HOME}/.local/bin"
DESKTOP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"

if ! command -v qs >/dev/null 2>&1 && ! command -v quickshell >/dev/null 2>&1; then
    echo "Quickshell was not found. Install it first:"
    echo "  sudo pacman -S quickshell      (or quickshell-git from the AUR)"
    exit 1
fi

if ! command -v hyprctl >/dev/null 2>&1; then
    echo "hyprctl was not found. Is Hyprland installed?"
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 was not found. Install it before running this installer."
    exit 1
fi

if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    echo "Not inside a Hyprland session (HYPRLAND_INSTANCE_SIGNATURE is unset)."
    echo "Run this installer from a terminal inside Hyprland."
    exit 1
fi

if ! command -v wl-copy >/dev/null 2>&1; then
    echo "Note: wl-copy not found. Install wl-clipboard for the copy button:"
    echo "  sudo pacman -S wl-clipboard"
fi

mkdir -p "$CONFIG_DIR" "$BIN_DIR" "$DESKTOP_DIR"

# Quickshell loads shell.qml from the config directory.
cat >"$CONFIG_DIR/shell.qml" <<'QML'
//@ pragma UseQApplication
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

FloatingWindow {
    id: root
    title: "Caelestia Keybinds"
    implicitWidth: 1080
    implicitHeight: 760
    minimumSize: Qt.size(760, 480)
    color: "#111318"
    visible: true

    property var bindings: []
    property string rawBinds: ""
    property string searchText: ""
    property string selectedCategory: "All"
    property string statusText: "Loading active Hyprland bindings…"

    // Loaded from descriptions.json (user-editable, see installer notes).
    property var luaDescriptions: ({})
    property var chordDescriptions: ({})

    // Recomputed only when bindings, searchText or selectedCategory change.
    readonly property var filtered: filteredBindings()

    function modifierNames(mask) {
        var names = []
        var m = Number(mask || 0)
        // Hyprland modifier bitmasks: SHIFT=1, CAPS=2, CTRL=4, ALT=8,
        // MOD2=16, MOD3=32, SUPER=64, MOD5=128.
        if (m & 64) names.push("SUPER")
        if (m & 8) names.push("ALT")
        if (m & 4) names.push("CTRL")
        if (m & 1) names.push("SHIFT")
        if (m & 16) names.push("MOD2")
        if (m & 32) names.push("MOD3")
        if (m & 128) names.push("MOD5")
        if (m & 2) names.push("CAPS")
        return names
    }

    // Categorizes from the human-readable description text.
    // Used for _lua binds (whose dispatcher/arg say nothing useful) and as a fallback.
    function categorizeText(text) {
        var t = String(text || "").toLowerCase()
        if (!t.length) return "Other"
        if (/special workspace|^toggle .*workspace/.test(t)) return "Special workspaces"
        if (/workspace/.test(t)) return "Workspaces"
        if (/screenshot|record|color|picker/.test(t)) return "Screenshots & utilities"
        if (/brightness|volume|mute|media|track|playback|audio|sleep|suspend/.test(t)) return "Media & system"
        if (/window|fullscreen|maximized|floating|\bpin\b|group/.test(t)) return "Window management"
        if (/caelestia|sidebar|session|notification|panels|overview|lock/.test(t)) return "Caelestia"
        if (/^open |^run command/.test(t)) return "Applications"
        return "Other"
    }

    function categorize(b, description) {
        var d = String(b.dispatcher || "").toLowerCase()
        var a = String(b.arg || "").toLowerCase()
        var k = String(b.key || "").toLowerCase()

        // Caelestia callbacks: the dispatcher says nothing, the description does.
        if (d === "_lua")
            return categorizeText(description)

        // Caelestia's own binds may use the "global" dispatcher, e.g. "caelestia:launcher".
        if (d === "global") {
            if (a.indexOf("screenshot") >= 0 || a.indexOf("record") >= 0 ||
                a.indexOf("clip") >= 0 || a.indexOf("picker") >= 0)
                return "Screenshots & utilities"
            if (a.indexOf("workspace") >= 0)
                return "Workspaces"
            if (a.indexOf("media") >= 0 || a.indexOf("brightness") >= 0 ||
                a.indexOf("volume") >= 0)
                return "Media & system"
            return "Caelestia"
        }
        if (d.indexOf("togglespecialworkspace") >= 0 ||
            d.indexOf("special") >= 0 || a.indexOf("special") >= 0)
            return "Special workspaces"
        if (d.indexOf("workspace") >= 0 || d.indexOf("movetoworkspace") >= 0)
            return "Workspaces"
        if (d.indexOf("screenshot") >= 0 || a.indexOf("grim") >= 0 ||
            a.indexOf("slurp") >= 0 || a.indexOf("screenshot") >= 0 ||
            a.indexOf("record") >= 0)
            return "Screenshots & utilities"
        if (d.indexOf("kill") >= 0 || d.indexOf("fullscreen") >= 0 ||
            d.indexOf("move") >= 0 || d.indexOf("resize") >= 0 ||
            d.indexOf("togglefloating") >= 0 || d.indexOf("pin") >= 0 ||
            d.indexOf("center") >= 0 || d.indexOf("pseudo") >= 0 ||
            d.indexOf("group") >= 0 || d.indexOf("cyclenext") >= 0)
            return "Window management"
        if (d.indexOf("exec") >= 0 || d.indexOf("execr") >= 0 ||
            a.indexOf("launcher") >= 0 || a.indexOf("terminal") >= 0) {
            // Media/system commands launched via exec.
            if (k.indexOf("volume") >= 0 || a.indexOf("volume") >= 0 ||
                a.indexOf("brightness") >= 0 || a.indexOf("playerctl") >= 0 ||
                a.indexOf("audio") >= 0 || a.indexOf("media") >= 0 ||
                a.indexOf("wpctl") >= 0)
                return "Media & system"
            return "Applications"
        }
        if (k.indexOf("volume") >= 0 || a.indexOf("volume") >= 0 ||
            a.indexOf("brightness") >= 0 || a.indexOf("playerctl") >= 0 ||
            a.indexOf("audio") >= 0 || a.indexOf("media") >= 0)
            return "Media & system"
        return categorizeText(description)
    }

    // Normalize key names so Page_Down, page_down and PAGEDOWN match the
    // descriptions table. Modifier order follows modifierNames().
    function canonicalChord(chord) {
        var parts = String(chord || "").split(" + ")
        var modifiers = []
        var key = ""
        for (var i = 0; i < parts.length; i++) {
            var part = parts[i].trim().toUpperCase().replace(/_/g, "")
            if (["SUPER", "ALT", "CTRL", "SHIFT", "MOD2", "MOD3", "MOD5", "CAPS"].indexOf(part) >= 0)
                modifiers.push(part)
            else
                key = part
        }
        var order = ["SUPER", "ALT", "CTRL", "SHIFT", "MOD2", "MOD3", "MOD5", "CAPS"]
        modifiers.sort(function(a, b) { return order.indexOf(a) - order.indexOf(b) })
        if (key) modifiers.push(key)
        return modifiers.join(" + ")
    }

    // Chord descriptions are checked before the Lua line map so custom
    // key assignments always display the user's intended action.
    function describeBinding(chord, keyName, dispatcher, arg, supplied) {
        var normalizedChord = canonicalChord(chord)
        if (root.chordDescriptions[normalizedChord] !== undefined)
            return root.chordDescriptions[normalizedChord]

        // The five modifier prefixes below are used with workspace numbers 0-9.
        if (/^[0-9]$/.test(String(keyName))) {
            if (normalizedChord.indexOf("SUPER + ALT + CTRL + ") === 0 && normalizedChord.endsWith(" + " + keyName))
                return "Move active window to workspace group " + keyName
            if (normalizedChord.indexOf("SUPER + CTRL + ") === 0 && normalizedChord.endsWith(" + " + keyName))
                return "Focus workspace group " + keyName
            if (normalizedChord.indexOf("SUPER + ALT + ") === 0 && normalizedChord.endsWith(" + " + keyName))
                return "Move active window to workspace " + keyName
            if (normalizedChord.indexOf("SUPER + SHIFT + ") === 0 && normalizedChord.endsWith(" + " + keyName))
                return "Move active window silently to workspace " + keyName
            if (normalizedChord.indexOf("SUPER + ") === 0 && normalizedChord.endsWith(" + " + keyName))
                return "Focus workspace " + keyName
        }

        if (supplied && supplied.trim().length)
            return supplied.trim()

        var action = String(dispatcher || "").toLowerCase()
        var argument = String(arg || "").toLowerCase()

        if (action === "exec" || action === "execr" || action === "execraw") {
            if (argument.indexOf("caelestia screenshot") >= 0) return "Take a screenshot"
            if (argument.indexOf("caelestia record") >= 0) return "Record the screen"
            if (argument.indexOf("hyprpicker") >= 0) return "Pick a screen color"
            if (argument.indexOf("wpctl set-mute @default_audio_sink@ toggle") >= 0) return "Toggle output audio mute"
            if (argument.indexOf("wpctl set-mute @default_audio_source@ toggle") >= 0) return "Toggle microphone mute"
            if (argument.indexOf("playerctl") >= 0) return "Control media playback"
            if (argument.indexOf("brightness") >= 0) return "Adjust screen brightness"
            if (/cliphist|clipboard/.test(argument)) return "Open clipboard history"
            if (argument.indexOf("emoji") >= 0) return "Open emoji picker"
            if (/\b(kitty|foot|footclient|alacritty|wezterm|ghostty)\b/.test(argument)) return "Open terminal"
            if (/\b(firefox|zen|chromium|chrome|brave)\b/.test(argument)) return "Open web browser"
            if (/\b(thunar|dolphin|nautilus|nemo)\b/.test(argument)) return "Open file manager"
            if (/\b(hyprlock|swaylock|lock)\b/.test(argument)) return "Lock the screen"
            return "Run command: " + arg
        }

        if (action === "global")
            return "Caelestia action: " + String(arg || "").replace(/^caelestia:/, "")

        if (action === "_lua") {
            // arg is a Lua callback source-line number in Caelestia's keybinds.lua.
            // The line map lives in descriptions.json so updates don't need a reinstall.
            var line = String(arg || "").trim()
            var mapped = root.luaDescriptions[line]
            if (mapped !== undefined)
                return String(mapped).replace("{key}", String(keyName).toUpperCase())
            if (root.chordDescriptions[normalizedChord] !== undefined)
                return root.chordDescriptions[normalizedChord]
            if (/^\d+$/.test(line))
                return "Caelestia Lua action (source line " + line + ") — not mapped, edit descriptions.json"
            return "Caelestia Lua action"
        }

        // Generic dispatchers. Order matters: more specific names first.
        if (action.indexOf("togglespecialworkspace") >= 0) return "Toggle a special workspace"
        if (action.indexOf("movetoworkspace") >= 0) return "Move the active window to a workspace"
        if (action.indexOf("workspace") >= 0) return "Switch workspace"
        if (action.indexOf("fullscreen") >= 0) return "Toggle fullscreen"
        if (action.indexOf("float") >= 0) return "Toggle floating window"
        if (action.indexOf("killactive") >= 0 || action.indexOf("close") >= 0) return "Close the active window"
        if (action.indexOf("focus") >= 0) return "Change window focus"
        if (action.indexOf("cyclenext") >= 0) return "Focus the next window"
        if (action.indexOf("group") >= 0) return "Window group action"
        if (action.indexOf("move") >= 0) return "Move the active window"
        if (action.indexOf("resize") >= 0) return "Resize the active window"
        if (/\bpin\b/.test(action)) return "Pin or unpin the active window"

        if (root.chordDescriptions[normalizedChord] !== undefined)
            return root.chordDescriptions[normalizedChord]

        return ""
    }

    function loadDescriptions(raw) {
        try {
            var parsed = JSON.parse(raw)
            root.luaDescriptions = parsed.lua || ({})
            root.chordDescriptions = parsed.chords || ({})
            rebuild()
        } catch (e) {
            root.statusText = "Could not parse descriptions.json: " + e
        }
    }

    function loadBindings(raw) {
        root.rawBinds = raw
        rebuild()
    }

    function rebuild() {
        if (!root.rawBinds || !root.rawBinds.length) return
        try {
            var parsed = JSON.parse(root.rawBinds)
            var rows = []
            for (var i = 0; i < parsed.length; i++) {
                var b = parsed[i]
                var keyName = String(b.key || "")
                if (!keyName && b.keycode !== undefined && b.keycode !== 0)
                    keyName = "KEYCODE " + b.keycode
                // "mouse" is a boolean in hyprctl's JSON output.
                if (!keyName && b.mouse === true)
                    keyName = "MOUSE"
                if (!keyName) keyName = "ANY KEY"

                var mods = modifierNames(b.modmask)
                var chord = (mods.length ? mods.join(" + ") + " + " : "") + keyName.toUpperCase()
                var dispatcher = String(b.dispatcher || "")
                var arg = String(b.arg || "")
                var description = describeBinding(chord, keyName, dispatcher, arg, String(b.description || ""))

                rows.push({
                    chord: chord,
                    key: keyName,
                    dispatcher: dispatcher,
                    arg: arg,
                    description: description,
                    category: categorize(b, description),
                    submap: String(b.submap || "default")
                })
            }
            rows.sort(function(a, b) {
                var c = a.category.localeCompare(b.category)
                return c !== 0 ? c : a.chord.localeCompare(b.chord)
            })
            root.bindings = rows
            root.statusText = rows.length + " active bindings • refreshed just now"
        } catch (e) {
            root.statusText = "Could not parse hyprctl output: " + e
        }
    }

    function filteredBindings() {
        var out = []
        var needle = searchText.trim().toLowerCase()
        for (var i = 0; i < bindings.length; i++) {
            var b = bindings[i]
            if (selectedCategory !== "All" && b.category !== selectedCategory) continue
            var haystack = (b.chord + " " + b.dispatcher + " " + b.arg + " " +
                            b.description + " " + b.category + " " + b.submap).toLowerCase()
            if (needle && haystack.indexOf(needle) < 0) continue
            out.push(b)
        }
        return out
    }

    function refreshBindings() {
        statusText = "Refreshing active Hyprland bindings…"
        bindProcess.running = false
        bindProcess.command = ["hyprctl", "binds", "-j"]
        bindProcess.running = true
    }

    Process {
        id: bindProcess
        command: ["hyprctl", "binds", "-j"]
        stdout: StdioCollector {
            onStreamFinished: root.loadBindings(this.text)
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text && this.text.trim().length > 0)
                    root.statusText = "hyprctl: " + this.text.trim()
            }
        }
    }

    FileView {
        id: descriptionsFile
        path: Quickshell.shellPath("descriptions.json")
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.loadDescriptions(descriptionsFile.text())
        onLoadFailed: root.statusText = "descriptions.json not loaded; showing raw actions"
    }

    Process { id: copyProcess }

    Component.onCompleted: {
        refreshBindings()
        searchField.forceActiveFocus()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 14

        Shortcut {
            sequence: "Escape"
            onActivated: Qt.quit()
        }

        Shortcut {
            sequence: "Ctrl+F"
            onActivated: searchField.forceActiveFocus()
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3
                Label {
                    text: "KEYBINDINGS"
                    color: "#c4b5fd"
                    font.pixelSize: 12
                    font.bold: true
                    font.letterSpacing: 2
                }
                Label {
                    text: "Caelestia · Hyprland"
                    color: "#f0f0f5"
                    font.pixelSize: 27
                    font.bold: true
                }
                Label {
                    text: root.statusText
                    color: "#a0a3b1"
                    font.pixelSize: 12
                }
            }

            Button {
                text: "↻  Refresh"
                onClicked: root.refreshBindings()
                palette.buttonText: "#f2f0ff"
                background: Rectangle {
                    radius: 10
                    color: parent.down ? "#6d5bb5" : "#39334f"
                    border.color: "#65578f"
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            TextField {
                id: searchField
                Layout.fillWidth: true
                placeholderText: "Search keys, actions, commands…  (Esc to close)"
                color: "#f0f0f5"
                placeholderTextColor: "#85899a"
                leftPadding: 14
                rightPadding: 14
                onTextChanged: root.searchText = text
                background: Rectangle {
                    radius: 10
                    color: "#1b1e26"
                    border.color: searchField.activeFocus ? "#a78bfa" : "#303440"
                }
            }

            ComboBox {
                id: categoryBox
                Layout.preferredWidth: 220
                model: ["All", "Applications", "Window management", "Workspaces",
                        "Special workspaces", "Screenshots & utilities",
                        "Media & system", "Caelestia", "Other"]
                onActivated: root.selectedCategory = currentText
                contentItem: Text {
                    leftPadding: 12
                    text: categoryBox.displayText
                    color: "#f0f0f5"
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    radius: 10
                    color: "#1b1e26"
                    border.color: "#303440"
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: root.filtered.length + " shown"
                color: "#a0a3b1"
                font.pixelSize: 12
            }
            Item { Layout.fillWidth: true }
            Label {
                text: "SUPER = Windows key"
                color: "#a0a3b1"
                font.pixelSize: 12
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 14
            color: "#171a21"
            border.color: "#2b2f3a"

            ListView {
                id: bindingList
                anchors.fill: parent
                anchors.margins: 10
                clip: true
                spacing: 7
                model: root.filtered
                ScrollBar.vertical: ScrollBar {}

                delegate: Rectangle {
                    required property var modelData
                    width: bindingList.width
                    height: contentColumn.implicitHeight + 20
                    radius: 10
                    color: "#20232c"
                    border.color: "#2d3240"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 12

                        Rectangle {
                            Layout.preferredWidth: 245
                            Layout.minimumWidth: 180
                            Layout.fillHeight: true
                            radius: 7
                            color: "#302a43"
                            border.color: "#51456e"
                            Text {
                                anchors.fill: parent
                                anchors.margins: 8
                                text: modelData.chord
                                color: "#e6ddff"
                                font.pixelSize: 12
                                font.bold: true
                                wrapMode: Text.Wrap
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        ColumnLayout {
                            id: contentColumn
                            Layout.fillWidth: true
                            spacing: 4
                            Label {
                                Layout.fillWidth: true
                                text: modelData.description.length ? modelData.description : modelData.dispatcher
                                color: "#f0f0f5"
                                font.pixelSize: 14
                                font.bold: true
                                wrapMode: Text.Wrap
                            }
                            Label {
                                Layout.fillWidth: true
                                // With no description the title already shows the dispatcher.
                                text: modelData.description.length
                                      ? modelData.dispatcher + (modelData.arg.length ? "  ·  " + modelData.arg : "")
                                      : modelData.arg
                                visible: text.length > 0
                                color: "#a0a3b1"
                                font.pixelSize: 11
                                wrapMode: Text.Wrap
                            }
                            RowLayout {
                                spacing: 8
                                Label {
                                    text: modelData.category
                                    color: "#c4b5fd"
                                    font.pixelSize: 10
                                }
                                Label {
                                    visible: modelData.submap !== "default"
                                    text: "submap: " + modelData.submap
                                    color: "#d8a56d"
                                    font.pixelSize: 10
                                }
                            }
                        }

                        ToolButton {
                            text: "⧉"
                            ToolTip.visible: hovered
                            ToolTip.text: "Copy shortcut and description"
                            onClicked: copyProcess.exec({
                                command: ["wl-copy", modelData.chord + " — " +
                                          (modelData.description.length
                                           ? modelData.description
                                           : (modelData.dispatcher + " " + modelData.arg).trim())]
                            })
                            background: Rectangle {
                                radius: 7
                                color: parent.down ? "#39334f" : "transparent"
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "#c4b5fd"
                                font.pixelSize: 18
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    visible: bindingList.count === 0
                    text: "No matching bindings"
                    color: "#85899a"
                    font.pixelSize: 16
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Live data from  hyprctl binds -j"
                color: "#777d8d"
                font.pixelSize: 11
            }
            Item { Layout.fillWidth: true }
            Label {
                text: "Descriptions: descriptions.json  ·  Copy uses wl-copy"
                color: "#777d8d"
                font.pixelSize: 11
            }
        }
    }
}
QML

# User-editable description tables. Defaults are merged with existing entries on reinstall.
# "lua" maps Caelestia's keybinds.lua callback source lines to text; these line numbers are
# specific to one version of that file and may need updating after Caelestia updates.
# "{key}" in a lua description is replaced with the pressed key.
# "chords" maps the configured shortcuts to their human-readable actions.
if [[ -f "$CONFIG_DIR/descriptions.json" ]]; then
    cp -f "$CONFIG_DIR/descriptions.json" "$CONFIG_DIR/descriptions.json.bak"
    DESCRIPTIONS_NOTE="  $CONFIG_DIR/descriptions.json   (updated; previous version backed up)"
else
    DESCRIPTIONS_NOTE="  $CONFIG_DIR/descriptions.json   (created)"
fi

cat >"$CONFIG_DIR/descriptions.defaults.json" <<'JSON'
{
  "lua": {
    "63": "Open Caelestia session menu",
    "64": "Toggle Caelestia sidebar",
    "65": "Clear notifications",
    "66": "Show all Caelestia panels",
    "67": "Lock the session",
    "70": "Restore or reinitialize the lock screen",
    "77": "Restart the Caelestia shell",
    "85": "Focus workspace by number ({key})",
    "86": "Move active window to workspace by number ({key})",
    "87": "Focus workspace group by number ({key})",
    "88": "Move active window to workspace group by number ({key})",
    "89": "Move active window to workspace silently ({key})",
    "93": "Focus previous workspace",
    "94": "Focus next workspace",
    "97": "Focus previous workspace group",
    "98": "Focus next workspace group",
    "101": "Move active window to next workspace",
    "102": "Move active window to previous workspace",
    "105": "Move active window to the special workspace",
    "106": "Move active window out of the special workspace",
    "109": "Focus next window",
    "110": "Focus previous window",
    "111": "Focus next window group",
    "112": "Focus previous window group",
    "113": "Toggle window group",
    "114": "Ungroup active window",
    "115": "Lock active window group",
    "119": "Focus window in direction ({key})",
    "120": "Move active window in direction ({key})",
    "123": "Decrease active window width",
    "124": "Increase active window width",
    "125": "Decrease active window height",
    "126": "Increase active window height",
    "130": "Center active window",
    "131": "Normalize active window size or state",
    "135": "Toggle picture-in-picture window mode",
    "147": "Pin or unpin active window",
    "148": "Toggle fullscreen",
    "149": "Toggle maximized (bordered fullscreen) mode",
    "150": "Toggle floating window",
    "151": "Close active window",
    "154": "Toggle special workspace",
    "155": "Toggle system monitor workspace",
    "156": "Toggle music workspace",
    "157": "Toggle communication workspace",
    "161": "Open terminal",
    "162": "Open web browser",
    "163": "Open editor",
    "164": "Open file explorer",
    "165": "Open audio settings",
    "169": "Take a frozen screenshot",
    "170": "Take a region screenshot",
    "177": "Increase screen brightness",
    "178": "Decrease screen brightness",
    "181": "Toggle media playback",
    "182": "Play next media track",
    "183": "Play previous media track",
    "184": "Stop media playback",
    "189": "Decrease output volume",
    "197": "Increase output volume",
    "206": "Run sleep or suspend action",
    "212": "Run the configured Caelestia overview action"
  },
  "chords": {
    "SUPER + ALT + S": "Move active window to the special workspace",
    "SUPER + CTRL + SHIFT + UP": "Move active window to the special workspace",
    "SUPER + CTRL + SHIFT + DOWN": "Move active window out of the special workspace",
    "SUPER + ALT + MOUSEDOWN": "Move active window to the next workspace",
    "SUPER + ALT + PAGEDOWN": "Move active window to the next workspace",
    "SUPER + CTRL + SHIFT + RIGHT": "Move active window to the next workspace",
    "SUPER + ALT + MOUSEUP": "Move active window to the previous workspace",
    "SUPER + ALT + PAGEUP": "Move active window to the previous workspace",
    "SUPER + CTRL + SHIFT + LEFT": "Move active window to the previous workspace",
    "SUPER + MOUSEDOWN": "Focus next workspace",
    "SUPER + CTRL + RIGHT": "Focus next workspace",
    "SUPER + PAGEDOWN": "Focus next workspace",
    "SUPER + MOUSEUP": "Focus previous workspace",
    "SUPER + CTRL + LEFT": "Focus previous workspace",
    "SUPER + PAGEUP": "Focus previous workspace",
    "SUPER + CTRL + MOUSEDOWN": "Focus next workspace group",
    "SUPER + CTRL + MOUSEUP": "Focus previous workspace group",
    "ALT + TAB": "Focus next window in the group",
    "ALT + SHIFT + TAB": "Focus previous window in the group",
    "ALT + CTRL + TAB": "Focus next window group",
    "ALT + CTRL + SHIFT + TAB": "Focus previous window group",
    "SUPER + U": "Ungroup the active window",
    "SUPER + COMMA": "Toggle window group",
    "SUPER + SHIFT + COMMA": "Lock the active window group",
    "SUPER + MINUS": "Decrease active window width",
    "SUPER + ALT + LEFT": "Decrease active window width",
    "SUPER + EQUAL": "Increase active window width",
    "SUPER + ALT + RIGHT": "Increase active window width",
    "SUPER + SHIFT + MINUS": "Decrease active window height",
    "SUPER + ALT + UP": "Decrease active window height",
    "SUPER + SHIFT + EQUAL": "Increase active window height",
    "SUPER + ALT + DOWN": "Increase active window height",
    "SUPER + Z": "Move active window",
    "SUPER + X": "Resize active window",
    "SUPER + CTRL + BACKSLASH": "Center active window",
    "SUPER + CTRL + ALT + BACKSLASH": "Normalize active window size or state",
    "SUPER + ALT + BACKSLASH": "Toggle picture-in-picture window mode",
    "SUPER + P": "Pin or unpin active window",
    "SUPER + F": "Toggle fullscreen",
    "SUPER + ALT + F": "Toggle bordered fullscreen",
    "SUPER + ALT + SPACE": "Toggle floating window",
    "SUPER + Q": "Close active window",
    "SUPER + S": "Toggle special workspace",
    "CTRL + SHIFT + ESCAPE": "Toggle system monitor workspace",
    "SUPER + M": "Toggle music workspace",
    "SUPER + D": "Toggle communication workspace",
    "SUPER + R": "Toggle todo workspace",
    "SUPER + ALT + N": "Toggle notes workspace",
    "SUPER + ALT + E": "Toggle files workspace",
    "SUPER + RETURN": "Open terminal",
    "SUPER + W": "Open web browser",
    "SUPER + C": "Open editor",
    "SUPER + E": "Open file explorer",
    "CTRL + ALT + V": "Open audio settings",
    "PRINT": "Take a screenshot",
    "SUPER + SHIFT + S": "Take a frozen screenshot",
    "SUPER + SHIFT + ALT + S": "Take a region screenshot",
    "CTRL + ALT + R": "Start or stop screen recording",
    "SUPER + ALT + R": "Start or stop screen recording with audio",
    "SUPER + SHIFT + ALT + R": "Record a selected region",
    "SUPER + SHIFT + C": "Pick a screen color",
    "SUPER + CTRL + SPACE": "Toggle media playback",
    "SUPER + CTRL + EQUAL": "Play next media track",
    "SUPER + CTRL + MINUS": "Play previous media track",
    "SUPER + CTRL + BACKSPACE": "Stop media playback",
    "SUPER + SHIFT + M": "Toggle output audio mute",
    "SUPER + SUPERL": "Open Caelestia launcher",
    "CTRL + ALT + DELETE": "Open session menu",
    "SUPER + N": "Toggle Caelestia sidebar",
    "CTRL + ALT + C": "Clear notifications",
    "SUPER + K": "Show all Caelestia panels",
    "SUPER + L": "Lock the session",
    "SUPER + ALT + L": "Restore or reinitialize the lock screen",
    "SUPER + SHIFT + L": "Sleep or suspend the system",
    "SUPER + V": "Open clipboard history",
    "SUPER + ALT + V": "Delete clipboard history entry or selection",
    "CTRL + SHIFT + ALT + V": "Paste the latest clipboard item",
    "SUPER + PERIOD": "Open emoji picker"
  }
}
JSON

# Merge defaults with the user's previous tables. New supplied keybind labels
# take precedence, while custom Lua/chord entries that do not conflict survive.
python3 - "$CONFIG_DIR/descriptions.defaults.json" "$CONFIG_DIR/descriptions.json" "$CONFIG_DIR/descriptions.json.bak" <<'PYTHON'
import json
import pathlib
import sys

source, destination, backup = map(pathlib.Path, sys.argv[1:])
defaults = json.loads(source.read_text())
existing = json.loads(backup.read_text()) if backup.exists() else {}
merged = {
    "lua": {**defaults.get("lua", {}), **existing.get("lua", {})},
    "chords": {**existing.get("chords", {}), **defaults.get("chords", {})},
}
destination.write_text(json.dumps(merged, indent=2, ensure_ascii=False) + "\n")
source.unlink()
PYTHON

cat >"$BIN_DIR/caelestia-keybinds" <<'LAUNCHER'
#!/usr/bin/env bash
set -euo pipefail

# Plain Qt Quick Controls style, so the custom backgrounds are supported.
export QT_QUICK_CONTROLS_STYLE=Basic

# Don't open a second window if one is already running.
if pgrep -f "(qs|quickshell) -c caelestia-keybinds" >/dev/null 2>&1; then
  exit 0
fi

if command -v qs >/dev/null 2>&1; then
  exec qs -c caelestia-keybinds
elif command -v quickshell >/dev/null 2>&1; then
  exec quickshell -c caelestia-keybinds
else
  printf '%s\n' "Quickshell not found. Install it with: sudo pacman -S quickshell" >&2
  exit 1
fi
LAUNCHER
chmod +x "$BIN_DIR/caelestia-keybinds"

cat >"$DESKTOP_DIR/caelestia-keybinds.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Caelestia Keybinds
GenericName=Hyprland Keyboard Shortcuts
Comment=Search active Hyprland keybindings
Exec="$BIN_DIR/caelestia-keybinds"
Icon=input-keyboard
Terminal=false
Categories=Utility;Settings;
DESKTOP

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true
fi

echo
echo "Installed Caelestia Keybinds."
echo "Launch now with: $BIN_DIR/caelestia-keybinds"
echo "Search for 'Caelestia Keybinds' in your app launcher."
echo
echo "Files:"
echo "  $CONFIG_DIR/shell.qml"
echo "$DESCRIPTIONS_NOTE"
echo "  $BIN_DIR/caelestia-keybinds"
echo "  $DESKTOP_DIR/caelestia-keybinds.desktop"
echo
echo "Descriptions and custom shortcut labels come from descriptions.json."
echo "Edit it any time; the window reloads it automatically. Unmapped binds say so."
echo "Workspace number shortcuts (SUPER, CTRL+SUPER, SUPER+ALT, SUPER+SHIFT, CTRL+SUPER+ALT) are described dynamically."
echo
echo "Optional: keep the window floating by adding a rule to your Hyprland config."
echo "  Older syntax:  windowrulev2 = float, title:^(Caelestia Keybinds)\$"
echo "  Newer syntax:  windowrule = float on, match:title ^(Caelestia Keybinds)\$"
