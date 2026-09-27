# Progress — SIKANDANG

Catatan progres pengembangan.

## 🔧 Update v1.1 — perbaikan foto

- Mengganti semua foto dekoratif yang sebelumnya memakai ID Unsplash yang ditebak (tidak
  diverifikasi) — beberapa ternyata menampilkan foto **babi** atau bahkan link mati. Sekarang
  semua foto memakai URL Pexels yang sudah diverifikasi kontennya (sapi, kambing, ayam — tanpa
  babi sama sekali), sesuai konteks peternakan lokal.
- Mengubah cara render foto dekoratif (hero beranda, kartu kategori forum, galeri sidebar,
  banner artikel forum) dari tag `<img>` ke CSS `background-image` pada `<div>`. Alasannya: kalau
  sebuah URL foto gagal dimuat, `<img>` menampilkan ikon "gambar rusak" yang mengganggu tampilan,
  sedangkan `background-image` yang gagal cukup menyisakan warna latar polos (coklat) tanpa ikon
  rusak — dan yang terpenting, teks judul/deskripsi di sekitarnya **tidak pernah ikut hilang**
  karena tidak bergantung pada berhasil/gagalnya gambar.
- Foto yang tetap pakai `<img>` biasa: foto yang diunggah user sendiri lewat form pertanyaan/
  jawaban (disimpan di Supabase Storage) — ini konten asli, bukan dekorasi, jadi tidak diubah.

## Rilis awal (v1)

## ✅ Sudah selesai

### Infrastruktur & setup
- [x] Project SvelteKit (Svelte 4 + Vite) dengan `@sveltejs/adapter-vercel` — siap deploy langsung.
- [x] Integrasi Supabase SSR (`@supabase/ssr`) mengikuti pola resmi: `hooks.server.js` untuk
      client per-request, `+layout.server.js` + `+layout.js` untuk sinkronisasi session ke seluruh
      halaman (SSR & client).
- [x] Skema database lengkap di `supabase/schema.sql`: tabel `profiles`, `questions`, `answers`,
      Row Level Security, trigger auto-create profile, dan storage bucket `post-images`.

### Autentikasi
- [x] Registrasi dengan email + password + nama panggilan (`username` disimpan di
      `raw_user_meta_data` lalu otomatis masuk ke tabel `profiles` lewat trigger Postgres).
- [x] Login dengan email + password.
- [x] Logout (form POST ke `/logout`).
- [x] Guard halaman "ajukan pertanyaan" dan "akun saya" — redirect ke `/login` jika belum masuk.

### Forum & konten edukasi
- [x] 4 kategori forum sesuai permintaan, masing-masing dengan artikel edukasi (intro, 5 poin
      pembahasan, dan tips cepat) — disimpan di `src/lib/categories.js` agar mudah diedit tanpa
      menyentuh database.
- [x] Halaman kategori forum menampilkan artikel edukasi **di atas** daftar tanya-jawab, sesuai
      requirement ("masuk forum X sudah ada informasi edukasi X").
- [x] Posting pertanyaan: judul + deskripsi wajib, foto **opsional** (upload ke Supabase Storage,
      validasi tipe file gambar & maksimal 5MB di sisi client).
- [x] Menjawab pertanyaan: teks wajib, foto opsional (pola sama seperti pertanyaan).
- [x] Hapus pertanyaan & hapus jawaban — tombol hanya muncul untuk pemilik post (dicek di UI +
      ditegakkan lewat RLS policy `auth.uid() = user_id` di database, jadi tetap aman meski
      di-bypass dari client).
- [x] Halaman "Akun Saya" menampilkan daftar pertanyaan yang pernah diajukan user.

### Desain
- [x] Tema warna dominan coklat (soil/clay/wheat) dengan aksen hijau daun, terinspirasi
      "papan pengumuman peternakan" — kartu bergaya notice-board dengan pin/stempel, bukan kartu
      SaaS generik.
- [x] Hero beranda dengan galeri foto bertumpuk (collage), ticker berjalan berisi pertanyaan
      terbaru, dan statistik singkat.
- [x] Grid kategori forum dengan foto + ikon di setiap kartu.
- [x] Sidebar galeri foto peternakan di beranda.
- [x] Navigasi responsif (menu hamburger di layar kecil) + dropdown "Forum" di navbar.

## 🔜 Belum dikerjakan / saran pengembangan lanjutan

- [ ] **Edit** pertanyaan/jawaban (saat ini hanya bisa hapus, belum bisa ubah).
- [ ] Pencarian & filter pertanyaan (misalnya berdasarkan kata kunci atau status terjawab).
- [ ] Paginasi/"load more" untuk daftar pertanyaan yang panjang (saat ini menampilkan semua data
      sekaligus per kategori).
- [ ] Sistem upvote/reputasi seperti StackOverflow asli.
- [ ] Kompresi/resize gambar sebelum upload agar lebih hemat storage & kuota Supabase.
- [ ] Notifikasi (email/in-app) saat pertanyaan dijawab.
- [ ] Halaman admin/moderator untuk mengelola seluruh forum (saat ini kontrol hapus hanya
      berbasis kepemilikan post, tidak ada role admin).
- [ ] Rich text / markdown pada deskripsi & jawaban (saat ini plain text).
- [ ] Uji end-to-end otomatis (Playwright/Vitest) — saat ini belum ada test.

## Catatan teknis

- Environment belum diuji langsung dengan `npm install` & `npm run build` di sandbox pengerjaan
  ini karena tidak ada akses jaringan. Struktur kode mengikuti pola resmi SvelteKit 2 +
  `@supabase/ssr` + `adapter-vercel` yang stabil, tapi **sangat disarankan** menjalankan
  `npm install && npm run build` secara lokal sebelum deploy produksi untuk menangkap kemungkinan
  ketidakcocokan versi dependency.
- Foto galeri di beranda (`galleryPhotos`) memakai URL gambar dari Unsplash sebagai placeholder
  visual — ganti dengan foto asli peternakan Anda agar lebih personal, dengan meng-upload lewat
  Supabase Storage lalu menempel URL publiknya di `src/routes/+page.svelte`.
