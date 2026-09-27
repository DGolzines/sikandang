<script>
  import CategoryIcon from './CategoryIcon.svelte';
  import { categoryColor } from '$lib/categoryColors';

  export let category;
</script>

<a class="tile" href={`/kategori/${category.slug}`} style={`--accent: ${categoryColor(category.slug)}`}>
  <div class="icon-wrap">
    <CategoryIcon type={category.icon_key} size={28} />
  </div>
  <h3>{category.name}</h3>
  <p>{category.description}</p>
  <span class="link">Lihat topik →</span>
</a>

<style>
  .tile {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    background: var(--surface);
    border-radius: var(--radius-card);
    padding: 1.5rem 1.4rem;
    text-decoration: none;
    color: inherit;
    box-shadow: var(--shadow-sm);
    border-top: 3px solid var(--accent);
    transition: transform 0.16s ease, box-shadow 0.16s ease;
  }
  .tile:hover {
    transform: translateY(-3px);
    box-shadow: var(--shadow-md);
  }
  .icon-wrap {
    width: 46px;
    height: 46px;
    border-radius: 13px;
    background: var(--accent);
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 0.3rem;
  }
  h3 {
    font-size: 1.05rem;
  }
  p {
    margin: 0;
    color: var(--ink-soft);
    font-size: 0.85rem;
    flex: 1;
  }
  .link {
    margin-top: 0.4rem;
    font-size: 0.8rem;
    font-weight: 700;
    color: var(--accent);
  }
</style>
