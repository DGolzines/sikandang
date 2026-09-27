<script>
	import { invalidateAll, goto } from '$app/navigation';
	import { timeAgo } from '$lib/utils.js';

	export let data;
	$: ({ category, question, answers, supabase, user } = data);

	let answerBody = '';
	let answerFile = null;
	let answerPreview = null;
	let posting = false;
	let deleting = false;
	let errorMsg = '';

	function onAnswerFileChange(e) {
		const f = e.target.files?.[0];
		if (!f) {
			answerFile = null;
			answerPreview = null;
			return;
		}
		if (!f.type.startsWith('image/')) {
			errorMsg = 'File harus berupa gambar.';
			return;
		}
		if (f.size > 5 * 1024 * 1024) {
			errorMsg = 'Ukuran gambar maksimal 5MB.';
			return;
		}
		errorMsg = '';
		answerFile = f;
		answerPreview = URL.createObjectURL(f);
	}

	async function submitAnswer() {
		errorMsg = '';
		if (!answerBody.trim()) {
			errorMsg = 'Jawaban tidak boleh kosong.';
			return;
		}
		posting = true;
		try {
			let image_url = null;
			if (answerFile) {
				const path = `${user.id}/${Date.now()}-${answerFile.name.replace(/\s+/g, '-')}`;
				const { error: upErr } = await supabase.storage
					.from('post-images')
					.upload(path, answerFile, { cacheControl: '3600', upsert: false });
				if (upErr) throw upErr;
				const { data: pub } = supabase.storage.from('post-images').getPublicUrl(path);
				image_url = pub.publicUrl;
			}

			const { error: insErr } = await supabase.from('answers').insert({
				question_id: question.id,
				body: answerBody.trim(),
				image_url,
				user_id: user.id
			});
			if (insErr) throw insErr;

			answerBody = '';
			answerFile = null;
			answerPreview = null;
			await invalidateAll();
		} catch (err) {
			errorMsg = err.message ?? 'Gagal mengirim jawaban.';
		} finally {
			posting = false;
		}
	}

	async function deleteQuestion() {
		if (!confirm('Hapus pertanyaan ini beserta seluruh jawabannya?')) return;
		deleting = true;
		const { error: delErr } = await supabase.from('questions').delete().eq('id', question.id);
		deleting = false;
		if (delErr) {
			errorMsg = delErr.message;
			return;
		}
		await goto(`/forum/${category.slug}`);
	}

	async function deleteAnswer(id) {
		if (!confirm('Hapus jawaban ini?')) return;
		const { error: delErr } = await supabase.from('answers').delete().eq('id', id);
		if (delErr) {
			errorMsg = delErr.message;
			return;
		}
		await invalidateAll();
	}
</script>

<svelte:head><title>{question.title} — SIKANDANG</title></svelte:head>

<section class="wrap detail-wrap">
	<a href="/forum/{category.slug}" class="crumb">← {category.title}</a>

	{#if errorMsg}
		<div class="alert alert-error">{errorMsg}</div>
	{/if}

	<article class="q-detail notice-card">
		<span class="pin" aria-hidden="true"></span>
		<div class="q-head">
			<span class="tag">{category.icon} {category.title}</span>
			{#if user && user.id === question.user_id}
				<button class="btn-danger" on:click={deleteQuestion} disabled={deleting}>
					{deleting ? 'Menghapus…' : '🗑 Hapus Pertanyaan'}
				</button>
			{/if}
		</div>
		<h1>{question.title}</h1>
		<p class="meta">👤 {question.profiles?.username ?? 'Peternak'} · {timeAgo(question.created_at)}</p>
		<p class="desc">{question.description}</p>
		{#if question.image_url}
			<div class="q-image imgwrap">
				<img src={question.image_url} alt="Foto pertanyaan" loading="lazy" />
			</div>
		{/if}
	</article>

	<h2 class="answers-title">{answers.length} Jawaban</h2>

	<div class="answers-list">
		{#each answers as a}
			<div class="answer-card notice-card">
				<div class="answer-head">
					<span class="meta">👤 {a.profiles?.username ?? 'Peternak'} · {timeAgo(a.created_at)}</span>
					{#if user && user.id === a.user_id}
						<button class="btn-danger" on:click={() => deleteAnswer(a.id)}>🗑 Hapus</button>
					{/if}
				</div>
				<p>{a.body}</p>
				{#if a.image_url}
					<div class="a-image imgwrap">
						<img src={a.image_url} alt="Foto jawaban" loading="lazy" />
					</div>
				{/if}
			</div>
		{:else}
			<div class="empty-card notice-card">
				<p>Belum ada jawaban. Bantu peternak ini dengan pengalaman Anda!</p>
			</div>
		{/each}
	</div>

	{#if user}
		<div class="answer-form notice-card">
			<span class="pin" aria-hidden="true"></span>
			<h3>Tulis Jawaban</h3>
			<div class="field">
				<textarea
					bind:value={answerBody}
					placeholder="Bagikan pengalaman atau saran Anda untuk masalah ini…"
					required
				></textarea>
			</div>
			<div class="field">
				<label for="afile">Foto (opsional)</label>
				<input id="afile" type="file" accept="image/*" on:change={onAnswerFileChange} />
				{#if answerPreview}
					<div class="preview-wrap">
						<img src={answerPreview} alt="Pratinjau" />
					</div>
				{/if}
			</div>
			<button class="btn btn-primary" on:click={submitAnswer} disabled={posting}>
				{posting ? 'Mengirim…' : 'Kirim Jawaban'}
			</button>
		</div>
	{:else}
		<div class="login-prompt notice-card">
			<p><a href="/login">Masuk</a> untuk ikut menjawab pertanyaan ini.</p>
		</div>
	{/if}
</section>

<style>
	.detail-wrap {
		max-width: 760px;
		padding: 36px 24px 90px;
	}
	.crumb {
		color: var(--soil-700);
		text-decoration: none;
		font-weight: 600;
		font-size: 0.88rem;
	}
	.q-detail {
		margin: 18px 0 32px;
		padding: 30px 30px 34px;
	}
	.q-head {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 12px;
		margin-bottom: 12px;
	}
	h1 {
		font-size: clamp(1.4rem, 3vw, 1.9rem);
	}
	.meta {
		color: var(--soil-500);
		font-size: 0.85rem;
		margin-bottom: 14px;
	}
	.desc {
		color: var(--ink);
		white-space: pre-wrap;
	}
	.q-image,
	.a-image {
		margin-top: 16px;
		border-radius: 10px;
		overflow: hidden;
		border: 2px solid var(--soil-800);
		max-height: 420px;
	}
	.q-image img,
	.a-image img {
		width: 100%;
		max-height: 420px;
		object-fit: cover;
	}
	.answers-title {
		font-size: 1.2rem;
		margin-bottom: 16px;
	}
	.answers-list {
		display: flex;
		flex-direction: column;
		gap: 16px;
		margin-bottom: 34px;
	}
	.answer-card {
		padding: 20px 22px;
	}
	.answer-head {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 8px;
		gap: 12px;
	}
	.empty-card {
		padding: 22px;
	}
	.answer-form {
		padding: 26px 28px 28px;
	}
	.answer-form h3 {
		font-size: 1.05rem;
	}
	.preview-wrap {
		margin-top: 10px;
		max-width: 220px;
	}
	.preview-wrap img {
		border-radius: 10px;
		border: 2px solid var(--soil-800);
	}
	.login-prompt {
		padding: 20px 24px;
		text-align: center;
	}
	.login-prompt a {
		color: var(--clay-500);
		font-weight: 700;
	}
</style>
