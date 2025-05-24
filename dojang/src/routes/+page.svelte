<script>
  import WeeklyCalendar from '$lib/components/calendar/weekly.svelte';

  let { data } = $props()
  let { colors } = $derived(data)

  // Example data (replace with your actual data)
  let classes = [
    { name: "Math 101", instructor: "Dr. Smith", day: "Monday", time: "9:00 AM" },
    { name: "History 202", instructor: "Prof. Jones", day: "Tuesday", time: "10:00 AM" },
    // ... more classes
  ];
</script>

<h1>Welcome to Supabase!</h1>
<ul>
  {#each colors as color}
    <li>{color.name}</li>
  {/each}
</ul>

<div class="calendar-container">
  <WeeklyCalendar {classes} />
</div>

<style>
  .calendar-container {
    /* Add any styling for the container div here */
    max-width: 800px;
    margin: 0 auto;
  }
</style>