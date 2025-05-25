<script lang="ts">
  import { onMount }  from 'svelte'; // onMount for feather can remain
  import feather from 'feather-icons';
  import type { StudentFilters } from '$lib/types/student'; // Student and BeltLevel types come via `data`
  import StudentList from '$lib/components/students/StudentList.svelte';
  import { page, navigating } from '$app/stores';
  import { goto } from '$app/navigation';
  
  // Data is now passed by the `load` function in +page.ts and accessed via $props()
  let { data } = $props();

  // Local reactive state for filter inputs
  // Initialize from URL parameters via $page store for direct access or deep linking
  let searchFilter = $state($page.url.searchParams.get('search') || '');
  let beltFilter = $state($page.url.searchParams.get('belt') || undefined);

  // ID for "Team Tiger" from seed.sql
  const TEAM_TIGER_ID = 'bba70154-7033-406a-801e-d55081b8f0ad';

  // Effect to update icons when data changes and DOM updates
  $effect.pre(() => {
    if (typeof feather !== 'undefined') {
      feather.replace();
    }
  });

  // Utility functions remain in the component as they are presentation-related
  function calculateAge(dateOfBirth: string | null): string {
    if (!dateOfBirth) return 'N/A';
    const birthDate = new Date(dateOfBirth);
    const today = new Date();
    let age = today.getFullYear() - birthDate.getFullYear();
    const m = today.getMonth() - birthDate.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
      age--;
    }
    return age >= 0 ? `${age} years` : 'N/A';
  }

  function getTextColorForBackground(hexColor: string | undefined | null): string {
    if (!hexColor) return '#000000'; // Default to black for undefined/null colors
    const r = parseInt(hexColor.slice(1, 3), 16);
    const g = parseInt(hexColor.slice(3, 5), 16);
    const b = parseInt(hexColor.slice(5, 7), 16);
    const yiq = (r * 299 + g * 587 + b * 114) / 1000;
    return yiq >= 128 ? '#000000' : '#FFFFFF';
  }

  // Watch for local filter state changes and update URL to trigger `load` function
  $effect(() => {
    const newParams = new URLSearchParams();
    if (searchFilter) {
      newParams.set('search', searchFilter);
    }
    if (beltFilter) {
      newParams.set('belt', beltFilter);
    }
    
    const newQueryString = newParams.toString();
    // Only navigate if the query string has actually changed
    if (newQueryString !== $page.url.searchParams.toString()) {
      goto(`?${newQueryString}`, { 
        keepFocus: true, 
        replaceState: true, // Avoids polluting browser history with filter changes
        noScroll: true 
      });
    }
  });

  onMount(() => {
    // Initial feather replacement for any static icons
    if (typeof feather !== 'undefined') {
      feather.replace();
    }
  });
</script>

<div class="students-page">
  <header class="page-header">
    <h1>Student Directory</h1>
    <div class="filters">
      <input
        type="text"
        placeholder="Search students..."
        bind:value={searchFilter}
      />
      <select bind:value={beltFilter} aria-label="Filter by belt">
        <option value={undefined}>All Belts</option>
        {#each data.allBelts as belt (belt.id)}
          <option value={belt.id}>{belt.name}</option>
        {/each}
      </select>
    </div>
  </header>

  <StudentList
    students={data.students}
    loading={!!$navigating}
    error={data.error}
    {TEAM_TIGER_ID}
    {calculateAge}
    {getTextColorForBackground}
  />

</div>

<style>
  .students-page {
    padding: 1rem;
  }

  .page-header {
    margin-bottom: 2rem;
  }

  .filters {
    display: flex;
    gap: 1rem;
    margin-top: 1rem;
  }

  /* Styles for .error and .loading can remain here if they are page-level */

  .team-tiger-badge {
    background: var(--accent-red);
    color: white;
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-size: 0.875rem;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
  }

  .student-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.5rem;
  }

  .belt-level {
    padding: 0.5rem;
    border-radius: 4px;
    margin: 0.5rem 0;
    text-align: center;
    font-weight: bold;
    border: 1px solid rgba(0,0,0,0.1); /* Subtle border for light belts */
  }
  .belt-level-none {
    background-color: var(--bg-subtle, #f0f0f0);
    color: var(--text-secondary, #555);
  }

  .student-details {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    color: var(--text-secondary);
    font-size: 0.875rem;
  }

  .student-details span {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
  }

  .actions {
    position: absolute;
    top: 1rem;
    right: 1rem;
  }

  .action-btn {
    background: none;
    border: none;
    cursor: pointer;
    color: var(--text-secondary);
  }
</style>