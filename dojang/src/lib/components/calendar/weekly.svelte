<script>
  import { events as initialEvents } from './events'; // Assuming events.js exists
  import Daily from './Daily.svelte';

  let daysOfWeek = $state(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]);
  let events = $state(initialEvents);

  // Dojang color scheme
  let colors = $state({
    primary: "#3490dc",
    secondary: "#f6993f",
    background: "#f8f9fa",
    text: "#212529",
    accent: "#9f7aea",
    meeting: 'from-red-500 to-red-600',
    appointment: 'from-green-500 to-green-600',
    task: 'from-orange-500 to-orange-600',
    personal: 'from-purple-500 to-purple-600',
    break: 'from-teal-500 to-teal-600'
  });

  // Convert time string to minutes
  let timeToMinutes = $derived((timeString) => {
    const [hours, minutes] = timeString.split(':').map(Number);
    return hours * 60 + minutes;
  });

  // Convert minutes to time string
  let minutesToTime = $derived((minutes) => {
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    return `${hours.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}`;
  });

  // Adapt events data
  let classes = $derived(events.map(event => ({
    name: event.title,
    day: daysOfWeek.at(event.day), // Use at() for safe indexing
    time: event.time,
    endTime: minutesToTime(timeToMinutes(event.time) + event.duration),
    type: event.type
  })));

  // Generate time markers
  let timeMarkers = $derived(() => {
    let markers = [];
    for (let hour = 8; hour <= 19; hour++) {
      markers.push(`${hour.toString().padStart(2, '0')}:00`);
    }
    return markers;
  });
</script>

<dl class="weekly-calendar">
  <dt class="calendar-header">
    {#each daysOfWeek as day}
      <div class="day-header">
        <span>{day.slice(0, 3)}</span>
      </div>
    {/each}
  </dt>
  <dd class="calendar-body">
    <ol class="calendar-grid">
      <li class="time-column">
        {#each timeMarkers as time}
          <div class="time-marker">{time}</div>
        {/each}
      </li>
      {#each daysOfWeek as day}
        <Daily {day} {classes} {timeMarkers} {colors} />
      {/each}
    </ol><script>
      export let day;
      export let classes;
      export let timeMarkers;
      export let colors;
    </script>
    
    <li class="day-column">
      {#each timeMarkers as time, index}
        <div class="time-slot">
          {#each classes.filter(c => c.day === day && c.time === timeMarkers[index]) as classItem}
            <div class="event-item" style="background: var(--{classItem.type})">
              <span class="event-name">{classItem.name}</span>
              <span class="event-time">{classItem.time} - {classItem.endTime}</span>
            </div>
          {/each}
        </div>
      {/each}
    </li>
    <script>
      export let day;
      export let classes;
      export let timeMarkers;
      export let colors;
    </script>
    
    <li class="day-column">
      {#each timeMarkers as time, index}
        <div class="time-slot">
          {#each classes.filter(c => c.day === day && c.time === timeMarkers[index]) as classItem}
            <div class="event-item" style="background: var(--{classItem.type})">
              <span class="event-name">{classItem.name}</span>
              <span class="event-time">{classItem.time} - {classItem.endTime}</span>
            </div>
          {/each}
        </div>
      {/each}
    </li>
    
  </dd>
</dl>

<style>
  /* ... (same styles as before) ... */
</style>
