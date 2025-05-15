<script>
  let { data } = $props()
  let { colors } = $derived(data)
</script>
<h1>Welcome to Supabase!</h1>
<ul>
  {#each colors as color}
    <li>{color.name}</li>
  {/each}
</ul>


<h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://svelte.dev/docs/kit">svelte.dev/docs/kit</a> to read the documentation</p>
