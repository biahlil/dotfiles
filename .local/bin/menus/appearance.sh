#!/bin/bash
# Appearance Menu
# Location: ~/.local/bin/menus/appearance.sh

WOFI_CONFIG="$HOME/.config/wofi/config-dmenu"
WOFI_STYLE="$HOME/.config/wofi/style.css"

wofi_menu() {
    wofi --dmenu \
        --conf "$WOFI_CONFIG" \
        --style "$WOFI_STYLE" \
        --cache-file /dev/null \
        --prompt "$1"
}

appearance_menu() {
    local options="󰸉  Change Wallpaper (DMS)
󰄛  Edit Kitty Theme
󰒓  Edit Wofi Style
󰏘  Edit Niri Colors
󰑓  Reload Matugen
󰁍  Back"

    local choice=$(echo -e "$options" | wofi_menu "Appearance")

    case "$choice" in
        *"Change Wallpaper"*)
            dms ipc call dankdash wallpaper
            ;;
        *"Kitty Theme"*)
            code "$HOME/.config/kitty/kitty.conf"
            ;;
        *"Wofi Style"*)
            code "$HOME/.config/wofi/style.css"
            ;;
        *"Niri Colors"*)
            code "$HOME/.config/niri/config.kdl"
            ;;
        *"Reload Matugen"*)
            "$HOME/.local/bin/wal-listener.sh" &
            notify-send "Matugen" "Theme reload triggered"
            ;;
        *"Back"*)
            exec "$HOME/.local/bin/config-menu.sh"
            ;;
    esac
}

appearance_menu
