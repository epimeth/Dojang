<script>
  import { cart } from '$lib/stores/cart';
  // ... logic to update cart quantities ...
</script>

<ul>
  {#each $cart as item}
    <li>
      {item.name} - {item.quantity} x ${item.price}
      <button on:click={() => removeFromCart(item.id)}>Remove</button>
    </li>
  {/each}
</ul>
<p>Total: ${calculateTotal($cart)}</p>
