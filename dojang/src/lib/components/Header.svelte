<script lang="ts">
  export let academyName = "Eastside Martial Arts";
  export let userInitials = "IL";
  export let notificationCount = 3;
</script>

<header>
  <div class="logo">
    <img src="/img/dojang.webp" class="logo-icon" alt="Dojang">
    <img src="/img/AcademyManagement.webp" class="logo-icon" alt="Academy Management">
  </div>
  
  <button class="academy-select">
    {academyName}
    <i data-feather="chevron-down"></i>
  </button>
  
  <div class="user-controls">
    <button class="notification-bell">
      <i data-feather="bell"></i>
      {#if notificationCount > 0}
        <div class="notification-badge">{notificationCount}</div>
      {/if}
    </button>
    <div class="avatar-circle">{userInitials}</div>
  </div>
</header>

<style>
  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.75rem 2rem;
    background-color: var(--bg-secondary);
    border-bottom: 1px solid var(--border-color);
  }

  .logo {
    display: flex;
    align-items: center;
    gap: 1rem;
    font-size: 1.5rem;
    font-weight: 600;
  }

  .logo-icon {
    height: 40px;
  }

  .academy-select {
    background-color: var(--bg-card);
    border: 1px solid var(--border-color);
    border-radius: 6px;
    padding: 0.5rem 1rem;
    font-size: 1rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .user-controls {
    display: flex;
    align-items: center;
    gap: 1.5rem;
  }

  .notification-bell {
    position: relative;
    cursor: pointer;
    color: var(--text-secondary);
    background: none;
    border: none;
    padding: 0;
  }

  .notification-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background-color: var(--accent-red);
    color: white;
    border-radius: 50%;
    width: 18px;
    height: 18px;
    font-size: 0.75rem;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .avatar-circle {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background-color: var(--accent-green);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
  }
</style>