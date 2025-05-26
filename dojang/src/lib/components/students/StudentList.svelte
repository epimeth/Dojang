<script lang="ts">
  import type { Student } from '$lib/types/student';
  import StudentCard from './StudentCard.svelte';
  import StudentListItem from './StudentListItem.svelte';

  // Props
  let {
    students = [] as Student[],
    loading = true,
    error = null as string | null,
    TEAM_TIGER_ID,
    viewMode = 'list' as 'grid' | 'list', // New prop for view mode
    calculateAge,
    getTextColorForBackground,
    // New props to pass down
    getColorForLastAttended,
    formatDate,
    isLastAttendedDataExpected
  } = $props<{
    students?: Student[];
    loading?: boolean;
    error?: string | null;
    TEAM_TIGER_ID: string;
    viewMode?: 'grid' | 'list';
    calculateAge: (dateOfBirth: string | null) => string;
    getTextColorForBackground: (hexColor: string | undefined | null) => string;
    getColorForLastAttended: (lastAttended: string | null | undefined) => string;
    formatDate: (date: string | null | undefined) => string;
    isLastAttendedDataExpected?: boolean;
  }>();

  // Feather icons are handled by StudentCard.svelte and StudentListItem.svelte
</script>

{#if error}
  <div class="error" role="alert">{error}</div>
{/if}

{#if loading && !students.length} <!-- Show loading only if no students are displayed yet -->
  <div class="loading" role="status" aria-live="polite">Loading students...</div>
{:else if students.length === 0 && !error}
  <div class="no-students" role="status">
    <p>No students found matching your criteria.</p>
  </div>
{:else if students.length > 0}
  {#if viewMode === 'grid'}
    <div class="students-grid" role="grid">
      {#each students as student (student.id)}
        <StudentCard
          {student}
          {TEAM_TIGER_ID}
          {calculateAge}
          {getTextColorForBackground}
          {getColorForLastAttended}
          {formatDate}
          {isLastAttendedDataExpected}
        />
      {/each}
    </div>
  {:else if viewMode === 'list'}
    <table class="students-table" aria-label="Student List">
      <thead>
        <tr>
          <th scope="col" class="indicator-col"><span class="visually-hidden">Indicator</span></th>
          <th scope="col">Name</th>
          <th scope="col">Belt</th>
          <th scope="col">Age</th>
          <th scope="col">Last Attended</th>
          <th scope="col" class="actions-col"><span class="visually-hidden">Actions</span></th>
        </tr>
      </thead>
      <tbody>
        {#each students as student (student.id)}
          <StudentListItem 
            {student} 
            {TEAM_TIGER_ID} 
            {calculateAge} 
            {getTextColorForBackground} 
            {getColorForLastAttended} 
            {formatDate} 
            {isLastAttendedDataExpected} />
        {/each}
      </tbody>
    </table>
  {/if}
{/if}

<style>
  .students-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1.5rem;
  }

  /* Styles specific to the list container, error, loading, no-students messages */
  .error {
    color: var(--error-text, red);
    background-color: var(--error-bg, #ffebee);
    padding: 1rem;
    border-radius: 4px;
    border: 1px solid var(--error-border, red);
  }

  .loading,
  .no-students {
    text-align: center;
    padding: 2rem;
    color: var(--text-secondary);
  }
  .no-students p {
    margin: 0;
  }

  /* Table styles for list view */
  .students-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 1.5rem;
  }

  .students-table th,
  .students-table td { /* Basic styling, StudentListItem will style its own cells */
    text-align: left;
  }

  .students-table th {
    background-color: var(--bg-header-table, #f7fafc);
    font-weight: 600;
    color: var(--text-header-table, #4a5568);
    padding: 0.75rem 0.5rem; /* Padding for headers */
    border-bottom: 2px solid var(--border-color-strong, #cbd5e0); /* Stronger border for header */
  }
  .indicator-col { width: 40px; }
  .actions-col { width: 60px; text-align: right; }
  .visually-hidden { border: 0; clip: rect(0 0 0 0); height: 1px; margin: -1px; overflow: hidden; padding: 0; position: absolute; width: 1px; white-space: nowrap; }
</style>