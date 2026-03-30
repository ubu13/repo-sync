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

> **📍 Ini adalah workspace kamu:** Folder `core/` (atau nama apapun yang kamu pakai) adalah tempat kamu akan bekerja mulai sekarang! Semua kode production, edit, dan development dilakukan di dalam folder ini.

1. Edit file langsung di folder `core/` (atau folder private kamu)
2. Kembali ke **folder root public repo** (parent dari core/)
3. Jalankan script sync dari sana:
   ```bash
   # ❌ JANGAN jalanin dari dalam folder core/private!
   cd core && ./synch.sh    # SALAH!
   
   # ✅ Jalanin dari root public repo
   cd ..
   ./synch.sh               # BENAR!
   ```
4. Selesai! Perubahan kamu sudah di-sync ke kedua repository

> **⚠️ Penting:** Selalu jalankan `synch.sh` dari **folder root repository public**, BUKAN dari dalam folder private/core. Script ini butuh akses ke `.git` repo public dan submodule private.

## Setup Project Baru

Untuk menggunakan script ini di project baru, ikuti langkah-langkah berikut:

### Prasyarat

Sebelum memulai, pastikan kamu sudah punya:
- SSH keys yang sudah dikonfigurasi untuk akses GitHub

### Langkah-langkah Setup

> **💡 Catatan Penting Tentang Nama Folder:**
> 
> Nama folder `core` yang digunakan di contoh bawah ini **bisa diubah sesuka hati**! Kamu bisa pakai nama yang cocok buat project kamu:
> - `core` - nama generic
> - `src` - kalau ini source code kamu
> - `private` - untuk nandasin kalau ini private
> - `production` - untuk production code
> - `backend`, `frontend`, `app` - apapun yang masuk akal!
> 
> **Yang penting konsisten:** Gunakan nama folder yang sama di:
> 1. `git submodule add <repo-url> <nama-folder>`
> 2. Variabel `PRIVATE_CORE` di `synch.sh`
> 
> Contoh:
> ```bash
> # Kalau kamu pakai 'src' bukan 'core':
> git submodule add git@github.com:your-username/private-repo.git src
> 
> # Terus di synch.sh:
> PRIVATE_CORE="$MASKING_DIR/src"
> ```

Ada **2 skenario** - pilih sesuai kondisi kamu:

---

#### Skenario A: Sudah Punya Repo Private (Mau di-Showcase)

Kalau kamu sudah punya repository private dengan kode dan mau pamerin ke public:

### 1. Buat folder project & init public repo
```bash
mkdir ~/projects/my-awesome-app
cd ~/projects/my-awesome-app
git init
git remote add origin git@github.com:your-username/my-awesome-app.git
```

### 2. Add repo private yang sudah ada sebagai submodule

Langsung aja! Nama folder terserah kamu:

```bash
git submodule add git@github.com:your-username/existing-private-repo.git core
git submodule update --init --recursive
```

### 3. Buat README di repo private (untuk showcase)

```bash
cd core
echo "# My Awesome Project - Check this out!" > README.md
git add .
git commit -m "Add README for public showcase"
git push
cd ..
```

**Selesai!** Lanjut ke Step 5 (Copy sync script).

---

#### Skenario B: Buat Semua dari Awal

Kalau kamu mulai dari nol, belum punya repo sama sekali:

### 1. Buat folder project & init public repo
```bash
mkdir ~/projects/my-awesome-app
cd ~/projects/my-awesome-app
git init
git remote add origin git@github.com:your-username/my-awesome-app.git
```

### 2. Buat repo private kosong di GitHub

Buka GitHub → New Repository → Pilih **Private** → Jangan initialize dengan README/.gitignore

### 3. Add repo private kosong sebagai submodule

```bash
git submodule add git@github.com:your-username/my-awesome-app-private.git core
git submodule update --init --recursive
```

### 4. Initialize konten di dalam submodule

```bash
cd core

# Buat kode production kamu di sini
echo "# My Awesome App - Production" > README.md
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main

cd ..
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
