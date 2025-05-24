<script>
  export let items = [];
</script>

<div class="store-grid">
  {#each items as item}
    <a href="/store/{item.id}">
      <img src={item.image} alt={item.name} />
      <p>{item.name}</p>
      <p>${item.price}</p>
    </a>
  {/each}
</div>
