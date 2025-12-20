# Cara Install Font Maple Mono NF

Font ini (Maple Mono NF) diperlukan agar konfigurasi Kitty dan Wofi kamu terlihat sempurna.

## Skenario 1: Download & Install Manual (Paling Mudah)

1.  Buka link rilis resmi: [Maple Mono NF Releases](https://github.com/subframe7536/maple-font/releases)
2.  Download file `.zip` terbaru (biasanya bernama `MapleMono-NF.zip` atau mirip).
3.  Ekstrak file zip tersebut.
4.  Cari file yang berakhiran `.ttf` atau `.otf` (pilih varian `NF` atau `Nerd Font`).
5.  Pindahkan semua file font tersebut ke folder `~/.local/share/fonts/`.
    *   Jika folder tersebut belum ada, buat dulu dengan perintah: `mkdir -p ~/.local/share/fonts`
6.  Jalankan perintah ini di terminal untuk memperbarui cache font:
    ```bash
    fc-cache -fv
    ```

## Skenario 2: Menggunakan Script (Jika malas download manual)

Jalankan perintah berikut di terminal kamu (pastikan kamu punya `curl` dan `unzip`):

```bash
# Buat direktori font
mkdir -p ~/.local/share/fonts

# Download rilis terbaru (MapleMono-NF.zip)
curl -OL https://github.com/subframe7536/maple-font/releases/latest/download/MapleMono-NF.zip

# Unzip ke direktori font
unzip -o MapleMono-NF.zip -d ~/.local/share/fonts/maple-mono-nf

# Hapus file zip
rm MapleMono-NF.zip

# Update cache font
fc-cache -fv

# Verifikasi instalasi
fc-list | grep "Maple Mono"
```

## Verifikasi
Setelah instalasi, buka terminal **Kitty** dan pastikan fontnya sudah berubah menjadi Maple Mono yang cantik! Jika belum, coba restart Kitty (tutup dan buka lagi).
