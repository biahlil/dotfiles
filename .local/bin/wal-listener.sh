#!/bin/bash

# Directory where DMS saves screenshots/wallpapers
WATCH_DIR="$HOME/.cache/DankMaterialShell/we_screenshots"

# Ensure inotifywait is installed
if ! command -v inotifywait &> /dev/null; then
    echo "Error: inotifywait is not installed. Please install 'inotify-tools'."
    exit 1
fi

echo "Listening for new wallpapers in $WATCH_DIR..."

inotifywait -m -e close_write -e moved_to --format "%f" "$WATCH_DIR" | while read FILENAME
do
    # Check if the file is an image
    if [[ "$FILENAME" =~ \.(jpg|jpeg|png|webp)$ ]]; then
        FULL_PATH="$WATCH_DIR/$FILENAME"
        echo "[*] New wallpaper detected: $FILENAME"
        
        # Give it a second to ensure file write is complete
        sleep 1
        
        # Run Matugen
        echo "[*] Running Matugen..."
        matugen image "$FULL_PATH"
        
        if [ $? -eq 0 ]; then
            echo "[+] Matugen success!"
            
            # Reload Kitty config
            # Use 'kitty @' to send command to all active kitty windows
            # Ensure 'allow_remote_control yes' is in kitty.conf
            echo "[*] Reloading Kitty..."
            kitty @ set-colors -a -c ~/.config/kitty/matugen-colors.conf 2>/dev/null
        else
            echo "[!] Matugen failed."
        fi
    fi
done
