<script>
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { supabase } from '$lib/supabaseClient';
  import { user, authLoading } from '$lib/stores/auth';
  import { goto } from '$app/navigation';
  import AnswerItem from '$lib/components/AnswerItem.svelte';
  import { categoryColor } from '$lib/categoryColors';

  let question = null;
  let answers = [];
  let loading = true;
  let notFound = false;
  let error = '';

  let answerContent = '';
  let submittingAnswer = false;
  let answerError = '';
  let deletingQuestion = false;

  $: questionId = $page.params.id;
  $: authorName = question?.profiles?.display_name || question?.profiles?.email || 'Pengguna';
  $: isQuestionOwner = $user && question && $user.id === question.user_id;
  $: accent = question?.categories ? categoryColor(question.categories.slug) : 'var(--pink)';

  async function loadQuestion() {
    const { data, error: err } = await supabase
      .from('questions')
      .select('*, categories(name, slug), profiles(display_name, email)')
      .eq('id', questionId)
      .maybeSingle();
    if (err) {
      error = err.message;
    } else if (!data) {
      notFound = true;
    } else {
      question = data;
    }
  }

  async function loadAnswers() {
    const { data } = await supabase
      .from('answers')
      .select('*, profiles(display_name, email)')
      .eq('question_id', questionId)
      .order('created_at', { ascending: true });
    answers = data ?? [];
  }

  async function handleAnswerSubmit() {
    if (!$user) return;
    submittingAnswer = true;
    answerError = '';
    const { error: err } = await supabase.from('answers').insert({
      question_id: questionId,
      user_id: $user.id,
      content: answerContent
    });
    submittingAnswer = false;
    if (!err) {
      answerContent = '';
      await loadAnswers();
    } else {
      answerError = err.message;
    }
  }

  async function handleAnswerDelete(event) {
    const answerId = event.detail;
    await supabase.from('answers').delete().eq('id', answerId);
    await loadAnswers();
  }

  async function handleDeleteQuestion() {
    if (!isQuestionOwner) return;
    if (!confirm('Hapus pertanyaan ini beserta seluruh jawabannya? Tindakan ini tidak bisa dibatalkan.')) return;

    deletingQuestion = true;
    try {
      const { error: err } = await supabase.from('questions').delete().eq('id', questionId);
      if (err) throw err;

      if (question.image_path) {
        await supabase.storage.from('tanisa-images').remove([question.image_path]);
      }

      goto(question.categories ? `/kategori/${question.categories.slug}` : '/');
    } catch (e) {
      error = e.message ?? 'Gagal menghapus pertanyaan.';
      deletingQuestion = false;
    }
  }

  onMount(async () => {
    loading = true;
    await loadQuestion();
    if (question) await loadAnswers();
    loading = false;
  });
</script>

{#if loading}
  <p class="hint">Memuat…</p>
{:else if notFound}
  <p class="hint">Pertanyaan tidak ditemukan.</p>
{:else if error}
  <p class="error">Gagal memuat: {error}</p>
{:else if question}
  <article class="question">
    {#if question.image_url}
      <img class="cover" src={question.image_url} alt="" />
    {/if}

    <div class="q-body">
      <div class="top-row">
        {#if question.categories}
          <a class="badge" href={`/kategori/${question.categories.slug}`} style={`--accent: ${accent}`}>
            {question.categories.name}
          </a>
        {/if}
        {#if isQuestionOwner}
          <button class="delete-question" type="button" on:click={handleDeleteQuestion} disabled={deletingQuestion}>
            {deletingQuestion ? 'Menghapus…' : 'Hapus pertanyaan'}
          </button>
        {/if}
      </div>

      <h1>{question.title}</h1>

      <div class="author-row">
        <div class="avatar">{authorName.charAt(0).toUpperCase()}</div>
        <div>
          <p class="author-name">{authorName}</p>
          <p class="date">
            {new Date(question.created_at).toLocaleString('id-ID', {
              day: 'numeric',
              month: 'short',
              year: 'numeric',
              hour: '2-digit',
              minute: '2-digit'
            })}
          </p>
        </div>
      </div>

      <p class="body">{question.description}</p>
    </div>
  </article>

  <section class="answers">
    <h2>{answers.length} {answers.length === 1 ? 'Jawaban' : 'Jawaban'}</h2>

    {#each answers as a (a.id)}
      <AnswerItem answer={a} currentUserId={$user?.id ?? null} on:delete={handleAnswerDelete} />
    {:else}
      <p class="hint">Belum ada jawaban. Jadilah yang pertama menjawab.</p>
    {/each}

    {#if !$authLoading}
      {#if $user}
        <form on:submit|preventDefault={handleAnswerSubmit}>
          <textarea bind:value={answerContent} rows="4" placeholder="Tulis jawabanmu…" required></textarea>
          {#if answerError}<p class="error">{answerError}</p>{/if}
          <button type="submit" disabled={submittingAnswer}>{submittingAnswer ? 'Mengirim…' : 'Kirim jawaban'}</button>
        </form>
      {:else}
        <p class="hint">Silakan <a href="/login">masuk</a> untuk menjawab.</p>
      {/if}
    {/if}
  </section>
{/if}

<style>
  .question {
    background: var(--surface);
    border-radius: var(--radius-card);
    overflow: hidden;
    margin-bottom: 2rem;
    box-shadow: var(--shadow-sm);
  }
  .cover {
    width: 100%;
    max-height: 420px;
    object-fit: cover;
    display: block;
  }
  .q-body {
    padding: 1.5rem 1.7rem 1.7rem;
  }
  .top-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.75rem;
    margin-bottom: 1rem;
  }
  .badge {
    display: inline-flex;
    align-items: center;
    background: var(--accent, var(--pink));
    color: #fff;
    padding: 0.22rem 0.75rem;
    border-radius: var(--radius-pill);
    font-size: 0.74rem;
    font-weight: 700;
    text-decoration: none;
  }
  .delete-question {
    background: none;
    border: 1px solid var(--danger);
    color: var(--danger);
    padding: 0.35rem 0.8rem;
    border-radius: var(--radius-control);
    font-size: 0.78rem;
    cursor: pointer;
  }
  .delete-question:disabled {
    opacity: 0.6;
    cursor: default;
  }
  h1 {
    font-size: 1.7rem;
    margin-bottom: 1rem;
  }
  .author-row {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    margin-bottom: 1.25rem;
  }
  .avatar {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: var(--pink-light);
    color: var(--pink-dark);
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: var(--font-display);
    font-weight: 700;
  }
  .author-name {
    margin: 0;
    font-weight: 700;
    font-size: 0.9rem;
  }
  .date {
    margin: 0.1rem 0 0;
    font-size: 0.74rem;
    color: var(--muted);
  }
  .body {
    white-space: pre-wrap;
    color: var(--ink-soft);
    margin: 0;
    font-size: 0.98rem;
  }
  .answers h2 {
    font-size: 1.05rem;
    margin-bottom: 1rem;
  }
  form {
    display: flex;
    flex-direction: column;
    gap: 0.7rem;
    margin-top: 1.25rem;
  }
  textarea {
    padding: 0.65rem 0.75rem;
    border: 1px solid var(--line);
    border-radius: var(--radius-control);
    font-family: inherit;
    font-size: 0.95rem;
    resize: vertical;
    background: var(--surface);
    color: var(--ink);
  }
  button[type='submit'] {
    padding: 0.6rem 1.4rem;
    background: var(--pink);
    color: #fff;
    border: none;
    border-radius: var(--radius-control);
    cursor: pointer;
    font-weight: 700;
    align-self: flex-start;
  }
  button:disabled {
    opacity: 0.6;
    cursor: default;
  }
  .hint {
    color: var(--ink-soft);
  }
  .error {
    color: var(--danger);
    font-size: 0.85rem;
    margin: 0;
  }
</style>
