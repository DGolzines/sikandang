<script>
	import { categories, getCategory } from '$lib/categories.js';

	export let data;
	$: recentQuestions = data.recentQuestions;

	function timeAgo(dateStr) {
		const diff = Date.now() - new Date(dateStr).getTime();
		const mins = Math.floor(diff / 60000);
		if (mins < 1) return 'baru saja';
		if (mins < 60) return `${mins} menit lalu`;
		const hrs = Math.floor(mins / 60);
		if (hrs < 24) return `${hrs} jam lalu`;
		const days = Math.floor(hrs / 24);
		return `${days} hari lalu`;
	}

	const galleryPhotos = [
		'https://images.unsplash.com/photo-1500595046743-cd271d694d30?auto=format&fit=crop&w=600&q=80',
		'https://images.unsplash.com/photo-1560468660-6c11a19d7330?auto=format&fit=crop&w=600&q=80',
		'https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=600&q=80',
		'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=600&q=80'
	];

	function hideImg(e) {
		e.target.closest('.imgwrap')?.classList.add('img-fallback');
	}
</script>

<svelte:head>
	<title>SIKANDANG — Sistem Informasi Manajemen Kesehatan Kandang</title>
</svelte:head>

<section class="hero">
	<div class="wrap hero-inner">
		<div class="hero-copy">
			<span class="tag">Edukasi Digital Peternak Lokal</span>
			<h1>Kandang sehat, ternak produktif, panen tak lagi jadi tebakan.</h1>
			<p class="lead">
				SIKANDANG adalah forum tanya jawab sekaligus pusat edukasi untuk peternak — mulai dari
				menjaga ternak saat musim hujan, membersihkan kandang, memilih bibit unggul, sampai
				mengecek kesehatan harian. Tanya langsung ke sesama peternak, jawab, dan belajar bersama.
			</p>
			<div class="hero-actions">
				<a href="#kategori" class="btn btn-primary">Jelajahi Forum Edukasi</a>
				<a href="/register" class="btn btn-ghost">Buat Akun Gratis</a>
			</div>
			<div class="stat-strip">
				<div><strong>4</strong><span>Topik edukasi inti</span></div>
				<div><strong>{recentQuestions.length}+</strong><span>Diskusi aktif</span></div>
				<div><strong>24/7</strong><span>Bisa diakses kapan saja</span></div>
			</div>
		</div>

		<div class="hero-photos" aria-hidden="true">
			<div class="photo-a imgwrap">
				<img src={galleryPhotos[0]} alt="" on:error={hideImg} loading="lazy" />
			</div>
			<div class="photo-b imgwrap">
				<img src={galleryPhotos[1]} alt="" on:error={hideImg} loading="lazy" />
			</div>
			<div class="photo-c imgwrap">
				<img src={galleryPhotos[2]} alt="" on:error={hideImg} loading="lazy" />
			</div>
			<span class="sticker">🌾 Untuk peternak, oleh peternak</span>
		</div>
	</div>
</section>

<div class="ticker" aria-hidden="true">
	<div class="ticker-track">
		{#each [...recentQuestions, ...recentQuestions] as q}
			<span>📌 {q.title}</span>
		{/each}
		{#if recentQuestions.length === 0}
			<span>📌 Selamat datang di SIKANDANG — jadilah yang pertama bertanya!</span>
		{/if}
	</div>
</div>

<section class="section" id="kategori">
	<div class="wrap">
		<div class="section-head">
			<h2>Papan Edukasi Kandang</h2>
			<p>Empat topik inti yang paling sering dicari peternak — setiap forum sudah dilengkapi materi lengkap.</p>
		</div>

		<div class="cat-grid">
			{#each categories as c, i}
				<a href="/forum/{c.slug}" class="cat-card notice-card">
					<span class="pin" aria-hidden="true"></span>
					<div class="cat-photo imgwrap">
						<img src={c.image} alt="" on:error={hideImg} loading="lazy" />
						<span class="cat-icon">{c.icon}</span>
					</div>
					<div class="cat-body">
						<h3>{c.title}</h3>
						<p>{c.short}</p>
						<span class="cat-link">Masuk forum →</span>
					</div>
				</a>
			{/each}
		</div>
	</div>
</section>

<section class="section section-alt">
	<div class="wrap two-col">
		<div>
			<div class="section-head left">
				<h2>Pertanyaan Terbaru</h2>
				<p>Diskusi terkini dari peternak di seluruh forum.</p>
			</div>

			{#if recentQuestions.length === 0}
				<div class="empty-card notice-card">
					<p>Belum ada pertanyaan. Masuk ke salah satu forum dan jadilah yang pertama bertanya!</p>
				</div>
			{:else}
				<div class="q-list">
					{#each recentQuestions as q}
						{@const cat = getCategory(q.category)}
						<a href="/forum/{q.category}/{q.id}" class="q-item">
							<div class="q-thumb imgwrap">
								{#if q.image_url}
									<img src={q.image_url} alt="" on:error={hideImg} loading="lazy" />
								{:else}
									<span>{cat?.icon ?? '🐄'}</span>
								{/if}
							</div>
							<div class="q-body">
								<span class="tag tag-sm">{cat?.title ?? q.category}</span>
								<h4>{q.title}</h4>
								<div class="q-meta">
									<span>{q.profiles?.username ?? 'Peternak'}</span>
									<span>·</span>
									<span>{timeAgo(q.created_at)}</span>
									<span>·</span>
									<span>{q.answers?.[0]?.count ?? 0} jawaban</span>
								</div>
							</div>
						</a>
					{/each}
				</div>
			{/if}
		</div>

		<aside class="side-gallery">
			<h3>Galeri Peternakan</h3>
			<div class="gallery-grid">
				{#each galleryPhotos as g}
					<div class="imgwrap gallery-item">
						<img src={g} alt="" on:error={hideImg} loading="lazy" />
					</div>
				{/each}
			</div>
			<div class="side-cta notice-card">
				<span class="pin" aria-hidden="true"></span>
				<h4>Punya masalah di kandang?</h4>
				<p>Tanyakan langsung ke komunitas peternak SIKANDANG, gratis dan bisa sertakan foto.</p>
				<a href="/register" class="btn btn-clay" style="width:100%; justify-content:center;">Mulai Bertanya</a>
			</div>
		</aside>
	</div>
</section>

<style>
	.hero {
		background: linear-gradient(160deg, var(--soil-800) 0%, var(--soil-700) 55%, var(--soil-600) 100%);
		color: var(--cream-ink);
		padding: 64px 0 80px;
		position: relative;
		overflow: hidden;
	}
	.hero::after {
		content: '';
		position: absolute;
		inset: 0;
		background: radial-gradient(circle at 90% 10%, rgba(217, 148, 86, 0.25), transparent 45%);
		pointer-events: none;
	}
	.hero-inner {
		display: grid;
		grid-template-columns: 1.1fr 0.9fr;
		gap: 48px;
		align-items: center;
		position: relative;
		z-index: 1;
	}
	.hero-copy h1 {
		color: #fff;
		font-size: clamp(2rem, 4vw, 2.9rem);
		margin: 16px 0 18px;
		max-width: 16ch;
	}
	.lead {
		color: var(--wheat-200);
		max-width: 54ch;
		font-size: 1.02rem;
	}
	.hero-actions {
		display: flex;
		gap: 14px;
		flex-wrap: wrap;
		margin: 28px 0 40px;
	}
	.hero-actions .btn-ghost {
		color: var(--cream-ink);
		border-color: var(--cream-ink);
	}
	.hero-actions .btn-ghost:hover {
		background: var(--cream-ink);
		color: var(--soil-800);
	}
	.stat-strip {
		display: flex;
		gap: 32px;
		border-top: 1px solid rgba(255, 255, 255, 0.18);
		padding-top: 22px;
	}
	.stat-strip div {
		display: flex;
		flex-direction: column;
	}
	.stat-strip strong {
		font-family: var(--font-display);
		font-size: 1.6rem;
		color: var(--clay-400);
	}
	.stat-strip span {
		font-size: 0.78rem;
		opacity: 0.8;
	}

	.hero-photos {
		position: relative;
		height: 360px;
	}
	.hero-photos .imgwrap {
		position: absolute;
		border: 5px solid var(--wheat-50);
		border-radius: 6px;
		box-shadow: 0 14px 30px rgba(0, 0, 0, 0.35);
		overflow: hidden;
		background: var(--soil-500);
	}
	.hero-photos img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	.photo-a {
		width: 62%;
		height: 62%;
		top: 0;
		right: 0;
		transform: rotate(4deg);
		z-index: 2;
	}
	.photo-b {
		width: 46%;
		height: 46%;
		bottom: 6%;
		left: 0;
		transform: rotate(-6deg);
		z-index: 3;
	}
	.photo-c {
		width: 40%;
		height: 34%;
		top: 8%;
		left: 8%;
		transform: rotate(-3deg);
		z-index: 1;
	}
	.sticker {
		position: absolute;
		bottom: -6px;
		right: 6%;
		background: var(--clay-500);
		color: var(--soil-900);
		font-weight: 700;
		font-size: 0.78rem;
		padding: 8px 14px;
		border-radius: 999px;
		box-shadow: var(--shadow-stamp);
		z-index: 4;
	}

	.ticker {
		background: var(--soil-900);
		color: var(--wheat-200);
		overflow: hidden;
		white-space: nowrap;
		border-bottom: 2px solid var(--clay-500);
		padding: 10px 0;
	}
	.ticker-track {
		display: inline-block;
		padding-left: 100%;
		animation: scroll-left 32s linear infinite;
		font-size: 0.85rem;
	}
	.ticker-track span {
		margin-right: 48px;
	}
	@keyframes scroll-left {
		from {
			transform: translateX(0);
		}
		to {
			transform: translateX(-50%);
		}
	}

	.section {
		padding: 72px 0;
	}
	.section-alt {
		background: var(--wheat-200);
	}
	.section-head {
		max-width: 640px;
		margin: 0 auto 40px;
		text-align: center;
	}
	.section-head.left {
		margin: 0 0 32px;
		text-align: left;
	}
	.section-head h2 {
		font-size: clamp(1.6rem, 3vw, 2.1rem);
	}
	.section-head p {
		color: var(--soil-600);
	}

	.cat-grid {
		display: grid;
		grid-template-columns: repeat(2, 1fr);
		gap: 28px;
	}
	.cat-card {
		display: flex;
		flex-direction: column;
		text-decoration: none;
		color: inherit;
		overflow: hidden;
		transition: transform 0.18s ease, box-shadow 0.18s ease;
	}
	.cat-card:hover {
		transform: translateY(-4px);
		box-shadow: 6px 10px 0 rgba(36, 21, 9, 0.22);
	}
	.cat-photo {
		height: 190px;
		position: relative;
		border-radius: 0;
		border: none;
		border-bottom: 2px solid var(--soil-800);
	}
	.cat-icon {
		position: absolute;
		bottom: 10px;
		left: 12px;
		background: var(--wheat-50);
		border: 2px solid var(--soil-800);
		border-radius: 50%;
		width: 44px;
		height: 44px;
		display: grid;
		place-items: center;
		font-size: 1.3rem;
	}
	.cat-body {
		padding: 20px 22px 24px;
	}
	.cat-body h3 {
		font-size: 1.15rem;
	}
	.cat-body p {
		color: var(--soil-600);
		font-size: 0.92rem;
	}
	.cat-link {
		color: var(--clay-500);
		font-weight: 700;
		font-size: 0.88rem;
	}

	.two-col {
		display: grid;
		grid-template-columns: 1.6fr 1fr;
		gap: 44px;
		align-items: start;
	}

	.q-list {
		display: flex;
		flex-direction: column;
		gap: 14px;
	}
	.q-item {
		display: flex;
		gap: 16px;
		background: var(--wheat-50);
		border: 2px solid var(--soil-800);
		border-radius: 4px 16px 4px 16px;
		padding: 14px;
		text-decoration: none;
		color: inherit;
		transition: transform 0.15s ease;
	}
	.q-item:hover {
		transform: translateX(4px);
	}
	.q-thumb {
		width: 74px;
		height: 74px;
		flex: none;
		border-radius: 10px;
		overflow: hidden;
		background: var(--wheat-200);
		display: grid;
		place-items: center;
		font-size: 1.6rem;
		border: 2px solid var(--soil-800);
	}
	.q-thumb img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	.q-body h4 {
		font-size: 1rem;
		margin: 6px 0 6px;
	}
	.tag-sm {
		font-size: 0.68rem;
		padding: 3px 10px;
	}
	.q-meta {
		display: flex;
		gap: 6px;
		font-size: 0.78rem;
		color: var(--soil-600);
	}

	.empty-card {
		padding: 28px;
	}

	.side-gallery h3 {
		font-size: 1.05rem;
	}
	.gallery-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 10px;
		margin-bottom: 24px;
	}
	.gallery-item {
		height: 100px;
		border-radius: 10px;
		overflow: hidden;
		border: 2px solid var(--soil-800);
	}
	.gallery-item img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	.side-cta {
		padding: 22px;
	}
	.side-cta h4 {
		font-size: 1.05rem;
	}
	.side-cta p {
		font-size: 0.88rem;
		color: var(--soil-600);
	}

	.imgwrap.img-fallback {
		background: linear-gradient(135deg, var(--soil-500), var(--soil-700));
	}
	.imgwrap.img-fallback img {
		visibility: hidden;
	}

	@media (max-width: 900px) {
		.hero-inner {
			grid-template-columns: 1fr;
		}
		.hero-photos {
			height: 280px;
			margin-top: 12px;
		}
		.cat-grid {
			grid-template-columns: 1fr;
		}
		.two-col {
			grid-template-columns: 1fr;
		}
	}
</style>
