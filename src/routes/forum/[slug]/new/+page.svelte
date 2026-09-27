<script>
	import { goto } from '$app/navigation';

	export let data;
	$: ({ category, supabase, user } = data);

	let title = '';
	let description = '';
	let file = null;
	let preview = null;
	let loading = false;
	let errorMsg = '';

	function onFileChange(e) {
		const f = e.target.files?.[0];
		if (!f) {
			file = null;
			preview = null;
			return;
		}
		if (!f.type.startsWith('image/')) {
			errorMsg = 'File harus berupa gambar (jpg, png, dll).';
			return;
		}
		if (f.size > 5 * 1024 * 1024) {
			errorMsg = 'Ukuran gambar maksimal 5MB.';
			return;
		}
		errorMsg = '';
		file = f;
		preview = URL.createObjectURL(f);
	}

	function removeFile() {
		file = null;
		preview = null;
	}

	async function submit() {
		errorMsg = '';
		if (!title.trim() || !description.trim()) {
			errorMsg = 'Judul dan deskripsi wajib diisi.';
			return;
		}
		loading = true;
		try {
			let image_url = null;

			if (file) {
				const path = `${user.id}/${Date.now()}-${file.name.replace(/\s+/g, '-')}`;
				const { error: uploadError } = await supabase.storage
					.from('post-images')
					.upload(path, file, { cacheControl: '3600', upsert: false });

				if (uploadError) throw uploadError;

				const { data: publicUrlData } = supabase.storage.from('post-images').getPublicUrl(path);
				image_url = publicUrlData.publicUrl;
			}

			const { data: inserted, error: insertError } = await supabase
				.from('questions')
				.insert({
					title: title.trim(),
					description: description.trim(),
					category: category.slug,
					image_url,
					user_id: user.id
				})
				.select('id')
				.single();

			if (insertError) throw insertError;

			await goto(`/forum/${category.slug}/${inserted.id}`);
		} catch (err) {
			errorMsg = err.message ?? 'Terjadi kesalahan, coba lagi.';
		} finally {
			loading = false;
		}
	}
</script>

<svelte:head><title>Ajukan Pertanyaan — {category.title}</title></svelte:head>

<section class="wrap form-section">
	<a href="/forum/{category.slug}" class="crumb">← Kembali ke {category.title}</a>

	<div class="form-card notice-card">
		<span class="pin" aria-hidden="true"></span>
		<h1>Ajukan Pertanyaan</h1>
		<p class="sub">Forum: <strong>{category.icon} {category.title}</strong></p>

		{#if errorMsg}
			<div class="alert alert-error">{errorMsg}</div>
		{/if}

		<form on:submit|preventDefault={submit}>
			<div class="field">
				<label for="title">Judul Pertanyaan</label>
				<input
					id="title"
					type="text"
					bind:value={title}
					required
					placeholder="Contoh: Kambing saya menggigil terus saat hujan, apa penyebabnya?"
				/>
			</div>

			<div class="field">
				<label for="description">Deskripsi</label>
				<textarea
					id="description"
					bind:value={description}
					required
					placeholder="Jelaskan kondisi ternak Anda selengkap mungkin: gejala, sudah berapa lama, jenis ternak, dsb."
				></textarea>
			</div>

			<div class="field">
				<label for="photo">Foto (opsional)</label>
				<input id="photo" type="file" accept="image/*" on:change={onFileChange} />
				{#if preview}
					<div class="preview-wrap">
						<img src={preview} alt="Pratinjau foto" />
						<button type="button" class="btn-danger" on:click={removeFile}>Hapus Foto</button>
					</div>
				{/if}
			</div>

			<button class="btn btn-primary" type="submit" disabled={loading} style="width:100%; justify-content:center;">
				{loading ? 'Mengirim…' : 'Kirim Pertanyaan'}
			</button>
		</form>
	</div>
</section>

<style>
	.form-section {
		padding: 40px 24px 90px;
		max-width: 720px;
	}
	.crumb {
		color: var(--soil-700);
		text-decoration: none;
		font-size: 0.88rem;
		font-weight: 600;
	}
	.form-card {
		margin-top: 20px;
		padding: 34px 32px;
	}
	.sub {
		color: var(--soil-600);
		font-size: 0.92rem;
	}
	.preview-wrap {
		margin-top: 10px;
		max-width: 260px;
	}
	.preview-wrap img {
		border-radius: 10px;
		border: 2px solid var(--soil-800);
		margin-bottom: 8px;
	}
</style>
