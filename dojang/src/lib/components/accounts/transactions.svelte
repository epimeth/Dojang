<script>
  export let transactions = [];
</script>

<table>
  <thead>
    <tr>
      <th>Date</th>
      <th>Description</th>
      <th>Amount</th>
    </tr>
  </thead>
  <tbody>
    {#each transactions as transaction}
      <tr>
        <td>{transaction.date}</td>
        <td>{transaction.description}</td>
        <td>${transaction.amount}</td>
      </tr>
    {/each}
  </tbody>
</table>
