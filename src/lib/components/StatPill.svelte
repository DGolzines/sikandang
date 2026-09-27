<script>
  export let label;
  export let value;
</script>

<div class="pill">
  <p class="value">{value}</p>
  <p class="label">{label}</p>
</div>

<style>
  .pill {
    background: rgba(255, 255, 255, 0.16);
    border-radius: var(--radius-control);
    padding: 0.75rem 1rem;
    text-align: center;
  }
  .value {
    margin: 0;
    font-family: var(--font-display);
    font-weight: 800;
    font-size: 1.3rem;
    color: #fff;
  }
  .label {
    margin: 0.1rem 0 0;
    font-size: 0.7rem;
    color: rgba(255, 255, 255, 0.8);
  }
</style>
