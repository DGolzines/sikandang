// Warna aksen per kategori (dipetakan lewat slug), semua dalam keluarga warna pink
// agar tetap konsisten dengan identitas TANISA namun tiap topik mudah dibedakan.
const COLORS = {
  'mengolah-limbah-pertanian': 'var(--cat-1)',
  'pertanian-ramah-lingkungan': 'var(--cat-2)',
  'menghemat-biaya-bertani': 'var(--cat-3)',
  'memanen-dengan-benar': 'var(--cat-4)',
  'mengecek-kondisi-tanah': 'var(--cat-5)'
};

export function categoryColor(slug) {
  return COLORS[slug] ?? 'var(--pink)';
}
