# 🐄 SIKANDANG

**Sistem Informasi Manajemen Kesehatan Kandang Berbasis Edukasi Digital Peternak Lokal**

Forum tanya-jawab seputar peternakan (mirip StackOverflow) yang dilengkapi materi edukasi di
setiap topiknya:

1. Cara Mengatasi Ternak Stres Saat Musim Hujan
2. Cara Membersihkan Kandang yang Baik
3. Tips Memilih Bibit Ternak Unggul
4. Cara Mengecek Kesehatan Ternak

Dibangun dengan **SvelteKit** (frontend) + **Supabase** (autentikasi, database, storage foto) dan
siap di-deploy ke **Vercel**.

---

## 1. Prasyarat

- [Node.js](https://nodejs.org) versi 18 atau lebih baru + npm
- Akun [Supabase](https://supabase.com) (gratis)
- Akun [Vercel](https://vercel.com) (gratis)
- (Opsional tapi disarankan) [Vercel CLI](https://vercel.com/docs/cli): `npm i -g vercel`

---

## 2. Setup Supabase

### 2.1 Buat project

1. Masuk ke [supabase.com/dashboard](https://supabase.com/dashboard) → **New project**.
2. Catat **Project URL** dan **anon public key** — nanti dipakai sebagai environment variable
   (Project Settings → API).

### 2.2 Jalankan schema database

1. Buka menu **SQL Editor** di dashboard Supabase → **New query**.
2. Copy seluruh isi file [`supabase/schema.sql`](./supabase/schema.sql) dari project ini, paste,
   lalu klik **Run**.
3. Script ini akan otomatis membuat:
   - Tabel `profiles`, `questions`, `answers` beserta Row Level Security (RLS).
   - Trigger otomatis untuk membuat profil saat user mendaftar.
   - Storage bucket `post-images` (public) beserta policy upload/hapus foto.

### 2.3 Aktifkan autentikasi Email/Password

1. Buka **Authentication → Providers**, pastikan **Email** aktif (biasanya aktif secara default).
2. Buka **Authentication → Settings**:
   - Jika ingin user langsung bisa login tanpa verifikasi email (memudahkan saat testing),
     nonaktifkan **"Confirm email"**.
   - Jika dibiarkan aktif, user wajib klik link konfirmasi di email sebelum bisa login.

---

## 3. Jalankan di Lokal (opsional, untuk uji coba sebelum deploy)

```bash
# 1. Ekstrak file zip ini, lalu masuk ke foldernya
cd sikandang

# 2. Install dependency
npm install

# 3. Salin file environment variable
cp .env.example .env

# 4. Isi .env dengan URL & anon key dari Supabase (langkah 2.1)
#    PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
#    PUBLIC_SUPABASE_ANON_KEY=xxxxxxxx

# 5. Jalankan mode development
npm run dev
```

Buka `http://localhost:5173` di browser.

---

## 4. Deploy ke Vercel

Karena Anda menerima project ini sebagai **file .zip**, ada dua cara deploy:

### Opsi A — Lewat Vercel CLI (paling cepat, langsung dari folder zip)

```bash
# 1. Ekstrak zip, masuk ke folder project
cd sikandang

# 2. Login ke Vercel (sekali saja)
vercel login

# 3. Deploy
vercel
```

Ikuti pertanyaan di terminal (pilih scope/akun, nama project, dsb). Saat pertama kali deploy,
Vercel akan minta konfirmasi setting — biarkan default karena `@sveltejs/adapter-vercel` sudah
dikonfigurasi di `svelte.config.js`.

**Tambahkan environment variable** sebelum atau sesudah deploy pertama:

```bash
vercel env add PUBLIC_SUPABASE_URL
vercel env add PUBLIC_SUPABASE_ANON_KEY
```

Lalu jalankan deploy produksi:

```bash
vercel --prod
```

### Opsi B — Lewat Dashboard Vercel (upload via GitHub)

1. Push folder hasil ekstrak zip ini ke repository GitHub baru.
2. Di [vercel.com/new](https://vercel.com/new), pilih **Import Git Repository** dan pilih repo
   tersebut. Vercel otomatis mendeteksi SvelteKit.
3. Sebelum klik **Deploy**, buka bagian **Environment Variables** dan tambahkan:
   - `PUBLIC_SUPABASE_URL`
   - `PUBLIC_SUPABASE_ANON_KEY`
4. Klik **Deploy**.

> Environment variable ini **wajib** diisi, karena tanpa itu aplikasi tidak bisa konek ke
> Supabase (build tetap sukses, tapi halaman akan error saat runtime).

### 4.1 Update environment variable setelah deploy

Jika lupa mengisi env var saat deploy pertama, tambahkan lewat **Project Settings →
Environment Variables** di dashboard Vercel, lalu klik **Redeploy** pada deployment terakhir agar
perubahan diterapkan.

---

## 5. Struktur Folder Penting

```
sikandang/
├── src/
│   ├── lib/
│   │   ├── categories.js      # Konten edukasi 4 forum + data kategori
│   │   └── utils.js           # Helper format waktu
│   ├── routes/
│   │   ├── +layout.svelte     # Navbar, footer, load session Supabase
│   │   ├── +page.svelte       # Beranda (hero, kategori, feed terbaru)
│   │   ├── login/              # Halaman masuk
│   │   ├── register/           # Halaman daftar
│   │   ├── akun/                # Halaman profil & riwayat pertanyaan
│   │   ├── logout/+server.js    # Endpoint sign-out
│   │   └── forum/[slug]/
│   │       ├── +page.svelte          # Halaman forum: artikel edukasi + list Q&A
│   │       ├── new/+page.svelte      # Form ajukan pertanyaan (+ upload foto opsional)
│   │       └── [id]/+page.svelte     # Detail pertanyaan, jawaban, hapus post
│   ├── app.css                 # Tema desain (coklat, notice-board style)
│   └── hooks.server.js         # Setup Supabase SSR client per-request
├── supabase/
│   └── schema.sql              # Skema database + RLS + storage bucket
├── .env.example
├── README.md
└── progress.md                 # Catatan progres pengerjaan
```

---

## 6. Fitur yang Tersedia

- ✅ Registrasi & login dengan email + password (Supabase Auth)
- ✅ 4 forum kategori, masing-masing dengan artikel edukasi lengkap
- ✅ Posting pertanyaan (judul + deskripsi + foto **opsional**)
- ✅ Menjawab pertanyaan (teks + foto opsional)
- ✅ Hapus pertanyaan/jawaban milik sendiri
- ✅ Halaman akun berisi riwayat pertanyaan sendiri
- ✅ Desain modern bertema coklat/peternakan dengan galeri foto di beranda
- ✅ Siap deploy ke Vercel (SSR via `@sveltejs/adapter-vercel`)

## 7. Troubleshooting

| Masalah | Solusi |
|---|---|
| Halaman blank / error `PUBLIC_SUPABASE_URL is not defined` | Pastikan environment variable sudah diisi di Vercel/`.env`, lalu redeploy. |
| Tidak bisa login setelah daftar | Cek apakah **Confirm email** aktif di Supabase — jika ya, cek inbox email untuk link konfirmasi. |
| Upload foto gagal (`403`/`RLS policy`) | Pastikan `supabase/schema.sql` sudah dijalankan penuh, termasuk bagian storage bucket & policy. |
| Data tidak muncul setelah insert | Cek tab **Table Editor** di Supabase untuk memastikan RLS policy sesuai schema.sql. |

---

Dibuat untuk mendukung digitalisasi edukasi peternak lokal. Selamat mengembangkan lebih lanjut! 🌾
