<script>
  export let question;

  $: excerpt =
    question.description?.length > 130
      ? question.description.slice(0, 130).trimEnd() + '…'
      : question.description;

  $: authorName = question.profiles?.display_name || question.profiles?.email || 'Pengguna';
  $: answerCount = question.answers?.[0]?.count ?? 0;
</script>

<a class="card" href={`/pertanyaan/${question.id}`}>
  <div class="thumb" class:no-image={!question.image_url}>
    {#if question.image_url}
      <img src={question.image_url} alt="" loading="lazy" />
    {:else}
      <span>🌾</span>
    {/if}
  </div>
  <div class="body">
    <h3>{question.title}</h3>
    <p>{excerpt}</p>
    <div class="meta">
      <span class="author">{authorName}</span>
      <span class="dot">•</span>
      <span>{new Date(question.created_at).toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })}</span>
      <span class="dot">•</span>
      <span>{answerCount} jawaban</span>
    </div>
  </div>
</a>

<style>
  .card {
    display: flex;
    gap: 1rem;
    align-items: flex-start;
    background: var(--surface);
    border-radius: var(--radius-card);
    padding: 1rem 1.15rem;
    text-decoration: none;
    color: inherit;
    box-shadow: var(--shadow-sm);
    transition: box-shadow 0.15s ease, transform 0.15s ease;
  }
  .card:hover {
    box-shadow: var(--shadow-md);
    transform: translateY(-2px);
  }
  .thumb {
    width: 76px;
    height: 76px;
    border-radius: 14px;
    overflow: hidden;
    flex-shrink: 0;
    background: var(--pink-light);
  }
  .thumb img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }
  .thumb.no-image {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.6rem;
  }
  .body {
    flex: 1;
    min-width: 0;
  }
  h3 {
    font-size: 1.02rem;
    margin: 0 0 0.3rem;
  }
  p {
    margin: 0 0 0.5rem;
    color: var(--ink-soft);
    font-size: 0.87rem;
  }
  .meta {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 0.35rem;
    font-size: 0.74rem;
    color: var(--muted);
  }
  .author {
    color: var(--pink-dark);
    font-weight: 600;
  }
  .dot {
    opacity: 0.6;
  }
</style>
