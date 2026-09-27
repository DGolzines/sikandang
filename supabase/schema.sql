-- =========================================================
-- SIKANDANG — Supabase schema
-- Jalankan seluruh file ini di: Supabase Dashboard > SQL Editor > New query
-- =========================================================

-- 1. Tabel profil (data tambahan untuk setiap user auth)
create table if not exists public.profiles (
	id uuid primary key references auth.users (id) on delete cascade,
	username text not null,
	created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Profil bisa dilihat siapa saja"
	on public.profiles for select
	using (true);

create policy "User bisa update profil sendiri"
	on public.profiles for update
	using (auth.uid() = id);

-- Trigger: otomatis buat baris profiles saat ada user baru daftar
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
	insert into public.profiles (id, username)
	values (
		new.id,
		coalesce(new.raw_user_meta_data ->> 'username', split_part(new.email, '@', 1))
	);
	return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
	after insert on auth.users
	for each row execute procedure public.handle_new_user();

-- 2. Tabel pertanyaan
create table if not exists public.questions (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null references auth.users (id) on delete cascade,
	category text not null check (
		category in (
			'stres-musim-hujan',
			'membersihkan-kandang',
			'memilih-bibit-unggul',
			'cek-kesehatan-ternak'
		)
	),
	title text not null,
	description text not null,
	image_url text,
	created_at timestamptz not null default now()
);

alter table public.questions enable row level security;

create policy "Pertanyaan bisa dilihat siapa saja"
	on public.questions for select
	using (true);

create policy "User login bisa membuat pertanyaan"
	on public.questions for insert
	with check (auth.uid() = user_id);

create policy "Pemilik bisa menghapus pertanyaan sendiri"
	on public.questions for delete
	using (auth.uid() = user_id);

create policy "Pemilik bisa mengubah pertanyaan sendiri"
	on public.questions for update
	using (auth.uid() = user_id);

create index if not exists questions_category_idx on public.questions (category);
create index if not exists questions_created_at_idx on public.questions (created_at desc);

-- 3. Tabel jawaban
create table if not exists public.answers (
	id uuid primary key default gen_random_uuid(),
	question_id uuid not null references public.questions (id) on delete cascade,
	user_id uuid not null references auth.users (id) on delete cascade,
	body text not null,
	image_url text,
	created_at timestamptz not null default now()
);

alter table public.answers enable row level security;

create policy "Jawaban bisa dilihat siapa saja"
	on public.answers for select
	using (true);

create policy "User login bisa menjawab"
	on public.answers for insert
	with check (auth.uid() = user_id);

create policy "Pemilik bisa menghapus jawaban sendiri"
	on public.answers for delete
	using (auth.uid() = user_id);

create index if not exists answers_question_id_idx on public.answers (question_id);

-- 4. Storage bucket untuk foto pertanyaan/jawaban
insert into storage.buckets (id, name, public)
values ('post-images', 'post-images', true)
on conflict (id) do nothing;

create policy "Foto post bisa dilihat siapa saja"
	on storage.objects for select
	using (bucket_id = 'post-images');

create policy "User login bisa upload foto post"
	on storage.objects for insert
	with check (bucket_id = 'post-images' and auth.role() = 'authenticated');

create policy "User bisa hapus foto miliknya sendiri"
	on storage.objects for delete
	using (bucket_id = 'post-images' and auth.uid()::text = (storage.foldername(name))[1]);

-- =========================================================
-- Selesai. Lanjutkan ke README.md untuk langkah konfigurasi
-- environment variable & deploy ke Vercel.
-- =========================================================
