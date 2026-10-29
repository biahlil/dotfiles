#!/bin/bash
# Update Custom Apps from Source
# Location: ~/.local/bin/update-custom-apps.sh

SOURCE_DIR="$HOME/Source"
BIN_DIR="$HOME/.local/bin"

# Helper function
update_status() {
    echo -e "\n\033[1;34m:: $1\033[0m"
}

# 1. Update Ly (Display Manager)
if [ -d "$SOURCE_DIR/ly" ]; then
    update_status "Updating Ly..."
    cd "$SOURCE_DIR/ly" && git pull
    # Ly butuh compile & install sebagai root
    make
    echo "⚠️  Enter password to install Ly system-wide:"
    sudo make install
    update_status "Ly updated! Restart service manually or reboot."
else
    echo "❌ Ly source not found in $SOURCE_DIR/ly"
fi

# 2. Update Linux Wallpaper Engine
if [ -d "$SOURCE_DIR/linux-wallpaperengine" ]; then
    update_status "Updating Wallpaper Engine..."
    cd "$SOURCE_DIR/linux-wallpaperengine" && git pull
    mkdir -p build && cd build
    cmake .. && make
    cp linux-wallpaperengine "$BIN_DIR/"
    update_status "Wallpaper Engine updated!"
else
    echo "❌ Wallpaper Engine source not found"
fi

# 3. Update Yazi (File Manager)
if [ -d "$SOURCE_DIR/yazi" ]; then
    update_status "Updating Yazi..."
    cd "$SOURCE_DIR/yazi" && git pull
    cargo build --release
    cp target/release/yazi "$BIN_DIR/"
    cp target/release/ya "$BIN_DIR/"
    update_status "Yazi updated!"
else
    echo "❌ Yazi source not found"
fi

echo -e "\n✅ All updates completed. Press Enter to close."
read
