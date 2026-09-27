<script>
	import { getCategory } from '$lib/categories.js';
	import { timeAgo } from '$lib/utils.js';

	export let data;
	$: ({ user, myQuestions } = data);
</script>

<svelte:head><title>Akun Saya — SIKANDANG</title></svelte:head>

<section class="wrap akun-wrap">
	<div class="akun-card notice-card">
		<span class="pin" aria-hidden="true"></span>
		<div class="avatar">👤</div>
		<h1>{user.user_metadata?.username ?? user.email?.split('@')[0]}</h1>
		<p class="email">{user.email}</p>
	</div>

	<h2>Pertanyaan Saya ({myQuestions.length})</h2>
	{#if myQuestions.length === 0}
		<div class="empty-card notice-card">
			<p>Anda belum pernah bertanya. <a href="/">Jelajahi forum</a> untuk mulai bertanya.</p>
		</div>
	{:else}
		<div class="list">
			{#each myQuestions as q}
				{@const cat = getCategory(q.category)}
				<a class="item notice-card" href="/forum/{q.category}/{q.id}">
					<span class="tag">{cat?.icon} {cat?.title}</span>
					<h3>{q.title}</h3>
					<span class="meta">{timeAgo(q.created_at)}</span>
				</a>
			{/each}
		</div>
	{/if}
</section>

<style>
	.akun-wrap {
		max-width: 640px;
		padding: 40px 24px 90px;
	}
	.akun-card {
		text-align: center;
		padding: 34px;
		margin-bottom: 40px;
	}
	.avatar {
		width: 64px;
		height: 64px;
		border-radius: 50%;
		background: var(--wheat-200);
		border: 2px solid var(--soil-800);
		display: grid;
		place-items: center;
		font-size: 1.8rem;
		margin: 0 auto 14px;
	}
	.email {
		color: var(--soil-500);
		font-size: 0.9rem;
	}
	h2 {
		font-size: 1.1rem;
		margin-bottom: 16px;
	}
	.list {
		display: flex;
		flex-direction: column;
		gap: 12px;
	}
	.item {
		display: block;
		padding: 16px 20px;
		text-decoration: none;
		color: inherit;
	}
	.item h3 {
		font-size: 1rem;
		margin: 8px 0 6px;
	}
	.meta {
		color: var(--soil-500);
		font-size: 0.78rem;
	}
	.empty-card {
		padding: 24px;
	}
	.empty-card a {
		color: var(--clay-500);
		font-weight: 700;
	}
</style>
