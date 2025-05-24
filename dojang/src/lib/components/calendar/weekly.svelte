<script>
  export let classes = [];

  // Example data structure (adjust as needed):
  classes = [
    { name: "Math 101", instructor: "Dr. Smith", day: "Monday", time: "9:00 AM" },
    { name: "History 202", instructor: "Prof. Jones", day: "Tuesday", time: "10:00 AM" },
  //   // ... more classes
  ];

  const daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]; // Adjust as needed
</script>

<dl>
  {#each daysOfWeek as day}
    <dt>{day}</dt>
    <dd>
      <ol>
        {#each classes.filter(c => c.day === day) as classItem}
          <li>
            {classItem.name} - {classItem.instructor}
            {#if classItem.time}
              ({classItem.time})
            {/if}
          </li>
        {/each}
      </ol>
    </dd>
  {/each}
</dl>

<style>
  dl {
    /* Basic styling for the list */
  }

  dt {
    /* Style for the day name */
    font-weight: bold;
    margin-top: 10px;
  }

  dd {
    /* Style for the events list */
    margin-left: 20px;
  }

  ol {
    /* Style for the ordered list of events */
    list-style-type: none; /* Remove default numbering */
    padding: 0;
  }

  li {
    /* Style for each event item */
    margin-bottom: 5px;
  }
</style>
