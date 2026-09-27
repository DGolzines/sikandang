<script>
  import { supabase } from '$lib/supabaseClient';
  import { goto } from '$app/navigation';

  let displayName = '';
  let email = '';
  let password = '';
  let error = '';
  let info = '';
  let loading = false;

  async function handleRegister() {
    loading = true;
    error = '';
    info = '';
    const { data, error: err } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { display_name: displayName } }
    });
    loading = false;
    if (err) {
      error = err.message;
      return;
    }
    if (data.session) {
      goto('/');
    } else {
      info = 'Pendaftaran berhasil. Silakan cek email untuk verifikasi, lalu masuk.';
    }
  }
</script>

<div class="wrap">
  <div class="card">
    <h1>Gabung TANISA</h1>
    <p class="lead">Buat akun untuk mulai bertanya dan berbagi jawaban.</p>
    <form on:submit|preventDefault={handleRegister}>
      <label>
        Nama tampilan
        <input type="text" bind:value={displayName} autocomplete="name" required />
      </label>
      <label>
        Email
        <input type="email" bind:value={email} autocomplete="email" required />
      </label>
      <label>
        Kata sandi
        <input type="password" bind:value={password} minlength="6" autocomplete="new-password" required />
      </label>
      {#if error}<p class="error">{error}</p>{/if}
      {#if info}<p class="info">{info}</p>{/if}
      <button type="submit" disabled={loading}>{loading ? 'Memproses…' : 'Daftar'}</button>
    </form>
    <p class="switch">Sudah punya akun? <a href="/login">Masuk di sini</a></p>
  </div>
</div>

<style>
  .wrap {
    display: flex;
    justify-content: center;
    padding: 1.5rem 0 3rem;
  }
  .card {
    width: 100%;
    max-width: 400px;
    background: var(--surface);
    border-radius: var(--radius-card);
    padding: 2rem 1.9rem;
    box-shadow: var(--shadow-md);
    border-top: 4px solid var(--pink);
  }
  h1 {
    font-size: 1.55rem;
    margin-bottom: 0.3rem;
  }
  .lead {
    color: var(--ink-soft);
    margin-bottom: 1.5rem;
    font-size: 0.9rem;
  }
  form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }
  label {
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
    font-size: 0.86rem;
    color: var(--ink-soft);
  }
  input {
    padding: 0.65rem 0.8rem;
    border: 1px solid var(--line);
    border-radius: var(--radius-control);
    font-size: 0.95rem;
    background: var(--surface);
    color: var(--ink);
  }
  button {
    padding: 0.7rem;
    background: var(--pink);
    color: #fff;
    border: none;
    border-radius: var(--radius-pill);
    cursor: pointer;
    font-size: 0.95rem;
    font-weight: 700;
    box-shadow: var(--shadow-sm);
  }
  button:disabled {
    opacity: 0.6;
    cursor: default;
  }
  .error {
    color: var(--danger);
    font-size: 0.85rem;
    margin: 0;
  }
  .info {
    color: var(--pink-dark);
    font-size: 0.85rem;
    margin: 0;
  }
  .switch {
    margin-top: 1.25rem;
    font-size: 0.86rem;
    color: var(--ink-soft);
    text-align: center;
  }
</style>
