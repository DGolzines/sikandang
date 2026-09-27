<script>
	import '../app.css';
	import { onMount } from 'svelte';
	import { invalidate } from '$app/navigation';
	import { page } from '$app/stores';
	import { categories } from '$lib/categories.js';

	export let data;

	$: ({ supabase, session, user } = data);

	onMount(() => {
		const { data: authListener } = supabase.auth.onAuthStateChange((_event, newSession) => {
			if (newSession?.expires_at !== session?.expires_at) {
				invalidate('supabase:auth');
			}
		});
		return () => authListener.subscription.unsubscribe();
	});

	let menuOpen = false;
</script>

<div class="site">
	<header class="topbar">
		<div class="wrap topbar-inner">
			<a class="brand" href="/">
				<span class="brand-badge">🐄</span>
				<span class="brand-text">
					<strong>SIKANDANG</strong>
					<small>Edukasi Digital Peternak Lokal</small>
				</span>
			</a>

			<button class="burger" on:click={() => (menuOpen = !menuOpen)} aria-label="Buka menu">
				☰
			</button>

			<nav class="nav" class:open={menuOpen}>
				<a href="/" class:active={$page.url.pathname === '/'}>Beranda</a>
				<div class="nav-dropdown">
					<span>Forum</span>
					<div class="dropdown-panel">
						{#each categories as c}
							<a href="/forum/{c.slug}">{c.icon} {c.title}</a>
						{/each}
					</div>
				</div>

				{#if user}
					<a href="/akun" class="user-chip">👤 {user.email?.split('@')[0]}</a>
					<form method="POST" action="/logout">
						<button class="btn btn-ghost nav-btn" type="submit">Keluar</button>
					</form>
				{:else}
					<a href="/login" class="btn btn-ghost nav-btn">Masuk</a>
					<a href="/register" class="btn btn-primary nav-btn">Daftar</a>
				{/if}
			</nav>
		</div>
	</header>

	<main>
		<slot />
	</main>

	<footer class="footer">
		<div class="wrap footer-inner">
			<div>
				<div class="brand footer-brand">
					<span class="brand-badge">🐄</span>
					<strong>SIKANDANG</strong>
				</div>
				<p>
					Sistem Informasi Manajemen Kesehatan Kandang Berbasis Edukasi Digital Peternak Lokal —
					forum tanya jawab &amp; pusat edukasi untuk peternak Indonesia.
				</p>
			</div>
			<div>
				<h4>Forum</h4>
				<ul>
					{#each categories as c}
						<li><a href="/forum/{c.slug}">{c.title}</a></li>
					{/each}
				</ul>
			</div>
		</div>
		<div class="wrap footer-bottom">© {new Date().getFullYear()} SIKANDANG. Dibuat untuk peternak lokal.</div>
	</footer>
</div>

<style>
	.site {
		min-height: 100vh;
		display: flex;
		flex-direction: column;
	}

	main {
		flex: 1;
	}

	.topbar {
		background: var(--soil-800);
		border-bottom: 4px solid var(--clay-500);
		position: sticky;
		top: 0;
		z-index: 40;
	}

	.topbar-inner {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding-top: 12px;
		padding-bottom: 12px;
		gap: 16px;
	}

	.brand {
		display: flex;
		align-items: center;
		gap: 10px;
		text-decoration: none;
		color: var(--cream-ink);
	}

	.brand-badge {
		font-size: 1.6rem;
		background: var(--clay-500);
		border-radius: 50%;
		width: 42px;
		height: 42px;
		display: grid;
		place-items: center;
		box-shadow: inset 0 0 0 2px var(--soil-900);
	}

	.brand-text {
		display: flex;
		flex-direction: column;
		line-height: 1.2;
	}

	.brand-text strong {
		font-family: var(--font-display);
		font-size: 1.15rem;
		letter-spacing: 0.3px;
	}

	.brand-text small {
		font-size: 0.68rem;
		opacity: 0.75;
	}

	.burger {
		display: none;
		background: none;
		border: none;
		color: var(--cream-ink);
		font-size: 1.4rem;
		cursor: pointer;
	}

	.nav {
		display: flex;
		align-items: center;
		gap: 22px;
	}

	.nav > a {
		color: var(--wheat-200);
		text-decoration: none;
		font-weight: 600;
		font-size: 0.95rem;
	}

	.nav > a.active,
	.nav > a:hover {
		color: #fff;
		text-decoration: underline;
		text-decoration-color: var(--clay-400);
		text-underline-offset: 6px;
	}

	.nav-dropdown {
		position: relative;
		color: var(--wheat-200);
		font-weight: 600;
		font-size: 0.95rem;
		cursor: default;
	}

	.dropdown-panel {
		display: none;
		position: absolute;
		top: 100%;
		left: -20px;
		background: var(--wheat-50);
		border: 2px solid var(--soil-900);
		border-radius: 4px 16px 4px 16px;
		box-shadow: var(--shadow-stamp);
		padding: 10px;
		min-width: 280px;
		flex-direction: column;
		gap: 4px;
	}

	.nav-dropdown:hover .dropdown-panel {
		display: flex;
	}

	.dropdown-panel a {
		color: var(--soil-800);
		text-decoration: none;
		padding: 8px 10px;
		border-radius: 8px;
		font-size: 0.88rem;
		font-weight: 500;
	}

	.dropdown-panel a:hover {
		background: var(--wheat-200);
	}

	.user-chip {
		text-decoration: none;
		background: var(--soil-700);
		color: var(--cream-ink);
		padding: 8px 14px;
		border-radius: 999px;
		font-size: 0.85rem;
		font-weight: 600;
	}

	.nav-btn {
		padding: 8px 18px;
		font-size: 0.85rem;
	}

	:global(.nav-ghost-on-dark) {
		color: var(--cream-ink);
		border-color: var(--cream-ink);
	}

	.footer {
		background: var(--soil-900);
		color: var(--wheat-200);
		margin-top: 60px;
	}

	.footer-inner {
		display: grid;
		grid-template-columns: 2fr 1fr;
		gap: 32px;
		padding-top: 44px;
		padding-bottom: 24px;
	}

	.footer-brand {
		color: var(--cream-ink);
		margin-bottom: 12px;
	}

	.footer p {
		font-size: 0.9rem;
		opacity: 0.8;
		max-width: 46ch;
	}

	.footer h4 {
		color: var(--wheat-100);
		font-size: 0.95rem;
	}

	.footer ul {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.footer a {
		color: var(--wheat-200);
		text-decoration: none;
		font-size: 0.88rem;
		opacity: 0.85;
	}

	.footer a:hover {
		opacity: 1;
		text-decoration: underline;
	}

	.footer-bottom {
		border-top: 1px solid rgba(255, 255, 255, 0.12);
		padding: 16px 24px;
		font-size: 0.78rem;
		opacity: 0.6;
	}

	@media (max-width: 860px) {
		.burger {
			display: block;
		}
		.nav {
			position: absolute;
			top: 100%;
			left: 0;
			right: 0;
			background: var(--soil-800);
			flex-direction: column;
			align-items: flex-start;
			padding: 16px 24px 24px;
			display: none;
			gap: 14px;
		}
		.nav.open {
			display: flex;
		}
		.dropdown-panel {
			position: static;
			display: flex;
			border: none;
			box-shadow: none;
			background: transparent;
			padding: 6px 0 0 12px;
		}
		.nav-dropdown:hover .dropdown-panel {
			display: flex;
		}
		.footer-inner {
			grid-template-columns: 1fr;
		}
	}
</style>
