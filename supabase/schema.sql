-- ============================================================
-- Skema database untuk "TANISA — Tani Sadar Lingkungan dan Biaya"
-- Jalankan seluruh file ini di Supabase Dashboard > SQL Editor
-- (Project Anda > SQL Editor > New query > paste > Run)
--
-- File ini aman dijalankan berulang kali (idempotent).
-- ============================================================

create extension if not exists "pgcrypto";

-- ------------------------------------------------------------
-- Kategori / topik — setiap kategori punya artikel panduan
-- singkat (info_intro + info_tips) yang tampil di halaman
-- /kategori/[slug] bersama forum tanya jawabnya.
-- ------------------------------------------------------------
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  icon_key text not null default 'leaf',
  description text,
  info_intro text,
  info_tips text[] not null default '{}',
  sort_order int not null default 0
);

insert into public.categories (slug, name, icon_key, description, info_intro, info_tips, sort_order) values
(
  'mengolah-limbah-pertanian',
  'Cara Mengolah Limbah Pertanian',
  'recycle',
  'Ubah jerami, sekam, dan kotoran ternak jadi sumber daya, bukan sampah.',
  'Limbah pertanian seperti jerami, sekam, batang jagung, dan kotoran ternak sebenarnya adalah sumber daya yang masih bisa dimanfaatkan. Alih-alih dibakar atau dibuang begitu saja, limbah ini bisa diolah menjadi kompos, pakan ternak, atau bahkan bahan bakar biomassa — sekaligus mengurangi biaya dan dampak lingkungan.',
  array[
    'Pisahkan limbah organik (sisa tanaman, kotoran ternak) dari limbah non-organik (plastik mulsa, kemasan pupuk) sejak awal.',
    'Buat kompos dari sisa panen dengan mencampurnya bersama kotoran ternak dan sedikit air, lalu diamkan 3–6 minggu sambil dibolak-balik.',
    'Jerami dan sekam bisa dijadikan mulsa untuk menjaga kelembapan tanah dan menekan pertumbuhan gulma.',
    'Hindari membakar limbah pertanian karena dapat merusak struktur tanah dan mencemari udara.',
    'Untuk skala lebih besar, pertimbangkan biogas dari kotoran ternak sebagai sumber energi alternatif.'
  ],
  1
),
(
  'pertanian-ramah-lingkungan',
  'Tips Pertanian Ramah Lingkungan',
  'leaf',
  'Jaga kesehatan tanah dan ekosistem tanpa mengorbankan hasil panen.',
  'Pertanian ramah lingkungan bukan berarti hasil panen jadi lebih sedikit — justru dengan menjaga kesehatan tanah dan ekosistem sekitar, hasil panen bisa lebih stabil dalam jangka panjang. Prinsip utamanya adalah mengurangi input kimia berlebihan dan memanfaatkan proses alami sebaik mungkin.',
  array[
    'Terapkan rotasi tanaman untuk menjaga kesuburan tanah dan memutus siklus hama/penyakit.',
    'Gunakan pestisida nabati atau musuh alami hama sebagai alternatif pestisida kimia.',
    'Manfaatkan pupuk organik (kompos, pupuk kandang) untuk mengurangi ketergantungan pada pupuk kimia.',
    'Jaga keberadaan tanaman penutup tanah (cover crop) untuk mencegah erosi.',
    'Kelola penggunaan air secara efisien, misalnya dengan irigasi tetes.'
  ],
  2
),
(
  'menghemat-biaya-bertani',
  'Tips Menghemat Biaya Bertani',
  'coin',
  'Tekan biaya produksi tanpa mengorbankan hasil panen.',
  'Biaya produksi sering jadi tantangan terbesar bagi petani kecil. Kabar baiknya, ada banyak cara menekan biaya tanpa mengorbankan hasil panen — mulai dari memanfaatkan sumber daya di sekitar hingga merencanakan pengeluaran dengan lebih cermat.',
  array[
    'Buat kompos dan pupuk organik sendiri dari limbah pertanian/ternak untuk mengurangi biaya pupuk kimia.',
    'Beli sarana produksi (benih, pupuk) secara berkelompok bersama petani lain agar dapat harga lebih murah.',
    'Gunakan benih lokal atau simpan benih hasil panen sebelumnya bila kualitasnya masih baik.',
    'Rawat dan gunakan alat pertanian secara bergantian antar petani untuk menekan biaya investasi alat.',
    'Catat pengeluaran dan pemasukan setiap musim tanam agar tahu pos biaya mana yang bisa dihemat.'
  ],
  3
),
(
  'memanen-dengan-benar',
  'Cara Memanen dengan Benar',
  'basket',
  'Waktu dan teknik panen yang tepat menjaga kualitas hasil pertanian.',
  'Waktu dan cara panen yang tepat sangat memengaruhi kualitas dan daya simpan hasil pertanian. Panen yang terlalu cepat atau terlambat, serta penanganan yang kasar, bisa menurunkan nilai jual hasil panen.',
  array[
    'Panen pada waktu yang tepat sesuai tanda kematangan masing-masing komoditas (warna, kekerasan, kadar air).',
    'Lakukan panen pada pagi atau sore hari untuk menghindari suhu yang terlalu panas.',
    'Gunakan alat panen yang bersih dan tajam agar tidak melukai tanaman atau hasil panen.',
    'Tangani hasil panen dengan hati-hati untuk menghindari memar atau kerusakan fisik.',
    'Segera pindahkan hasil panen ke tempat teduh dan lakukan sortasi sebelum penyimpanan atau distribusi.'
  ],
  4
),
(
  'mengecek-kondisi-tanah',
  'Cara Mengecek Kondisi Tanah',
  'soil',
  'Kenali tekstur, kelembapan, dan pH tanah sebelum menentukan perawatan.',
  'Tanah yang sehat adalah fondasi hasil panen yang baik. Sebelum menanam atau saat tanaman mulai menunjukkan masalah, mengecek kondisi tanah — mulai dari tekstur, kelembapan, hingga tingkat keasaman (pH) — bisa membantu menentukan langkah perawatan yang tepat.',
  array[
    'Cek tekstur tanah dengan menggenggam segenggam tanah lembap — tanah subur biasanya mudah dibentuk namun tidak terlalu lengket.',
    'Gunakan alat pengukur pH sederhana atau kit uji tanah untuk mengetahui tingkat keasaman tanah.',
    'Perhatikan warna tanah — tanah yang gelap biasanya kaya bahan organik, sedangkan tanah pucat menandakan kekurangan nutrisi.',
    'Amati drainase dengan menyiram sebagian tanah dan melihat seberapa cepat air meresap.',
    'Lakukan uji tanah secara berkala, minimal sekali per musim tanam, terutama jika hasil panen mulai menurun.'
  ],
  5
)
on conflict (slug) do update set
  name = excluded.name,
  icon_key = excluded.icon_key,
  description = excluded.description,
  info_intro = excluded.info_intro,
  info_tips = excluded.info_tips,
  sort_order = excluded.sort_order;

-- ------------------------------------------------------------
-- Profil publik (mengikuti auth.users)
-- ------------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text,
  display_name text,
  created_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, display_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'display_name', split_part(new.email, '@', 1))
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ------------------------------------------------------------
-- Pertanyaan
-- user_id mengacu ke public.profiles supaya Supabase bisa join
-- otomatis untuk menampilkan nama penulis.
-- ------------------------------------------------------------
create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  category_id uuid references public.categories (id) on delete set null,
  title text not null,
  description text not null,
  image_url text not null,
  image_path text not null,
  created_at timestamptz not null default now()
);

create index if not exists questions_category_idx on public.questions (category_id);
create index if not exists questions_created_at_idx on public.questions (created_at desc);

alter table public.questions drop constraint if exists questions_user_id_fkey;
alter table public.questions
  add constraint questions_user_id_fkey
  foreign key (user_id) references public.profiles (id) on delete cascade;

-- ------------------------------------------------------------
-- Jawaban
-- ------------------------------------------------------------
create table if not exists public.answers (
  id uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.questions (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  content text not null,
  created_at timestamptz not null default now()
);

create index if not exists answers_question_idx on public.answers (question_id);

alter table public.answers drop constraint if exists answers_user_id_fkey;
alter table public.answers
  add constraint answers_user_id_fkey
  foreign key (user_id) references public.profiles (id) on delete cascade;

-- ------------------------------------------------------------
-- Row Level Security
-- ------------------------------------------------------------
alter table public.categories enable row level security;
alter table public.profiles enable row level security;
alter table public.questions enable row level security;
alter table public.answers enable row level security;

drop policy if exists "Categories are viewable by everyone" on public.categories;
create policy "Categories are viewable by everyone"
  on public.categories for select
  using (true);

drop policy if exists "Profiles are viewable by everyone" on public.profiles;
create policy "Profiles are viewable by everyone"
  on public.profiles for select
  using (true);

drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

drop policy if exists "Questions are viewable by everyone" on public.questions;
create policy "Questions are viewable by everyone"
  on public.questions for select
  using (true);

drop policy if exists "Authenticated users can insert questions" on public.questions;
create policy "Authenticated users can insert questions"
  on public.questions for insert
  with check (auth.uid() = user_id);

drop policy if exists "Owners can update their questions" on public.questions;
create policy "Owners can update their questions"
  on public.questions for update
  using (auth.uid() = user_id);

drop policy if exists "Owners can delete their questions" on public.questions;
create policy "Owners can delete their questions"
  on public.questions for delete
  using (auth.uid() = user_id);

drop policy if exists "Answers are viewable by everyone" on public.answers;
create policy "Answers are viewable by everyone"
  on public.answers for select
  using (true);

drop policy if exists "Authenticated users can insert answers" on public.answers;
create policy "Authenticated users can insert answers"
  on public.answers for insert
  with check (auth.uid() = user_id);

drop policy if exists "Owners can update their answers" on public.answers;
create policy "Owners can update their answers"
  on public.answers for update
  using (auth.uid() = user_id);

drop policy if exists "Owners can delete their answers" on public.answers;
create policy "Owners can delete their answers"
  on public.answers for delete
  using (auth.uid() = user_id);

-- ------------------------------------------------------------
-- Storage: bucket untuk foto pertanyaan
-- ------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('tanisa-images', 'tanisa-images', true)
on conflict (id) do nothing;

drop policy if exists "TANISA images are publicly accessible" on storage.objects;
create policy "TANISA images are publicly accessible"
  on storage.objects for select
  using (bucket_id = 'tanisa-images');

drop policy if exists "Authenticated users can upload TANISA images" on storage.objects;
create policy "Authenticated users can upload TANISA images"
  on storage.objects for insert
  with check (bucket_id = 'tanisa-images' and auth.role() = 'authenticated');

drop policy if exists "Owners can delete their TANISA images" on storage.objects;
create policy "Owners can delete their TANISA images"
  on storage.objects for delete
  using (bucket_id = 'tanisa-images' and auth.uid()::text = (storage.foldername(name))[1]);
