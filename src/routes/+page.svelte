<script>
  import { onMount } from 'svelte';
  import { supabase } from '$lib/supabaseClient';
  import CategoryCard from '$lib/components/CategoryCard.svelte';
  import QuestionCard from '$lib/components/QuestionCard.svelte';
  import SidebarQuestionMini from '$lib/components/SidebarQuestionMini.svelte';
  import StatPill from '$lib/components/StatPill.svelte';
  import CategoryIcon from '$lib/components/CategoryIcon.svelte';
  import { categoryColor } from '$lib/categoryColors';

  let categories = [];
  let latestQuestions = [];
  let pictureQuestions = [];
  let stats = { totalQuestions: 0, totalAnswers: 0, weekQuestions: 0 };
  let loading = true;
  let error = '';

  async function loadCategories() {
    const { data } = await supabase.from('categories').select('*').order('sort_order');
    categories = data ?? [];
  }

  async function loadLatestQuestions() {
    const { data, error: err } = await supabase
      .from('questions')
      .select(
        'id, title, description, image_url, created_at, category_id, categories(name, slug, icon_key), profiles(display_name, email), answers(count)'
      )
      .order('created_at', { ascending: false })
      .limit(8);
    if (err) {
      error = err.message;
    } else {
      latestQuestions = data ?? [];
    }
  }

  async function loadPictureQuestions() {
    const { data } = await supabase
      .from('questions')
      .select('id, title, image_url, categories(name, slug)')
      .order('created_at', { ascending: false })
      .limit(5);
    pictureQuestions = data ?? [];
  }

  async function loadStats() {
    const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
    const [qRes, aRes, wRes] = await Promise.all([
      supabase.from('questions').select('*', { count: 'exact', head: true }),
      supabase.from('answers').select('*', { count: 'exact', head: true }),
      supabase.from('questions').select('*', { count: 'exact', head: true }).gte('created_at', sevenDaysAgo)
    ]);
    stats = {
      totalQuestions: qRes.count ?? 0,
      totalAnswers: aRes.count ?? 0,
      weekQuestions: wRes.count ?? 0
    };
  }

  onMount(async () => {
    loading = true;
    await Promise.all([loadCategories(), loadLatestQuestions(), loadPictureQuestions(), loadStats()]);
    loading = false;
  });
</script>

<section class="hero">
  <div class="hero-top">
    <p class="eyebrow">tani sadar lingkungan dan biaya</p>
    <h1>Tanya jawab &amp; panduan praktis seputar pertanian hemat &amp; ramah lingkungan.</h1>
    <p class="lead">
      Ajukan pertanyaan, baca panduan tiap topik, dan saling bantu sesama petani menekan
      biaya sekaligus menjaga lingkungan.
    </p>
    <a class="cta" href="/pertanyaan/baru">Ajukan pertanyaan pertama</a>
  </div>
  <div class="hero-stats">
    <StatPill label="pertanyaan" value={stats.totalQuestions} />
    <StatPill label="jawaban" value={stats.totalAnswers} />
    <StatPill label="minggu ini" value={stats.weekQuestions} />
    <StatPill label="topik" value={categories.length} />
  </div>
</section>

<section class="categories-section">
  <h2>5 Topik Utama</h2>
  <p class="section-lead">Tiap topik punya panduan singkat sekaligus forum tanya jawabnya sendiri.</p>
  <div class="cat-grid">
    {#each categories as cat (cat.id)}
      <CategoryCard category={cat} />
    {/each}
  </div>
</section>

<div class="layout">
  <div class="main-col">
    <h2>Pertanyaan Terbaru</h2>
    {#if error}
      <p class="error">Gagal memuat: {error}</p>
    {/if}
    {#if loading}
      <p class="hint">Memuat…</p>
    {:else if latestQuestions.length === 0}
      <div class="empty">
        <p>Belum ada pertanyaan. Jadilah yang pertama bertanya!</p>
        <a class="cta-outline" href="/pertanyaan/baru">Ajukan pertanyaan</a>
      </div>
    {:else}
      <div class="q-list">
        {#each latestQuestions as q (q.id)}
          <QuestionCard question={q} />
        {/each}
      </div>
    {/if}
  </div>

  <aside class="sidebar">
    <div class="panel">
      <h3>Jelajahi Topik</h3>
      <ul class="cat-nav">
        {#each categories as cat (cat.id)}
          <li>
            <a href={`/kategori/${cat.slug}`} style={`--accent: ${categoryColor(cat.slug)}`}>
              <span class="mini-icon"><CategoryIcon type={cat.icon_key} size={16} /></span>
              {cat.name}
            </a>
          </li>
        {/each}
      </ul>
    </div>

    <div class="panel">
      <h3>Pertanyaan Bergambar</h3>
      <div class="pic-list">
        {#each pictureQuestions as q (q.id)}
          <SidebarQuestionMini question={q} />
        {:else}
          <p class="hint small">Belum ada pertanyaan.</p>
        {/each}
      </div>
    </div>

    <div class="panel cta-panel">
      <h3>Punya pertanyaan seputar pertanian?</h3>
      <p>Tanyakan langsung dan dapatkan masukan dari sesama petani.</p>
      <a class="cta-outline block" href="/pertanyaan/baru">+ Ajukan Pertanyaan</a>
    </div>
  </aside>
</div>

<style>
  .hero {
    background: var(--gradient-hero);
    border-radius: var(--radius-card);
    padding: 2.25rem 2rem;
    color: #fff;
    margin-bottom: 2rem;
  }
  .eyebrow {
    color: var(--pink-light);
    font-size: 0.76rem;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    margin: 0 0 0.6rem;
    font-weight: 700;
  }
  .hero h1 {
    font-size: 1.9rem;
    color: #fff;
    margin-bottom: 0.7rem;
    max-width: 34ch;
  }
  .lead {
    color: rgba(255, 255, 255, 0.85);
    font-size: 0.96rem;
    margin: 0 0 1.3rem;
    max-width: 48ch;
  }
  .cta {
    display: inline-block;
    background: #fff;
    color: var(--pink-dark);
    text-decoration: none;
    padding: 0.68rem 1.5rem;
    border-radius: var(--radius-pill);
    font-size: 0.92rem;
    font-weight: 800;
  }
  .hero-stats {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 0.6rem;
    margin-top: 1.75rem;
  }
  @media (max-width: 640px) {
    .hero-stats {
      grid-template-columns: repeat(2, 1fr);
    }
    .hero h1 {
      font-size: 1.5rem;
    }
  }

  .categories-section {
    margin-bottom: 2rem;
  }
  .categories-section h2 {
    font-size: 1.3rem;
    margin-bottom: 0.3rem;
  }
  .section-lead {
    color: var(--ink-soft);
    font-size: 0.88rem;
    margin: 0 0 1.1rem;
  }
  .cat-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1rem;
  }
  @media (max-width: 860px) {
    .cat-grid {
      grid-template-columns: repeat(2, 1fr);
    }
  }
  @media (max-width: 520px) {
    .cat-grid {
      grid-template-columns: 1fr;
    }
  }

  .layout {
    display: grid;
    grid-template-columns: 1fr 300px;
    gap: 1.75rem;
    align-items: start;
  }
  @media (max-width: 900px) {
    .layout {
      grid-template-columns: 1fr;
    }
  }
  .main-col h2 {
    font-size: 1.2rem;
    margin-bottom: 1rem;
  }
  .q-list {
    display: flex;
    flex-direction: column;
    gap: 0.8rem;
  }
  .hint {
    color: var(--muted);
  }
  .hint.small {
    font-size: 0.85rem;
  }
  .error {
    color: var(--danger);
  }
  .empty {
    text-align: center;
    padding: 2.5rem 1rem;
    background: var(--surface);
    border: 1px dashed var(--line);
    border-radius: var(--radius-card);
  }
  .empty p {
    color: var(--ink-soft);
    margin-bottom: 0.9rem;
  }
  .cta-outline {
    display: inline-block;
    background: var(--pink);
    color: #fff;
    text-decoration: none;
    padding: 0.6rem 1.3rem;
    border-radius: var(--radius-control);
    font-size: 0.9rem;
    font-weight: 700;
  }
  .cta-outline.block {
    display: block;
    text-align: center;
  }

  .sidebar {
    display: flex;
    flex-direction: column;
    gap: 1.1rem;
  }
  .panel {
    background: var(--surface);
    border-radius: var(--radius-card);
    padding: 1.25rem;
    box-shadow: var(--shadow-sm);
  }
  .panel h3 {
    font-size: 0.95rem;
    margin-bottom: 0.9rem;
  }
  .cat-nav {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }
  .cat-nav a {
    display: flex;
    align-items: center;
    gap: 0.55rem;
    padding: 0.5rem 0.6rem;
    border-radius: var(--radius-control);
    text-decoration: none;
    color: var(--ink-soft);
    font-size: 0.86rem;
    font-weight: 600;
  }
  .cat-nav a:hover {
    background: var(--pink-light);
    color: var(--accent);
  }
  .mini-icon {
    width: 28px;
    height: 28px;
    border-radius: 8px;
    background: var(--accent);
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }
  .pic-list {
    display: flex;
    flex-direction: column;
    gap: 0.15rem;
  }
  .cta-panel {
    background: var(--pink-light);
  }
  .cta-panel p {
    font-size: 0.85rem;
    color: var(--ink-soft);
    margin: 0 0 1rem;
  }
</style>
