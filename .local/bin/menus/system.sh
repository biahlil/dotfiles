#!/bin/bash
# System Config Menu
# Location: ~/.local/bin/menus/system.sh

WOFI_CONFIG="$HOME/.config/wofi/config-dmenu"
WOFI_STYLE="$HOME/.config/wofi/style.css"

wofi_menu() {
    wofi --dmenu \
        --conf "$WOFI_CONFIG" \
        --style "$WOFI_STYLE" \
        --cache-file /dev/null \
        --prompt "$1"
}

system_menu() {
    local options="🛠️  Update Custom Apps
🔒  Edit Ly Config
󱂬  Edit Niri Config
󰈺  Edit Fish Config
󰓆  Edit Starship Config
󰑓  Reload Niri
󰒓  DMS Settings
󰁍  Back"

    local choice=$(echo -e "$options" | wofi_menu "System")

    case "$choice" in
        *"Update Custom Apps"*)
            kitty --title "Updater" -e "$HOME/.local/bin/menus/update-custom-apps.sh"
            ;;
        *"Edit Ly Config"*)
            code /etc/ly/config.ini
            ;;
        *"Edit Niri"*)
            code "$HOME/.config/niri/config.kdl"
            ;;
        *"Fish Config"*)
            code "$HOME/.config/fish/config.fish"
            ;;
        *"Starship"*)
            code "$HOME/.config/starship.toml"
            ;;
        *"Reload Niri"*)
            niri msg action reload-config
            notify-send "Niri" "Config reloaded"
            ;;
        *"DMS Settings"*)
            dms ipc call settings toggle
            ;;
        *"Back"*)
            exec "$HOME/.local/bin/config-menu.sh"
            ;;
    esac
}

system_menu
