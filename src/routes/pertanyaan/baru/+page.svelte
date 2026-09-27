<script>
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { supabase } from '$lib/supabaseClient';
  import { user, authLoading } from '$lib/stores/auth';
  import { goto } from '$app/navigation';

  let categories = [];
  let title = '';
  let description = '';
  let categoryId = '';
  let imageFile = null;
  let imagePreview = '';
  let error = '';
  let loading = false;

  onMount(async () => {
    const { data } = await supabase.from('categories').select('*').order('sort_order');
    categories = data ?? [];

    const preselectSlug = $page.url.searchParams.get('kategori');
    const preselect = preselectSlug ? categories.find((c) => c.slug === preselectSlug) : null;
    categoryId = preselect ? preselect.id : categories[0]?.id ?? '';
  });

  function handleFileChange(e) {
    const file = e.target.files?.[0] ?? null;
    imageFile = file;
    imagePreview = file ? URL.createObjectURL(file) : '';
  }

  async function handleSubmit() {
    if (!$user) {
      goto('/login');
      return;
    }
    if (!imageFile) {
      error = 'Sertakan satu foto untuk pertanyaanmu.';
      return;
    }

    loading = true;
    error = '';

    try {
      const ext = imageFile.name.split('.').pop();
      const path = `${$user.id}/${crypto.randomUUID()}.${ext}`;
      const { error: uploadErr } = await supabase.storage.from('tanisa-images').upload(path, imageFile);
      if (uploadErr) throw uploadErr;
      const { data: urlData } = supabase.storage.from('tanisa-images').getPublicUrl(path);

      const { data: inserted, error: insertErr } = await supabase
        .from('questions')
        .insert({
          title,
          description,
          category_id: categoryId || null,
          image_url: urlData.publicUrl,
          image_path: path,
          user_id: $user.id
        })
        .select()
        .single();

      if (insertErr) throw insertErr;

      goto(`/pertanyaan/${inserted.id}`);
    } catch (e) {
      error = e.message ?? 'Terjadi kesalahan, coba lagi.';
    } finally {
      loading = false;
    }
  }
</script>

<h1>Ajukan pertanyaan baru</h1>
<p class="lead">Ceritakan masalah atau hal yang ingin kamu tanyakan seputar pertanian.</p>

{#if !$authLoading && !$user}
  <p class="hint">Silakan <a href="/login">masuk</a> terlebih dahulu untuk bertanya.</p>
{:else if $user}
  <form on:submit|preventDefault={handleSubmit}>
    <label>
      Judul
      <input type="text" bind:value={title} maxlength="150" placeholder="Contoh: Kenapa tanah di kebun saya cepat kering?" required />
    </label>

    <label>
      Topik
      <select bind:value={categoryId} required>
        {#each categories as cat (cat.id)}
          <option value={cat.id}>{cat.name}</option>
        {/each}
      </select>
    </label>

    <label>
      Deskripsi
      <textarea bind:value={description} rows="7" placeholder="Jelaskan kondisi, sudah berapa lama, dan apa yang sudah dicoba…" required></textarea>
    </label>

    <label class="file-field">
      Foto
      <div class="file-drop">
        <input type="file" accept="image/*" on:change={handleFileChange} required />
        {#if imagePreview}
          <img class="preview" src={imagePreview} alt="Pratinjau foto" />
        {:else}
          <span class="file-drop-hint">Klik untuk pilih foto — wajib disertakan</span>
        {/if}
      </div>
    </label>

    {#if error}<p class="error">{error}</p>{/if}

    <button type="submit" disabled={loading}>{loading ? 'Mengirim…' : 'Kirim pertanyaan'}</button>
  </form>
{/if}

<style>
  h1 {
    font-size: 1.6rem;
    margin-bottom: 0.3rem;
  }
  .lead {
    color: var(--ink-soft);
    font-size: 0.92rem;
    margin: 0 0 1.5rem;
  }
  form {
    display: flex;
    flex-direction: column;
    gap: 1.1rem;
    max-width: 560px;
  }
  label {
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
    font-size: 0.88rem;
    color: var(--ink-soft);
  }
  input,
  select,
  textarea {
    padding: 0.65rem 0.8rem;
    border: 1px solid var(--line);
    border-radius: var(--radius-control);
    font-size: 0.95rem;
    font-family: inherit;
    background: var(--surface);
    color: var(--ink);
  }
  textarea {
    resize: vertical;
  }
  .file-drop {
    position: relative;
    border: 1.5px dashed var(--line);
    border-radius: var(--radius-card);
    padding: 1.25rem;
    text-align: center;
    background: var(--pink-light);
  }
  .file-drop input[type='file'] {
    position: absolute;
    inset: 0;
    opacity: 0;
    cursor: pointer;
    border: none;
    padding: 0;
  }
  .file-drop-hint {
    font-size: 0.85rem;
    color: var(--pink-dark);
    font-weight: 600;
  }
  .preview {
    width: 100%;
    max-width: 260px;
    aspect-ratio: 4 / 3;
    object-fit: cover;
    border-radius: var(--radius-control);
    margin: 0 auto;
    display: block;
  }
  button {
    padding: 0.7rem 1.6rem;
    background: var(--pink);
    color: #fff;
    border: none;
    border-radius: var(--radius-pill);
    cursor: pointer;
    font-size: 0.95rem;
    font-weight: 700;
    align-self: flex-start;
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
  .hint {
    color: var(--ink-soft);
  }
</style>
