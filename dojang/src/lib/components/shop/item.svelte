<script>
  export let item = {};
</script>

<h1>{item.name}</h1>
<img src={item.image} alt={item.name} />
<p>{item.description}</p>
<p>${item.price}</p>
<button on:click={() => dispatch('add-to-cart', item)}>Add to Cart</button>
