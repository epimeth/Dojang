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
    isLastAttendedDataExpected = true
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

<tr class="student-list-item" aria-labelledby="student-name-list-{student.id}">
  <td class="student-list-item__indicator">
    {#if student.teams?.some(team => team.id === TEAM_TIGER_ID)}
      <span class="student-list-item__badge student-list-item__badge--team-tiger" title="Team Tiger Member">
        <i data-feather="award" aria-hidden="true"></i>
        <span class="visually-hidden">Team Tiger</span>
      </span>
    {/if}
  </td>
  <td id="student-name-list-{student.id}" class="student-list-item__name">
    <a href="/app/students/{student.id}" class="student-list-item__name-link" aria-label="View profile for {student.full_name}">{student.full_name}</a>
  </td>
  <td class="student-list-item__belt">
    {#if student.current_belt}
      <span
        class="belt-display-list"
        style:background-color={student.current_belt.color}
        style:color={getTextColorForBackground(student.current_belt.color)}
        aria-label="Current Belt: {student.current_belt.name}"
      >
        {student.current_belt.name}
      </span>
    {:else}
      <span class="belt-display-list belt-display-list--none" aria-label="No current belt">
        N/A
      </span>
    {/if}
  </td>
  <td class="student-list-item__age">
    <i data-feather="gift" aria-hidden="true"></i>
    <span>{calculateAge(student.date_of_birth)}</span>
  </td>
  <td class="student-list-item__last-attended">
    {#if student.last_class_attended}
      <i data-feather="clock" aria-hidden="true"></i>
      <span style="color: {getColorForLastAttended(student.last_class_attended)};">
        {formatDate(student.last_class_attended)}
      </span>
    {:else if isLastAttendedDataExpected}
      <i data-feather="clock" aria-hidden="true"></i>
      <span class="text-muted">Unknown</span>
    {/if}
  </td>
  <td class="student-list-item__actions">
    <button
      class="action-button"
      aria-label="More actions for {student.full_name}"
      aria-haspopup="true"
      aria-expanded="false"
    >
      <i data-feather="more-vertical" aria-hidden="true"></i>
      <span class="visually-hidden">Actions</span>
    </button>
  </td>
</tr>

<style>
  .student-list-item td {
    padding: 0.75rem 0.5rem;
    vertical-align: middle;
    border-bottom: 1px solid var(--border-color, #e2e8f0);
  }

  .student-list-item__indicator .student-list-item__badge--team-tiger {
    /* Style for team tiger badge in list view if needed */
    background-color: var(--accent-red, #e53e3e);
    color: white;
    padding: 0.2em 0.4em;
    border-radius: 3px;
    font-size: 0.8em;
  }

  .student-list-item__name-link {
    color: var(--text-link, var(--primary-color));
    text-decoration: none;
    font-weight: 500;
  }
  .student-list-item__name-link:hover {
    text-decoration: underline;
  }

  .belt-display-list {
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-size: 0.875rem;
    font-weight: 500;
    border: 1px solid rgba(0,0,0,0.05);
  }
  .belt-display-list--none {
    background-color: var(--bg-subtle, #f0f0f0);
    color: var(--text-secondary, #555);
  }

  .student-list-item__age,
  .student-list-item__last-attended {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    font-size: 0.875rem;
    color: var(--text-secondary);
  }
  .text-muted {
    color: var(--text-muted, #718096);
  }

  .student-list-item__actions {
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
    white-space: nowrap;
  }
</style>