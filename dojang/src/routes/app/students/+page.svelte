<script lang="ts">
  import { onMount } from 'svelte';
  import feather from 'feather-icons';
  import type { Student, StudentFilters } from '$lib/types/student';
  import { studentsService } from '$lib/services/students';
  
  let students = $state<Student[]>([]);
  let filters = $state<StudentFilters>({});
  let loading = $state(true);
  let error = $state<string | null>(null);

  async function loadStudents() {
    loading = true;
    error = null;
    try {
      students = await studentsService.getStudents(filters);
    } catch (err) {
      error = err instanceof Error ? err.message : 'An error occurred';
    } finally {
      loading = false;
    }
  }

  // Watch for filter changes and reload students
  $effect(() => {
    loadStudents();
  });

  onMount(() => {
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
        bind:value={filters.search}
      />
      <select bind:value={filters.belt}>
        <option value="">All Belts</option>
        <!-- Add belt options here -->
      </select>
    </div>
  </header>

  {#if error}
    <div class="error" role="alert">{error}</div>
  {/if}

  {#if loading}
    <div class="loading" role="status" aria-live="polite">Loading students...</div>
  {:else}
    <div class="students-grid" role="grid">
      {#each students as student (student.id)}
        <div class="student-card" role="gridcell">
          <div class="student-header">
            {#if student.team_tiger}
              <span class="team-tiger-badge">
                <i data-feather="award" aria-hidden="true"></i>
                Team Tiger
              </span>
            {/if}
            <h3>{student.full_name}</h3>
          </div>
          
          <div 
            class="belt-level" 
            style="--belt-color: {student.current_belt.color}"
            aria-label="Belt level: {student.current_belt.name}"
          >
            {student.current_belt.name}
          </div>
          
          <div class="student-details">
            <span class="age">
              <i data-feather="calendar" aria-hidden="true"></i>
              {student.date_of_birth}
            </span>
            
            {#if student.last_class_attended}
              <span class="last-class">
                <i data-feather="clock" aria-hidden="true"></i>
                Last class: {student.last_class_attended}
              </span>
            {/if}
          </div>
          
          <div class="actions">
            <button 
              class="action-btn"
              aria-label="More actions for {student.full_name}"
            >
              <i data-feather="more-vertical" aria-hidden="true"></i>
            </button>
          </div>
        </div>
      {/each}
    </div>
  {/if}
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

  .students-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1.5rem;
  }

  .student-card {
    background: var(--bg-card);
    border-radius: 8px;
    padding: 1rem;
    position: relative;
  }

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

  .belt-level {
    background: var(--belt-color);
    color: white;
    padding: 0.5rem;
    border-radius: 4px;
    margin: 0.5rem 0;
  }

  .student-details {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    color: var(--text-secondary);
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