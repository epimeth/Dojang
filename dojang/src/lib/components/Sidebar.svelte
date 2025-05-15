<script lang="ts">
  import { page } from '$app/stores';
  
  const navItems = [
    { icon: 'home', label: 'Dashboard', href: '/' },
    { icon: 'users', label: 'Students', href: '/students' },
    { icon: 'calendar', label: 'Schedule', href: '/schedule' },
    { icon: 'award', label: 'Events', href: '/events' },
    { icon: 'clipboard', label: 'Belt Tests', href: '/belt-tests' },
    { icon: 'check-square', label: 'Attendance', href: '/attendance' },
    { icon: 'settings', label: 'Settings', href: '/settings' }
  ];
</script>

<aside class="sidebar">
  {#each navItems as { icon, label, href }}
    <a 
      href={href}
      class="nav-item"
      class:active={$page.url.pathname === href}
    >
      <i data-feather={icon} class="nav-icon"></i>
      <span>{label}</span>
    </a>
  {/each}
</aside>

<style>
  .sidebar {
    background-color: var(--bg-secondary);
    padding: 1.5rem 0;
    border-right: 1px solid var(--border-color);
  }

  .nav-item {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.75rem 1.5rem;
    cursor: pointer;
    color: var(--text-secondary);
    font-weight: 500;
    text-decoration: none;
  }

  .nav-item.active {
    background-color: var(--bg-primary);
    color: var(--text-primary);
    border-left: 3px solid var(--accent-green);
  }

  .nav-item:hover:not(.active) {
    background-color: rgba(0, 0, 0, 0.03);
  }

  .nav-icon {
    width: 20px;
    color: currentColor;
  }
</style>