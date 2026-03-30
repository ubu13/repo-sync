# How the Idea Works

## REPO SYNC SYSTEM (VER 1.0)

### Konsep Dasar

Sistem ini memungkinkan workflow dual-repository dengan cara:
- **Repository Public**: Hanya berisi `README.md` untuk tampilan public
- **Repository Private**: Berisi semua file production code via Git submodule

### Struktur Folder

```
project-folder/
├── core/              ← Submodule (PRIVATE repo)
│   └── (semua file production)
├── README.md          ← Public (di-sync dari core/)
├── synch.sh           ← Script ini
└── .git/              ← Public repo
```

### Cara Pakai

1. Edit file langsung di folder `core/`
2. Jalankan: `./synch.sh`
3. **DONE!**
   - `README.md` → `avo.git` (PUBLIC)
   - Semua file lain → `avo_production.git` (PRIVATE)

---

## Setup Project Baru

Untuk menggunakan script ini di project lain:

### 1. Buat folder project baru
```bash
mkdir /path/to/project-baru
cd /path/to/project-baru
```

### 2. Init git repo (public)
```bash
git init
```

### 3. Tambahkan submodule core (private)
```bash
git submodule add git@github.com:ubu13/avo_production.git core
git submodule update --init --recursive
```

### 4. Copy script ini ke project baru
```bash
cp /mnt/ollama/docker-web-server/www/avomasking/synch.sh .
```

### 5. EDIT KONFIGURASI

Edit variabel berikut di `synch.sh`:
- `MASKING_DIR`: path ke project baru
- `PUBLIC_REPO_URL`: repo public tujuan
- `PRIVATE_REPO_URL`: repo private (bisa sama untuk semua project)

### 6. Commit & push setup awal
```bash
git add .
git commit -m "Initial setup"
git push origin main
```

---

## Alur Kerja Script

### STEP 0: Sync README ke Public Repo
- Mengcopy `README.md` dari `core/` ke root folder
- Commit dan push ke repository public

### STEP 1: Commit & Push dari Private Core
- Masuk ke folder `core/` (submodule private)
- Commit semua perubahan
- Push ke repository private

### STEP 2: Update Submodule Reference
- Kembali ke folder utama
- Update referensi submodule
- Commit dan push ke repository public

---

## Hasil Akhir

Setelah script berjalan:
- ✅ `README.md` → `my-awesome-app.git` (public)
- ✅ `core/` → `my-awesome-app-private.git` (private)
- ✅ Semua sistem tersinkronisasi!

---

**Version:** 1.0
**Author:** UNIXLAB
