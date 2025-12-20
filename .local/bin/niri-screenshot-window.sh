#!/bin/bash
# Screenshot Active Window -> Swappy
# Save to unique temp file
FILE="/tmp/screenshot_window_$(date +%Y%m%d_%H%M%S).png"

# Capture using Niri's built-in tool
niri msg action screenshot-window --path "$FILE"

# Tunggu file muncul (maksimal 3 detik)
for i in {1..30}; do
    if [ -f "$FILE" ]; then
        swappy -f "$FILE"
        exit 0
    fi
    sleep 0.1
done

# Jika timeout
notify-send "Screenshot Failed" "File not found after waiting."
