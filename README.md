# 🌌 Kimsora's Ultimate Linux Setup

Panduan replikasi sistem Niri Desktop Environment dengan DankMaterialShell, Dynamic Theming, dan AI Integration.

---

## 📦 1. Core System (Niri dan DankMaterialShell)

Basis desktop environment tanpa bloat.
**Install Paket Utama (Ubuntu 25.10+):**
Menggunakan PPA resmi untuk versi terbaru, ditambah tools esensial pilihan kita.

1.  **Tambah Repository:**
    ```bash
    sudo add-apt-repository ppa:avengemedia/danklinux
    sudo add-apt-repository ppa:avengemedia/dms
    sudo apt update
    ```

2.  **Install :**
    *(Niri + Dank Material Shell )*
    ```bash
    sudo apt install niri dms
    ```

**Konfigurasi Niri:**
Copy file `config.kdl` ke lokasi config:
```bash
mkdir -p ~/.config/niri
cp config.kdl ~/.config/niri/config.kdl
```

---

## 🐚 2. Shell & Terminal (Fish, Starship, Fastfetch, Kitty, Wofi)

Membuat terminal (Kitty) terlihat cantik dan informatif.

**A. Install Tools:**
```bash
# Install Starship (Prompt keren)
curl -sS https://starship.rs/install.sh | sh

# Install Kitty + Fish + Wofi
sudo apt install kitty fish wofi

# Install Fastfetch (System Info)
sudo add-apt-repository ppa:zhangsongcui3336/fastfetch
sudo apt update && sudo apt install fastfetch

```

**B. Konfigurasi Wofi:**
Agar tampilan Wofi cantik & ikut tema Pywal.
```bash
mkdir -p ~/.config/wofi
cp wofi/config ~/.config/wofi/config
cp wofi/style.css ~/.config/wofi/style.css
```
*Pastikan `style.css` memanggil `@import url('.../colors-waybar.css');` agar sinkron.*


**C. Konfigurasi Fish Shell:**
Tambahkan ini di `~/.config/fish/config.fish` agar starship & fastfetch jalan otomatis:
```fish
if status is-interactive
    # Fastfetch saat buka terminal baru
    fastfetch

    # Init Starship
    starship init fish | source
    
    # Integrasi Pywal (Warna Dinamis)
    cat ~/.cache/wal/sequences
end
```

**D. Konfigurasi Starship:**
Copy file konfigurasi custom kita:
```bash
cp starship.toml ~/.config/starship.toml
```

---

## 🎨 3. Visual & Theming (DMS + Wallpaper Engine)

**Linux Wallpaper Engine:**
Agar wallpaper bergerak dan terintegrasi DMS.

**Build From Source (Ubuntu/Debian):**
*Install Dependencies:*
```bash
sudo apt-get update
sudo apt-get install build-essential cmake libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libgl-dev libglew-dev freeglut3-dev libsdl2-dev liblz4-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libxxf86vm-dev libglm-dev libglfw3-dev libmpv-dev mpv libmpv1 libpulse-dev libpulse0 libfftw3-dev
```

*Build:*
```bash
git clone --recurse-submodules https://github.com/Almamu/linux-wallpaperengine.git
cd linux-wallpaperengine
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE='Release' ..
make
```

**Install:**
Copy binary hasil build agar bisa dipanggil sistem:
```bash
cp linux-wallpaperengine ~/.local/bin/
chmod +x ~/.local/bin/linux-wallpaperengine
```

**Assets:**
Aplikasi ini butuh assets dari Wallpaper Engine (Steam). Pastikan Steam terinstall dan login. Jika assets tidak terdeteksi otomatis, copy folder `assets` dari library Steam ke folder `~/.local/bin/`.

**DMS Integration:**
Agar DMS bisa mengontrol wallpaper engine.

*Method 1: Plugin Registry (Recommended)*
1.  Buka **DMS Settings**.
2.  Masuk ke tab **Plugins**.
3.  Klik **Browse**.
4.  Klik **"Show 3rd Party Plugins"** dan konfirmasi.
5.  Cari **"Linux Wallpaper Engine"** dan install.

*Method 2: Manual Installation*
Clone repo dan copy ke folder plugin DMS:
```bash
git clone https://github.com/sgtaziz/dms-wallpaperengine.git
cp -r dms-wallpaperengine/LinuxWallpaperEngine ~/.config/DankMaterialShell/plugins/
```
*Setelah install, aktifkan plugin di DMS Settings -> Plugins tab.*

---

## 🌈 4. Automation (Matugen Listener)

Script buatan kita agar warna sistem (Kitty) berubah mengikuti wallpaper secara *real-time*.

**A. Konfigurasi Matugen:**
Script ini membutuhkan template Matugen yang ada di repo ini.
1.  **Copy Config**:
    ```bash
    cp -r .config/matugen ~/.config/
    ```
2.  **Penjelasan File**:
    *   `config.toml`: Mengatur `scheme_variant` (default: `tonal_spot`) dan mapping template.
    *   `templates/kitty.conf`: Template warna untuk Kitty terminal.
    *   `templates/pywal.json`: Template untuk generate `colors.json` (dipakai Pywalfox).
    *   `templates/wofi.css`: Template CSS untuk Wofi launcher.

**B. File Script:**
Pastikan `wal-listener.sh` ada di `~/.local/bin/` dan executable (`chmod +x`). Script ini menggunakan **Matugen** untuk menghasilkan warna material design dari wallpaper.

**C. Integrasi:**
1.  **Kitty**: Tambah `include ~/.config/kitty/matugen-colors.conf` di `kitty.conf`.

2.  **Pywalfox (Firefox Theme):**
    Agar browser ikut berubah warna sesuai wallpaper.
    *   **Langkah 1**: Install extension [Pywalfox](https://addons.mozilla.org/en-US/firefox/addon/pywalfox/) di Firefox.
    *   **Langkah 2**: Install native messenger di terminal:
        ```bash
        pip install pywalfox
        pywalfox install
        ```
    *   **Langkah 3**: Buka Firefox -> Klik ekstensi Pywalfox -> Pilih "Fetch Pywal colors" -> Aktifkan "Auto update".
    *   *Note: Script `wal-listener.sh` akan otomatis menjalankan `pywalfox update`.*

3.  **Start Otomatis**: Pastikan `config.kdl` memanggil script ini agar berjalan di background.

---

## 📸 5. Advanced Screenshot (Alt+Print)

Fitur khusus: **Auto-capture Active Window** langsung ke swappy (tanpa klik mouse).

**A. Buat Script Helper:**
Simpan kode ini di `~/.local/bin/niri-screenshot-window.sh`:

```bash
#!/bin/bash
FILE="/tmp/screenshot_window_$(date +%Y%m%d_%H%M%S).png"
# Capture & Wait
niri msg action screenshot-window --path "$FILE"
for i in {1..30}; do
    if [ -f "$FILE" ]; then swappy -f "$FILE"; exit 0; fi
    sleep 0.1
done
notify-send "Failed" "Screenshot timeout."
```
Jangan lupa: `chmod +x ~/.local/bin/niri-screenshot-window.sh`

**B. Update Keybind (config.kdl):**
```kdl
Alt+Print { spawn "/home/kimsora/.local/bin/niri-screenshot-window.sh"; }
```

---

## 🤖 6. AI Station (Lokal + Cloud)

Mengubah PC menjadi asisten cerdas hybrid.

**Setup:**
1.  **Ollama**: `sudo systemctl start ollama`
2.  **Open WebUI**: Interface chat ala ChatGPT.
3.  **Docker**: Diperlukan untuk menjalankan WebUI.

> **[Lihat Panduan Detail Setup AI](guides/hybrid_ai_setup.md)**

---

## 📚 7. Lampiran

*   **[Panduan Install Font (Maple Mono NF)](guides/font_install.md)**
