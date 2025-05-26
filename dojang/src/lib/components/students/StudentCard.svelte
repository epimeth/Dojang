<script lang="ts">
  import type { Student } from '$lib/types/student';
  import { onMount } from 'svelte';
  import feather from 'feather-icons';

  // Props
  let {
    student,
    TEAM_TIGER_ID,
    calculateAge,
    getTextColorForBackground,
    getColorForLastAttended,
    formatDate,
    isLastAttendedDataExpected = true // Default if not provided
  } = $props<{
    student: Student;
    TEAM_TIGER_ID: string;
    calculateAge: (dateOfBirth: string | null) => string;
    getTextColorForBackground: (hexColor: string | undefined | null) => string;
    getColorForLastAttended: (lastAttended: string | null | undefined) => string;
    formatDate: (date: string | null | undefined) => string;
    isLastAttendedDataExpected?: boolean;
  }>();

  $effect.pre(() => {
    // Ensure feather.replace runs after DOM updates if students data changes
    if (typeof feather !== 'undefined') {
      feather.replace();
    }
  });

  onMount(() => {
    if (typeof feather !== 'undefined') {
      feather.replace();
    }
  });
</script>

<article class="student-card" aria-labelledby="student-name-{student.id}">
  <header class="student-card__header">
    <h3 id="student-name-{student.id}" class="student-card__name">
      <a href="/app/students/{student.id}" class="student-card__name-link" aria-label="View profile for {student.full_name}">{student.full_name}</a>
    </h3>
    {#if student.teams?.some(team => team.id === TEAM_TIGER_ID)}
      <span class="student-card__badge student-card__badge--team-tiger" title="Team Tiger Member">
        <i data-feather="award" aria-hidden="true"></i>
        <span class="visually-hidden">Team Tiger</span>
      </span>
    {/if}
  </header>

  <section class="student-card__belt-info" aria-label="Belt Information">
    {#if student.current_belt}
      <div
        class="belt-display"
        style:background-color={student.current_belt.color}
        style:color={getTextColorForBackground(student.current_belt.color)}
        aria-label="Current Belt: {student.current_belt.name}"
      >
        <!-- UX Doc: "SVG-based belt level display". This div is a placeholder. -->
        {student.current_belt.name}
      </div>
    {:else}
      <div class="belt-display belt-display--none" aria-label="No current belt">
        N/A
      </div>
    {/if}
  </section>

  <section class="student-card__details" aria-label="Student Details">
    <p class="student-card__detail student-card__detail--age">
      <i data-feather="gift" aria-hidden="true"></i> <!-- UX Doc: "animated cake icon" - gift is a placeholder -->
      <span>{calculateAge(student.date_of_birth)}</span>
      <!-- Future: Add birthday countdown / animated cake logic here -->
    </p>

    {#if student.last_class_attended} <!-- Assuming API will provide this -->
      <p class="student-card__detail student-card__detail--last-attended" style="color: {getColorForLastAttended(student.last_class_attended)};">
        <i data-feather="clock" aria-hidden="true"></i>
        <span>Last attended: {formatDate(student.last_class_attended)}</span>
      </p>
    {:else if isLastAttendedDataExpected} <!-- Conditional rendering if data is expected but not present -->
       <p class="student-card__detail student-card__detail--last-attended student-card__detail--unknown">
        <i data-feather="clock" aria-hidden="true"></i>
        <span>Last attended: Unknown</span>
      </p>
    {/if}

    <!-- UX Doc: "Additional Info/Badges (e.g., tags, attendance rate)" -->
    {#if student.tags && student.tags.length > 0} <!-- Example for tags -->
      <div class="student-card__additional-badges">
        {#each student.tags as tag}
          <span class="student-card__badge student-card__badge--tag">{tag.name}</span>
        {/each}
      </div>
    {/if}
    <!-- Further badges like attendance rate would go here -->
  </section>

  <footer class="student-card__actions">
    <!-- UX Doc: "Actions" dropdown -->
    <button
      class="action-button"
      aria-label="More actions for {student.full_name}"
      aria-haspopup="true"
      aria-expanded="false"
    >
      <i data-feather="more-vertical" aria-hidden="true"></i>
      <span class="visually-hidden">Actions</span>
    </button>
  </footer>
</article>

<style>
  .student-card {
    background: var(--bg-card);
    border-radius: 8px;
    padding: 1rem;
    position: relative;
    box-shadow: var(--shadow-elevation-low);
    transition: box-shadow 0.2s ease-in-out;
    display: flex;
    flex-direction: column;
    gap: 0.75rem; /* Spacing between sections */
  }

  .student-card:hover {
    box-shadow: var(--shadow-elevation-medium);
  }

  .student-card__header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .student-card__name {
    margin: 0;
    font-size: 1.25rem;
    font-weight: 600;
  }

  .student-card__name-link {
    color: var(--text-primary);
    text-decoration: none;
  }
  .student-card__name-link:hover {
    text-decoration: underline;
  }

  .student-card__badge {
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-size: 0.75rem;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
  }

  .student-card__badge--team-tiger {
    background-color: var(--accent-red, #e53e3e);
    color: white;
  }
  
  .student-card__badge--tag {
    background-color: var(--bg-tag, #edf2f7);
    color: var(--text-tag, #4a5568);
    border: 1px solid var(--border-tag, #e2e8f0);
  }

  .belt-display {
    padding: 0.5rem;
    border-radius: 4px;
    text-align: center;
    font-weight: bold;
    border: 1px solid rgba(0,0,0,0.1); /* Subtle border for light belts */
  }

  .belt-display--none {
    background-color: var(--bg-subtle, #f0f0f0);
    color: var(--text-secondary, #555);
  }

  .student-card__details {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    font-size: 0.875rem;
    color: var(--text-secondary);
  }

  .student-card__detail {
    margin: 0;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
  }
  
  .student-card__detail--last-attended.student-card__detail--unknown {
    font-style: italic;
  }

  .student-card__additional-badges {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin-top: 0.25rem;
  }

  .student-card__actions {
    margin-top: auto; /* Pushes actions to the bottom if card has varying height */
    text-align: right; 
  }

  .action-button {
    background: none;
    border: none;
    cursor: pointer;
    color: var(--text-secondary);
    padding: 0.25rem;
  }
  .action-button:hover {
    color: var(--text-primary);
  }

  .visually-hidden {
    border: 0;
    clip: rect(0 0 0 0);
    height: 1px;
    margin: -1px;
    overflow: hidden;
    padding: 0;
    position: absolute;
    width: 1px;
    white-space: nowrap; /* Ensures the text remains on a single line, preventing layout shifts */
  }
</style>
