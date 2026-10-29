#!/bin/bash
# Config Menu - Main entry point
# Shortcut: Super+Ctrl+D
# Location: ~/.local/bin/config-menu.sh

MENU_DIR="$HOME/.local/bin/menus"
WOFI_CONFIG="$HOME/.config/wofi/config-dmenu"
WOFI_STYLE="$HOME/.config/wofi/style.css"

wofi_menu() {
    wofi --dmenu \
        --conf "$WOFI_CONFIG" \
        --style "$WOFI_STYLE" \
        --cache-file /dev/null \
        --prompt "$1"
}

main_menu() {
    local options="󰏘  Appearance
󰒓  System Config
󰚩  AI Station
󰆍  TUI Apps
󰷏  Edit Dotfiles
󰑓  Reload Niri"

    local choice=$(echo -e "$options" | wofi_menu "Menu")

    case "$choice" in
        *"Appearance"*)
            "$MENU_DIR/appearance.sh"
            ;;
        *"System Config"*)
            "$MENU_DIR/system.sh"
            ;;
        *"AI Station"*)
            "$MENU_DIR/ai-station.sh"
            ;;
        *"TUI Apps"*)
            "$MENU_DIR/tui-apps.sh"
            ;;
        *"Edit Dotfiles"*)
            "$MENU_DIR/dotfiles.sh"
            ;;
        *"Reload Niri"*)
            niri msg action reload-config
            notify-send "Niri" "Config reloaded successfully"
            ;;
    esac
}

main_menu
