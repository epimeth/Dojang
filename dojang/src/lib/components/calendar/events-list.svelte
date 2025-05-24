<script>
  export let events = [];
  // ... filtering/sorting logic ...
</script>

<ul>
  {#each events as event}
    <li>{event.title} - {event.date}</li>
  {/each}
</ul>
