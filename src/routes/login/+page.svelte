<script>
	import { enhance } from '$app/forms';
	export let form;
	let loading = false;
</script>

<svelte:head><title>Masuk — SIKANDANG</title></svelte:head>

<section class="auth-wrap">
	<div class="auth-card notice-card">
		<span class="pin" aria-hidden="true"></span>
		<h1>Masuk ke SIKANDANG</h1>
		<p class="sub">Lanjutkan diskusi dan konsultasi kesehatan kandang Anda.</p>

		{#if form?.error}
			<div class="alert alert-error">{form.error}</div>
		{/if}

		<form
			method="POST"
			use:enhance={() => {
				loading = true;
				return async ({ update }) => {
					await update();
					loading = false;
				};
			}}
		>
			<div class="field">
				<label for="email">Email</label>
				<input id="email" name="email" type="email" required value={form?.email ?? ''} placeholder="nama@email.com" />
			</div>
			<div class="field">
				<label for="password">Kata Sandi</label>
				<input id="password" name="password" type="password" required placeholder="••••••••" />
			</div>
			<button class="btn btn-primary" type="submit" disabled={loading} style="width:100%; justify-content:center;">
				{loading ? 'Memproses…' : 'Masuk'}
			</button>
		</form>

		<p class="switch">Belum punya akun? <a href="/register">Daftar di sini</a></p>
	</div>
</section>

<style>
	.auth-wrap {
		min-height: calc(100vh - 180px);
		display: grid;
		place-items: center;
		padding: 48px 24px;
		background: radial-gradient(circle at 20% 20%, rgba(85, 112, 63, 0.1), transparent 40%);
	}
	.auth-card {
		width: 100%;
		max-width: 420px;
		padding: 40px 32px;
	}
	.sub {
		color: var(--soil-600);
		font-size: 0.92rem;
	}
	.switch {
		margin-top: 18px;
		font-size: 0.9rem;
		text-align: center;
	}
	.switch a {
		color: var(--clay-500);
		font-weight: 700;
		text-decoration: none;
	}
</style>
