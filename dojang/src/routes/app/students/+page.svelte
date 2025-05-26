<script lang="ts">
  import { onMount }  from 'svelte'; // onMount for feather can remain
  import feather from 'feather-icons';
  import type { StudentFilters } from '$lib/types/student'; // Student and BeltLevel types come via `data`
  import StudentFiltersComponent from '$lib/components/students/StudentFilters.svelte';
  import StudentListItem from '$lib/components/students/StudentListItem.svelte';
  import StudentList from '$lib/components/students/StudentList.svelte';
  import { page, navigating } from '$app/stores';
  import { goto } from '$app/navigation';
  
  // Data is now passed by the `load` function in +page.ts and accessed via $props()
  let { data } = $props();

  // Local reactive state for filter inputs
  // Initialize from URL parameters via $page store for direct access or deep linking
  let searchFilter = $state($page.url.searchParams.get('search') || ''); // Used by StudentFilters via bindable
  let beltFilter = $state($page.url.searchParams.get('belt') || undefined); // Used by StudentFilters via bindable

  // State for view mode
  let viewMode = $state<'grid' | 'list'>('list');

  // ID for "Team Tiger" from seed.sql
  const TEAM_TIGER_ID = 'bba70154-7033-406a-801e-d55081b8f0ad';

  // Effect to update icons when data changes and DOM updates
  // This is kept for any page-level icons (e.g., if filters had icons). StudentCard handles its own.
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

  // Placeholder function for determining color based on last attended date
  function getColorForLastAttended(lastAttended: string | null | undefined): string {
    if (!lastAttended) return 'var(--text-secondary)'; // Default color for unknown
    // Example logic (you'll want to refine this based on your actual needs):
    // const date = new Date(lastAttended);
    // const today = new Date();
    // const diffDays = Math.ceil(Math.abs(today.getTime() - date.getTime()) / (1000 * 60 * 60 * 24));
    // if (diffDays <= 7) return 'var(--success-text, green)';
    // if (diffDays <= 30) return 'var(--warning-text, orange)';
    // return 'var(--error-text, red)';
    return 'var(--text-secondary)'; // Current placeholder
  }

  // Placeholder function for formatting dates
  function formatDate(dateString: string | null | undefined): string {
    if (!dateString) return 'N/A';
    try {
      return new Date(dateString).toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' });
    } catch (e) {
      return 'Invalid Date'; // Handle potential invalid date strings
    }
  }
  const isLastAttendedDataExpected = true; // Set to true if you expect this data, false otherwise
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
    // Initial feather replacement for any static icons on this page. StudentCard handles its own.
    if (typeof feather !== 'undefined') {
      feather.replace();
    }
  });
</script>

<div class="students-page">
  <header class="page-header">
    <h1>Student Directory</h1>
    <div class="header-controls">
      <StudentFiltersComponent 
        allBelts={data.allBelts} 
        bind:search={searchFilter} 
        bind:belt={beltFilter} />
    </div>
    <div class="view-switcher">
      <button
        class="view-mode-btn"
        class:active={viewMode === 'grid'}
        onclick={() => viewMode = 'grid'}
        aria-pressed={viewMode === 'grid'}
        aria-label="Switch to grid view"
      >
        <i data-feather="grid"></i> Grid
      </button>
      <button
        class="view-mode-btn"
        class:active={viewMode === 'list'}
        onclick={() => viewMode = 'list'}
        aria-pressed={viewMode === 'list'}
        aria-label="Switch to list view"
      >
        <i data-feather="list"></i> List
      </button>
    </div>
  </header>

  <StudentList
    students={data.students}
    loading={!!$navigating}
    error={data.error}
    {TEAM_TIGER_ID}
    {viewMode}
    {calculateAge}
    {getTextColorForBackground}
    {getColorForLastAttended}
    {formatDate}
    {isLastAttendedDataExpected}
  />

</div>

<style>
  .students-page {
    padding: 1rem;
  }

  .page-header {
    margin-bottom: 2rem;
  }

  .header-controls {
    display: flex;
    justify-content: space-between; /* Pushes filters and view switcher apart if they are siblings */
    align-items: center;
    margin-top: 1rem;
    flex-wrap: wrap; /* Allow wrapping on smaller screens */
    gap: 1rem; /* Gap between filter group and view switcher group */
  }

  .view-switcher {
    display: flex;
    gap: 0.5rem;
    margin-top: 1rem;
    /* margin-left: auto; */ /* If page-header is flex */
  }

  .view-mode-btn {
    padding: 0.5rem 1rem;
    border: 1px solid var(--border-color, #ccc);
    background-color: var(--bg-secondary);
    color: var(--text-secondary);
    cursor: pointer;
    border-radius: 4px;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
  }
  .view-mode-btn.active {
    background-color: var(--primary-color);
    color: white;
    border-color: var(--primary-color);
  }
  .view-mode-btn:hover:not(.active) {
    background-color: var(--bg-hover);
  }

</style>