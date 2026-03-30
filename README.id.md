# Repo Sync - Sistem Sinkronisasi Dual Repository

Script bash untuk otomatisasi sinkronisasi kode antara repository Git public dan private menggunakan submodule.

## TL;DR

Pernah punya project private yang pengen kamu tunjukin ke public tapi gak mau open source full code-nya? Ini solusinya! 🎉

Sistem ini bikin kamu bisa **showcase** project private kamu dengan cuma nampilin `README.md` di public repo, sementara kode production tetap aman di private repo. Jadi kamu bisa bilang "eh gue sebenernya udah bikin ini lho" tanpa harus share semua kode rahasianya 😏

Tapi tenang, beberapa project emang harus stay private sih, namanya juga rahasia dapur 🤫

## Ringkasan

Sistem ini memungkinkan workflow dual-repository dimana:
- **Repository Public** (`my-app.git`): Hanya berisi `README.md` untuk tampilan public
- **Repository Private** (`my-app-private.git`): Berisi semua kode production via Git submodule

## Struktur Folder

```
project-folder/
├── core/              # Git submodule (repo PRIVATE)
│   └── (semua file production)
├── README.md          # Public (di-sync dari core/)
├── synch.sh           # Script sync
└── .git/              # Repo public
```

## Fitur

- ✅ Sinkronisasi otomatis README ke repository public
- ✅ Deploy kode production ke repository private
- ✅ Manajemen submodule untuk pemisahan yang rapi
- ✅ Commit dengan timestamp untuk tracking
- ✅ Sinkronisasi sesuai branch yang aktif

## Quick Start

### Cara Pakai

1. Edit file langsung di folder `core/`
2. Jalankan script sync:
   ```bash
   ./synch.sh
   ```
3. Selesai! Perubahan kamu sudah di-sync ke kedua repository

## Setup Project Baru

Untuk menggunakan script ini di project baru, ikuti langkah-langkah berikut:

### Prasyarat

Sebelum memulai, pastikan kamu sudah punya:
- SSH keys yang sudah dikonfigurasi untuk akses GitHub

### Langkah-langkah Setup

### 1. Buat folder project baru
```bash
mkdir ~/projects/my-awesome-app
cd ~/projects/my-awesome-app
```

### 2. Initialize repository Git PUBLIC
```bash
git init
git remote add origin git@github.com:your-username/my-awesome-app.git
```

### 3. Buat dan initialize folder core (repo PRIVATE)

Langkah ini membuat repository private dari awal:

```bash
# Buat folder core
mkdir core
cd core

# Initialize sebagai git repository terpisah
git init

# Tambahkan remote repo private production
git remote add origin git@github.com:your-username/my-awesome-app-private.git

# Buat commit awal
echo "# My Awesome App - Production" > README.md
git add .
git commit -m "Initial commit"

# Push ke repo private (ini akan membuat repo di GitHub)
git branch -M main
git push -u origin main

# Kembali ke folder parent
cd ..
```

> **Catatan:** Jika repository private sudah ada di GitHub, kamu bisa skip Step 3 dan langsung ke Step 4.

### 4. Ubah folder core menjadi submodule

Sekarang ubah folder `core/` menjadi Git submodule yang proper:

```bash
# Hapus folder core yang ada (kita akan tambah lagi sebagai submodule)
rm -rf core

# Tambahkan repo private sebagai submodule
git submodule add git@github.com:your-username/my-awesome-app-private.git core

# Initialize dan update submodule
git submodule update --init --recursive
```

### 5. Copy script sync
```bash
cp /path/to/synch.sh .
chmod +x synch.sh
```

### 6. Edit Konfigurasi

Buka `synch.sh` dan ubah variabel berikut:

```bash
MASKING_DIR="/home/your-username/projects/my-awesome-app"
PRIVATE_CORE="$MASKING_DIR/core"
PRIVATE_REPO_URL="git@github.com:your-username/my-awesome-app-private.git"
PUBLIC_REPO_URL="git@github.com:your-username/my-awesome-app.git"
```

### 7. Buat README awal di core (opsional tapi disarankan)
```bash
echo "# My Awesome App" > core/README.md
cd core
git add .
git commit -m "Add README"
git push
cd ..
```

### 8. Commit dan push setup awal
```bash
git add .
git commit -m "Initial setup with core submodule"
git push -u origin main
```

### 9. Verifikasi Setup
```bash
# Cek status submodule
git submodule status

# Pastikan folder core sudah terhubung dengan benar
ls -la core/
```

## Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                    Edit File di core/                       │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                  Jalankan: ./synch.sh                       │
└─────────────────────────┬───────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          │                               │
          ▼                               ▼
┌─────────────────────┐         ┌─────────────────────┐
│   README.md         │         │   core/             │
│   → Repo Public     │         │   → Repo Private    │
│   (my-app.git)      │         │   (my-app-private)  │
└─────────────────────┘         └─────────────────────┘
```

## Langkah Script

| Step | Deskripsi | Target |
|------|-----------|--------|
| 0 | Sync README.md ke repo public | `my-app.git` |
| 1 | Commit & push kode production | `my-app-private.git` |
| 2 | Update referensi submodule | Repo public |

## Kebutuhan

- Bash shell
- Git sudah terinstall dan terkonfigurasi
- SSH key sudah disetting untuk GitHub (untuk akses push)
- Dukungan Git submodule yang proper

## Contoh Kasus Penggunaan

Sistem ini cocok untuk:

- **Proyek Open Source**: Jaga kode core tetap private tapi tampilkan info project secara public
- **Pekerjaan Freelance**: Pisahkan dokumentasi untuk klien dari kode production
- **Aplikasi SaaS**: Repo public untuk marketing + private untuk codebase
- **Proyek Edukasi**: Materi kursus public + kode solusi private

## License

MIT License - Bebas digunakan dan dimodifikasi untuk project kamu sendiri.

---

**Versi:** 1.0
**Author:** UNIXLAB
