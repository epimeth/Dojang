<script lang="ts">
  import type { BeltLevel } from '$lib/types/student';

  let {
    allBelts = [] as BeltLevel[],
    search = $bindable(''), // Make 'search' prop bindable, with a default value
    belt = $bindable(undefined as string | undefined) // Make 'belt' prop bindable
  } = $props<{
    allBelts?: BeltLevel[];
    search?: string;
    belt?: string | undefined;
  }>();

  // Now 'search' and 'belt' are directly bindable props.
</script>

<div class="filters-container">
  <input
    type="text"
    placeholder="Search students..."
    bind:value={search}
    aria-label="Search students by name"
  />
  <select bind:value={belt} aria-label="Filter by belt">
    <option value={undefined}>All Belts</option>
    {#each allBelts as b (b.id)}
      <option value={b.id}>{b.name}</option>
    {/each}
  </select>
</div>

<style>
  .filters-container {
    display: flex;
    gap: 1rem;
    align-items: center;
  }

  input[type="text"],
  select {
    padding: 0.65rem 0.75rem;
    border: 1px solid var(--border-color, #ccc);
    border-radius: 4px;
    font-size: 0.9rem;
    background-color: var(--bg-input, white);
    color: var(--text-input, #333);
  }

  input[type="text"] {
    flex-grow: 1; /* Allow search input to take more space if needed */
  }
</style>