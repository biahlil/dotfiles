#!/bin/bash
# AI Station Menu
# Location: ~/.local/bin/menus/ai-station.sh

WOFI_CONFIG="$HOME/.config/wofi/config-dmenu"
WOFI_STYLE="$HOME/.config/wofi/style.css"

wofi_menu() {
    wofi --dmenu \
        --conf "$WOFI_CONFIG" \
        --style "$WOFI_STYLE" \
        --cache-file /dev/null \
        --prompt "$1"
}

ai_menu() {
    local options="󱑽  Start Ollama
󰓛  Stop Ollama
󰖟  Open WebUI
󰇚  Pull Model
󰘦  OpenCode (TUI)
󰁍  Back"

    local choice=$(echo -e "$options" | wofi_menu "AI Station")

    case "$choice" in
        *"Start Ollama"*)
            systemctl --user start ollama 2>/dev/null || sudo systemctl start ollama
            notify-send "Ollama" "Service started"
            ;;
        *"Stop Ollama"*)
            systemctl --user stop ollama 2>/dev/null || sudo systemctl stop ollama
            notify-send "Ollama" "Service stopped"
            ;;
        *"Open WebUI"*)
            xdg-open "http://localhost:3000" 2>/dev/null || xdg-open "http://localhost:8080"
            ;;
        *"Pull Model"*)
            model=$(echo -e "llama3.2\nmistral\ncodellama\ngemma2\nqwen2.5" | wofi_menu "Select Model")
            if [ -n "$model" ]; then
                kitty --title "Ollama Pull" -e bash -c "ollama pull $model; read -p 'Press Enter to close...'"
            fi
            ;;
        *"OpenCode"*)
            kitty --title "OpenCode" -e opencode
            ;;
        *"Back"*)
            exec "$HOME/.local/bin/config-menu.sh"
            ;;
    esac
}

ai_menu
