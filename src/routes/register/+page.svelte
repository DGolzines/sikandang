<script>
	import { enhance } from '$app/forms';
	export let form;
	let loading = false;
</script>

<svelte:head><title>Daftar — SIKANDANG</title></svelte:head>

<section class="auth-wrap">
	<div class="auth-card notice-card">
		<span class="pin" aria-hidden="true"></span>
		<h1>Gabung SIKANDANG</h1>
		<p class="sub">Buat akun untuk bertanya, menjawab, dan berbagi pengalaman beternak.</p>

		{#if form?.error}
			<div class="alert alert-error">{form.error}</div>
		{/if}
		{#if form?.success}
			<div class="alert alert-success">{form.message}</div>
		{/if}

		{#if !form?.success}
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
					<label for="username">Nama Panggilan</label>
					<input id="username" name="username" type="text" required value={form?.username ?? ''} placeholder="Pak Budi" />
				</div>
				<div class="field">
					<label for="email">Email</label>
					<input id="email" name="email" type="email" required value={form?.email ?? ''} placeholder="nama@email.com" />
				</div>
				<div class="field">
					<label for="password">Kata Sandi</label>
					<input id="password" name="password" type="password" required minlength="6" placeholder="Minimal 6 karakter" />
				</div>
				<button class="btn btn-primary" type="submit" disabled={loading} style="width:100%; justify-content:center;">
					{loading ? 'Memproses…' : 'Daftar'}
				</button>
			</form>
		{/if}

		<p class="switch">Sudah punya akun? <a href="/login">Masuk di sini</a></p>
	</div>
</section>

<style>
	.auth-wrap {
		min-height: calc(100vh - 180px);
		display: grid;
		place-items: center;
		padding: 48px 24px;
		background: radial-gradient(circle at 80% 20%, rgba(85, 112, 63, 0.1), transparent 40%);
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
