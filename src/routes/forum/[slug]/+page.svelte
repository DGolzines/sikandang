<script>
	import { timeAgo } from '$lib/utils.js';

	export let data;
	$: ({ category, questions, user } = data);

	let showFullArticle = true;
</script>

<svelte:head><title>{category.title} — SIKANDANG</title></svelte:head>

<section class="cat-hero">
	<div class="wrap cat-hero-inner">
		<div class="cat-hero-photo photo-bg" style="background-image: url('{category.image}');"></div>
		<div>
			<a href="/" class="crumb">← Semua Forum</a>
			<span class="tag">{category.icon} Edukasi &amp; Forum</span>
			<h1>{category.title}</h1>
			<p class="lead">{category.short}</p>
		</div>
	</div>
</section>

<section class="wrap article-section">
	<article class="article notice-card">
		<span class="pin" aria-hidden="true"></span>
		<div class="article-head">
			<h2>📖 Materi Edukasi</h2>
			<button class="toggle" on:click={() => (showFullArticle = !showFullArticle)}>
				{showFullArticle ? 'Sembunyikan' : 'Tampilkan'}
			</button>
		</div>

		{#if showFullArticle}
			<p class="intro">{category.article.intro}</p>

			<div class="points">
				{#each category.article.points as p, i}
					<div class="point">
						<span class="point-no">{String(i + 1).padStart(2, '0')}</span>
						<div>
							<h3>{p.heading}</h3>
							<p>{p.text}</p>
						</div>
					</div>
				{/each}
			</div>

			<div class="tipbox">
				<h4>💡 Tips Cepat</h4>
				<ul>
					{#each category.article.tips as t}
						<li>{t}</li>
					{/each}
				</ul>
			</div>
		{/if}
	</article>
</section>

<section class="wrap qa-section">
	<div class="qa-head">
		<div>
			<h2>💬 Forum Tanya Jawab</h2>
			<p>{questions.length} pertanyaan di topik ini.</p>
		</div>
		{#if user}
			<a href="/forum/{category.slug}/new" class="btn btn-primary">+ Ajukan Pertanyaan</a>
		{:else}
			<a href="/login" class="btn btn-primary">Masuk untuk Bertanya</a>
		{/if}
	</div>

	{#if questions.length === 0}
		<div class="empty-card notice-card">
			<p>Belum ada pertanyaan di forum ini. Jadilah yang pertama bertanya seputar
				<strong>{category.title.toLowerCase()}</strong>!</p>
		</div>
	{:else}
		<div class="q-grid">
			{#each questions as q}
				<a href="/forum/{category.slug}/{q.id}" class="q-card notice-card">
					{#if q.image_url}
						<div class="q-photo imgwrap">
							<img src={q.image_url} alt="" loading="lazy" />
						</div>
					{/if}
					<div class="q-content">
						<h3>{q.title}</h3>
						<p>{q.description}</p>
						<div class="q-meta">
							<span class="author">👤 {q.profiles?.username ?? 'Peternak'}</span>
							<span>{timeAgo(q.created_at)}</span>
							<span class="answers-count">{q.answers?.[0]?.count ?? 0} jawaban</span>
						</div>
					</div>
				</a>
			{/each}
		</div>
	{/if}
</section>

<style>
	.cat-hero {
		background: var(--soil-700);
		color: var(--cream-ink);
		padding: 48px 0;
	}
	.cat-hero-inner {
		display: grid;
		grid-template-columns: 220px 1fr;
		gap: 32px;
		align-items: center;
	}
	.cat-hero-photo {
		width: 220px;
		height: 160px;
		border-radius: 6px 22px 6px 22px;
		overflow: hidden;
		border: 4px solid var(--wheat-50);
	}
	.crumb {
		display: inline-block;
		color: var(--wheat-200);
		text-decoration: none;
		font-size: 0.85rem;
		margin-bottom: 10px;
		opacity: 0.85;
	}
	.cat-hero h1 {
		color: #fff;
		margin: 10px 0 8px;
		font-size: clamp(1.5rem, 3vw, 2.1rem);
		max-width: 30ch;
	}
	.lead {
		color: var(--wheat-200);
		max-width: 60ch;
	}

	.article-section {
		margin-top: -28px;
		position: relative;
		z-index: 2;
	}
	.article {
		padding: 32px 34px;
	}
	.article-head {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}
	.toggle {
		background: none;
		border: none;
		color: var(--clay-500);
		font-weight: 700;
		cursor: pointer;
		font-size: 0.85rem;
	}
	.intro {
		color: var(--soil-700);
		font-size: 1rem;
		border-left: 3px solid var(--leaf-600);
		padding-left: 16px;
	}
	.points {
		display: flex;
		flex-direction: column;
		gap: 18px;
		margin: 24px 0;
	}
	.point {
		display: grid;
		grid-template-columns: 40px 1fr;
		gap: 14px;
	}
	.point-no {
		font-family: var(--font-display);
		font-weight: 700;
		color: var(--clay-500);
		font-size: 1.1rem;
	}
	.point h3 {
		font-size: 1.02rem;
		margin-bottom: 4px;
	}
	.point p {
		color: var(--soil-600);
		font-size: 0.93rem;
		margin: 0;
	}
	.tipbox {
		background: var(--wheat-100);
		border-radius: 10px;
		padding: 18px 22px;
	}
	.tipbox h4 {
		font-size: 0.95rem;
		margin-bottom: 10px;
	}
	.tipbox ul {
		margin: 0;
		padding-left: 20px;
		color: var(--soil-700);
		font-size: 0.9rem;
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.qa-section {
		padding: 48px 24px 80px;
	}
	.qa-head {
		display: flex;
		justify-content: space-between;
		align-items: flex-end;
		margin-bottom: 26px;
		gap: 16px;
		flex-wrap: wrap;
	}
	.qa-head p {
		color: var(--soil-600);
		margin: 0;
	}

	.empty-card {
		padding: 26px;
	}

	.q-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
		gap: 20px;
	}
	.q-card {
		text-decoration: none;
		color: inherit;
		overflow: hidden;
		display: flex;
		flex-direction: column;
		transition: transform 0.15s ease, box-shadow 0.15s ease;
	}
	.q-card:hover {
		transform: translateY(-3px);
		box-shadow: 6px 9px 0 rgba(36, 21, 9, 0.22);
	}
	.q-photo {
		height: 150px;
		border: none;
		border-bottom: 2px solid var(--soil-800);
		border-radius: 0;
	}
	.q-photo img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	.q-content {
		padding: 16px 18px 18px;
	}
	.q-content h3 {
		font-size: 1.02rem;
		margin-bottom: 6px;
	}
	.q-content p {
		font-size: 0.87rem;
		color: var(--soil-600);
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
		overflow: hidden;
	}
	.q-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 10px;
		font-size: 0.76rem;
		color: var(--soil-500);
		margin-top: 10px;
	}
	.answers-count {
		background: var(--wheat-200);
		padding: 2px 9px;
		border-radius: 999px;
		font-weight: 600;
	}

	@media (max-width: 700px) {
		.cat-hero-inner {
			grid-template-columns: 1fr;
		}
		.cat-hero-photo {
			width: 100%;
		}
	}
</style>
