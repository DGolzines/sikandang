<script>
  export let type = 'leaf';
  export let size = 26;
</script>

{#if type === 'recycle'}
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
    <path d="M9 3.5 6.5 8h5L9 3.5Z" />
    <path d="M6.5 8 4 12.3a2 2 0 0 0 1.73 3H8" />
    <path d="M14.2 4.8 17 9.2l-2.2 3.7" />
    <path d="M9.5 20.3H14a2 2 0 0 0 1.73-3l-1.2-2" />
    <path d="M4.6 15.3 2.3 19a2 2 0 0 0 1.73 3h2.2" />
    <path d="M16.6 20.3l2.4-1.4-2.4-1.4" />
  </svg>
{:else if type === 'leaf'}
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
    <path d="M20 4c0 9-6 16-16 16C4 11 10 4 20 4Z" />
    <path d="M8.5 19.5C11 14 13.5 10.5 19 5.5" />
  </svg>
{:else if type === 'coin'}
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
    <ellipse cx="9" cy="8" rx="6" ry="3.4" />
    <path d="M3 8v4.5C3 14.4 5.7 16 9 16s6-1.6 6-3.5V8" />
    <path d="M3 12.5V17c0 1.9 2.7 3.5 6 3.5s6-1.6 6-3.5v-4.5" />
    <path d="M15 9.3c2.9.3 5 1.7 5 3.2 0 1.9-2.7 3.5-6 3.5" />
  </svg>
{:else if type === 'basket'}
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
    <path d="M4 10h16l-1.6 9.2a2 2 0 0 1-2 1.8H7.6a2 2 0 0 1-2-1.8L4 10Z" />
    <path d="M2 10h20" />
    <path d="M8.5 10 7 4.5" />
    <path d="M15.5 10 17 4.5" />
    <path d="M12 10V4.5" />
    <path d="M9 14v4" />
    <path d="M12 14v4" />
    <path d="M15 14v4" />
  </svg>
{:else if type === 'soil'}
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
    <path d="M3 17c1.5-1.5 3-2 5-2s3.5 1.3 5 1.3 3-1.3 5-1.3 2.5.5 3 1" />
    <path d="M3 20.5c1.5-1.5 3-2 5-2s3.5 1.3 5 1.3 3-1.3 5-1.3 2.5.5 3 1" />
    <circle cx="10.5" cy="8.5" r="4.5" />
    <path d="m13.8 11.8 3.7 3.7" />
  </svg>
{/if}
