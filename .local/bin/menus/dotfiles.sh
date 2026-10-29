#!/bin/bash
# Dotfiles Edit Menu
# Location: ~/.local/bin/menus/dotfiles.sh

WOFI_CONFIG="$HOME/.config/wofi/config-dmenu"
WOFI_STYLE="$HOME/.config/wofi/style.css"
DOTFILES_REPO="$HOME/git/config"

wofi_menu() {
    wofi --dmenu \
        --conf "$WOFI_CONFIG" \
        --style "$WOFI_STYLE" \
        --cache-file /dev/null \
        --prompt "$1"
}

dotfiles_menu() {
    local options="󰉋  Open in Yazi
󰨞  Open in VS Code
󰊢  Git Status
󰇚  Git Pull
󰕒  Git Push
󰁍  Back"

    local choice=$(echo -e "$options" | wofi_menu "Dotfiles")

    case "$choice" in
        *"Yazi"*)
            kitty --title "Dotfiles" -e yazi "$DOTFILES_REPO"
            ;;
        *"VS Code"*)
            code "$DOTFILES_REPO"
            ;;
        *"Git Status"*)
            kitty --title "Git Status" -e bash -c "cd $DOTFILES_REPO && git status; read -p 'Press Enter to close...'"
            ;;
        *"Git Pull"*)
            kitty --title "Git Pull" -e bash -c "cd $DOTFILES_REPO && git pull; read -p 'Press Enter to close...'"
            ;;
        *"Git Push"*)
            kitty --title "Git Push" -e bash -c "cd $DOTFILES_REPO && git add -A && git commit -m 'Update dotfiles' && git push; read -p 'Press Enter to close...'"
            ;;
        *"Back"*)
            exec "$HOME/.local/bin/config-menu.sh"
            ;;
    esac
}

dotfiles_menu
