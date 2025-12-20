# Panduan Setup Hybrid AI (Lokal + Cloud)

Panduan ini akan membantu mengubah PC kamu menjadi "AI Station" canggih yang menggabungkan kecepatan AI lokal dengan kecerdasan AI cloud.

## 🎯 Konsep "Hybrid AI"
Satu antarmuka (Frontend) untuk mengendalikan dua "otak":
1.  **Otak Lokal (Ollama)**: Gratis, Cepat, Privasi 100%. Untuk chat harian, asisten terminal, dan draft email.
2.  **Otak Cloud (DeepSeek)**: Berbayar murah, Sangat Pintar (setara GPT-4). Untuk coding kompleks, analisis data, dan debugging.

---

## 🛠️ Langkah 1: Persiapan (Prerequisites)

Pastikan kamu sudah menginstall **Docker**. Jika belum:

```bash
# Update repo dan install docker
sudo apt update
sudo apt install docker.io -y

# Tambahkan user kamu ke grup docker (agar tidak perlu sudo terus)
sudo usermod -aG docker $USER

# ⚠️ PENTING: Log out dan Log in kembali PC kamu agar permission docker aktif!
```

Pastikan juga **Ollama** sudah jalan:
```bash
sudo systemctl start ollama
```

---

## 🚀 Langkah 2: Install Open WebUI

Kita akan menggunakan **Open WebUI** (sebelumnya Ollama WebUI). Ini adalah antarmuka web yang sangat mirip ChatGPT tapi berjalan di PC kamu sendiri.

Jalankan perintah ini di terminal:

```bash
docker run -d -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

*   `--add-host=...`: Ini kuncinya! Agar Docker container bisa melihat servis Ollama di PC "Host" kamu.
*   `-p 3000:8080`: Akses aplikasinya nanti di browser `localhost:3000`.

Tunggu download selesai (sekitar ~1-2 GB).

---

## 🔗 Langkah 3: Konfigurasi

1.  Buka Browser, akses: `http://localhost:3000`
2.  Bikin akun admin baru (data tersimpan lokal di PC, tidak dikirim ke mana-mana).
3.  **Cek Lokal**: Coba pilih model di pojok kiri atas. Harusnya `llama3.2:3b` yang sudah kamu pull di Ollama otomatis muncul.

### Menambahkan "Otak Cloud" (DeepSeek)

1.  Daftar akun di [platform.deepseek.com](https://platform.deepseek.com/).
2.  Masuk menu **API Keys** -> Create new API Key -> Copy key tersebut.
3.  Di Open WebUI:
    *   Klik **Profil Icon** (pojok kanan bawah/atas) -> **Settings**.
    *   Pilih tab **Connections** (atau External Models).
    *   Isi **OpenAI Install Host Settings**:
        *   **API Host**: `https://api.deepseek.com/v1`
        *   **API Key**: Paste key kamu tadi.
    *   Klik **Save/Verify**.

Sekarang di dropdown model akan muncul pilihan `deepseek-chat` atau `deepseek-reasoner`!

---

## 💰 Analisis Harga (DeepSeek API)

DeepSeek terkenal "Perusak Harga Pasar" karena sangat murah dengan performa setara model raksasa.

**Estimasi Biaya (Per 1 Juta Token ~ 750 Ribu Kata):**

| Model | Input (Kamu Nanya) | Output (AI Jawab) | Kecerdasan |
| :--- | :--- | :--- | :--- |
| **DeepSeek V3** | $0.07 (Rp 1.100,-) | $1.10 (Rp 17.000,-) | Setara GPT-4o / Claude 3.5 |
| **DeepSeek R1** | $0.14 (Rp 2.200,-) | $2.19 (Rp 34.000,-) | Model "Reasoning" (Berpikir dulu sebelum jawab) |

**Simulasi Penggunaan Harian:**
Jika kamu coding berat seharian menggunakan DeepSeek V3 (kirim 500 baris kode, minta fix bug, generate 200 baris):
*   Per hari mungkin habis **$0.02 - $0.05** (Rp 300 - Rp 800 perak).
*   Sangat murah dibandingkan langganan ChatGPT Plus ($20 / Rp 300.000 per bulan).

---

## 💡 Workflow Rekomendasi

1.  **Mode Hemat (Dafult)**: Gunakan `Llama 3.2` lokal.
    *   "Buatkan kerangka email..."
    *   "Jelaskan fungsi `git rebase`..."
2.  **Mode Ahli**: Switch ke `DeepSeek V3` di dropdown.
    *   "Refactor code React ini agar lebih efisien dan fix bug race condition..."

---

## 🛠️ Menambahkan "Tangan" (Tools) ke AI

Agar AI lokal bisa lebih dari sekadar chat (misal: browsing atau hitung matematika), kamu perlu aktifkan **Tools**.

1.  **Buka Menu Tools**:
    *   Klik **Profil Icon** -> **Settings**.
    *   Pilih tab **Tools**.
2.  **Aktifkan Tool Bawaan**:
    *   **Web Search**: Aktifkan (Butuh API Key gratis dari Google/DuckDuckGo, atau bisa pakai scraper bawaan).
    *   **Calculator**: Aktifkan agar AI bisa menghitung akurat (karena LLM sering salah hitung).
3.  **Cara Pakai**:
    *   Di chat baru, klik tanda **`+`** di sebelah kiri kolom ketik.
    *   Pilih Tool yang mau dipakai (misal: Calculator).
    *   Ketik: *"Hitung akar pangkat 3 dari 4913"*.
    *   AI akan menjalankan kode Python di latar belakang untuk menghitungnya, bukan menebak!

