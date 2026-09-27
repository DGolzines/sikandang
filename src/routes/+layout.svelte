<script>
  import { onMount } from 'svelte';
  import '../app.css';
  import { supabase } from '$lib/supabaseClient';
  import { user, authLoading } from '$lib/stores/auth';
  import { goto } from '$app/navigation';

  onMount(() => {
    supabase.auth.getSession().then(({ data }) => {
      $user = data.session?.user ?? null;
      $authLoading = false;
    });

    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      $user = session?.user ?? null;
    });

    return () => listener.subscription.unsubscribe();
  });

  async function handleLogout() {
    await supabase.auth.signOut();
    $user = null;
    goto('/');
  }
</script>

<div class="shell">
  <header class="topbar">
    <a class="brand" href="/">
      <span class="mark">🌸</span>
      <span class="brand-text">
        TANISA
        <span class="tagline">Tani Sadar Lingkungan dan Biaya</span>
      </span>
    </a>
    <nav>
      {#if !$authLoading}
        {#if $user}
          <a class="solid" href="/pertanyaan/baru">+ Ajukan Pertanyaan</a>
          <span class="who">{$user.email}</span>
          <button class="ghost" on:click={handleLogout}>Keluar</button>
        {:else}
          <a class="ghost" href="/login">Masuk</a>
          <a class="solid" href="/register">Daftar</a>
        {/if}
      {/if}
    </nav>
  </header>

  <main>
    <slot />
  </main>

  <footer>
    <p>TANISA — ruang tanya jawab &amp; informasi untuk petani yang sadar lingkungan dan biaya.</p>
  </footer>
</div>

<style>
  .shell {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }
  .topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.9rem 1.75rem;
    background: var(--surface);
    border-bottom: 1px solid var(--line);
    flex-wrap: wrap;
    gap: 0.75rem;
    position: sticky;
    top: 0;
    z-index: 10;
  }
  .brand {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    text-decoration: none;
    color: var(--ink);
  }
  .mark {
    font-size: 1.3rem;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--gradient-hero);
    border-radius: 12px;
  }
  .brand-text {
    display: flex;
    flex-direction: column;
    font-family: var(--font-display);
    font-weight: 800;
    font-size: 1.15rem;
    line-height: 1.15;
  }
  .tagline {
    font-family: var(--font-body);
    font-weight: 500;
    font-size: 0.65rem;
    color: var(--muted);
  }
  nav {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    flex-wrap: wrap;
  }
  .who {
    color: var(--muted);
    font-size: 0.78rem;
    margin-right: 0.2rem;
  }
  .ghost,
  .solid {
    font-size: 0.85rem;
    text-decoration: none;
    padding: 0.48rem 1rem;
    border-radius: var(--radius-pill);
    cursor: pointer;
    font-family: inherit;
    font-weight: 700;
    border: 1px solid transparent;
  }
  .ghost {
    color: var(--ink-soft);
    background: transparent;
    border-color: var(--line);
  }
  .ghost:hover {
    border-color: var(--pink);
    color: var(--pink-dark);
  }
  .solid {
    background: var(--pink);
    color: #fff;
    box-shadow: var(--shadow-sm);
  }
  .solid:hover {
    background: var(--pink-dark);
  }
  main {
    flex: 1;
    max-width: 1180px;
    margin: 0 auto;
    padding: 2rem 1.25rem 3rem;
    width: 100%;
  }
  footer {
    text-align: center;
    padding: 1.25rem;
    font-size: 0.78rem;
    color: var(--muted);
    border-top: 1px solid var(--line);
  }
</style>
