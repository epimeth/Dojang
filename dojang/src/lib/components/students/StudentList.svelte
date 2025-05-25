<script lang="ts">
  import type { Student, BeltLevel } from '$lib/types/student';

  // Props that will be passed from +page.svelte
  export let students: Student[] = [];
  export let loading: boolean = true;
  export let error: string | null = null;
  export let TEAM_TIGER_ID: string;
  export let calculateAge: (dateOfBirth: string | null) => string;
  export let getTextColorForBackground: (hexColor: string | undefined | null) => string;

  // Feather icons will be handled by the parent page's $effect
</script>

{#if error}
  <div class="error" role="alert">{error}</div>
{/if}

{#if loading}
  <div class="loading" role="status" aria-live="polite">Loading students...</div>
{:else if students.length === 0 && !error}
  <div class="no-students" role="status">
    <p>No students found matching your criteria.</p>
  </div>
{:else if students.length > 0}
  <div class="students-grid" role="grid">
    {#each students as student (student.id)}
      <div class="student-card" role="gridcell">
        <div class="student-header">
          <h3>{student.full_name}</h3>
          {#if student.teams?.some(team => team.id === TEAM_TIGER_ID)}
            <span class="team-tiger-badge">
              <i data-feather="award" aria-hidden="true"></i>
              Team Tiger
            </span>
          {/if}
        </div>
        
        {#if student.current_belt}
          <div 
            class="belt-level" 
            style:background-color={student.current_belt.color}
            style:color={getTextColorForBackground(student.current_belt.color)}
            aria-label="Belt level: {student.current_belt.name}"
          >
            {student.current_belt.name}
          </div>
        {:else}
          <div class="belt-level belt-level-none" aria-label="No current belt">
            N/A
          </div>
        {/if}
        
        <div class="student-details">
          <span class="age">
            <i data-feather="calendar" aria-hidden="true"></i>
            {calculateAge(student.date_of_birth)}
          </span>
          
          {#if student.last_class_attended}
            <!-- This property is in the Student type but not currently populated by the API -->
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

<style>
  /* Styles specific to the student list and cards can remain here or be global */
  /* For brevity, I'm assuming these styles are largely the same as in +page.svelte */
  /* You might want to move relevant styles from +page.svelte here */
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
    /* ... other student-card styles ... */
  }
  
  .no-students {
    text-align: center;
    padding: 2rem;
    color: var(--text-secondary);
  }
  /* ... include other necessary styles from the original page ... */
</style>