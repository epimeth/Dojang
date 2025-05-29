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
