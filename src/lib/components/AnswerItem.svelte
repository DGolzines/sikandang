<script>
  import { createEventDispatcher } from 'svelte';

  export let answer;
  export let currentUserId = null;

  const dispatch = createEventDispatcher();

  $: authorName = answer.profiles?.display_name || answer.profiles?.email || 'Pengguna';
  $: isOwner = currentUserId && currentUserId === answer.user_id;

  function requestDelete() {
    if (confirm('Hapus jawaban ini?')) {
      dispatch('delete', answer.id);
    }
  }
</script>

<div class="answer">
  <div class="avatar">{authorName.charAt(0).toUpperCase()}</div>
  <div class="content-wrap">
    <div class="head">
      <span class="author">{authorName}</span>
      <span class="dot">•</span>
      <span class="date">{new Date(answer.created_at).toLocaleString('id-ID', { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' })}</span>
      {#if isOwner}
        <button class="delete" type="button" on:click={requestDelete}>Hapus</button>
      {/if}
    </div>
    <p class="content">{answer.content}</p>
  </div>
</div>

<style>
  .answer {
    display: flex;
    gap: 0.75rem;
    background: var(--surface);
    border-radius: var(--radius-control);
    padding: 0.9rem 1rem;
    margin-bottom: 0.65rem;
    box-shadow: var(--shadow-sm);
  }
  .avatar {
    flex-shrink: 0;
    width: 34px;
    height: 34px;
    border-radius: 50%;
    background: var(--pink-light);
    color: var(--pink-dark);
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: var(--font-display);
    font-weight: 700;
    font-size: 0.9rem;
  }
  .content-wrap {
    flex: 1;
    min-width: 0;
  }
  .head {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 0.4rem;
    font-size: 0.75rem;
    color: var(--muted);
    margin-bottom: 0.35rem;
  }
  .author {
    color: var(--pink-dark);
    font-weight: 700;
  }
  .dot {
    opacity: 0.6;
  }
  .content {
    margin: 0;
    white-space: pre-wrap;
    font-size: 0.92rem;
  }
  .delete {
    margin-left: auto;
    background: none;
    border: none;
    color: var(--danger);
    font-size: 0.72rem;
    cursor: pointer;
    padding: 0;
    text-decoration: underline;
  }
</style>
