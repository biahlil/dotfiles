#!/bin/bash
# TUI Apps Menu
# Location: ~/.local/bin/menus/tui-apps.sh

WOFI_CONFIG="$HOME/.config/wofi/config-dmenu"
WOFI_STYLE="$HOME/.config/wofi/style.css"

wofi_menu() {
    wofi --dmenu \
        --conf "$WOFI_CONFIG" \
        --style "$WOFI_STYLE" \
        --cache-file /dev/null \
        --prompt "$1"
}

tui_menu() {
    local options="󰉋  yazi - File Manager
󰨇  bottom - System Monitor
󰘦  opencode - AI Coding Assistant
󰊢  lazygit - Git TUI
󰨞  VS Code - Text Editor
󰁍  Back"

    local choice=$(echo -e "$options" | wofi_menu "TUI Apps")

    case "$choice" in
        *"yazi"*)
            kitty --title "Yazi" -e yazi
            ;;
        *"bottom"*)
            kitty --title "Bottom" -e btm
            ;;
        *"opencode"*)
            kitty --title "OpenCode" -e opencode
            ;;
        *"lazygit"*)
            kitty --title "LazyGit" -e lazygit
            ;;
        *"VS Code"*)
            code
            ;;
        *"Back"*)
            exec "$HOME/.local/bin/config-menu.sh"
            ;;
    esac
}

tui_menu
