<script>
  let minimized = false;

  function toggleMenu() {
    minimized = !minimized;
  }
</script>

<div class="menu {minimized ? 'minimized' : ''}">
  <button class="toggle" on:click={toggleMenu}>
    {minimized ? '☰' : '⇔'}
  </button>
  <ul>
    <li><a href="/dashboard">Dashboard</a></li>
    <li><a href="/settings">Settings</a></li>
    <li><a href="/profile">Profile</a></li>
  </ul>
</div>

<style>
  .menu {
    background-color: #222;
    color: #fff;
    display: flex;
    flex-direction: column;
    width: 200px;
    transition: width 0.3s ease;
  }

  .menu.minimized {
    width: 60px;
  }

  .menu ul {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .menu ul li {
    padding: 0.5rem 1rem;
  }

  .menu ul li a {
    color: #fff;
    text-decoration: none;
  }

  .toggle {
    background: none;
    border: none;
    color: #fff;
    padding: 1rem;
    cursor: pointer;
  }
</style>
