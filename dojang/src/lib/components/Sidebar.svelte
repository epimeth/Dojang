<script lang="ts">
  import { page } from '$app/state';
  import { onMount } from 'svelte';
  import feather from 'feather-icons';

  type NavItem = {
    icon: string;
    label: string;
    href: string;
  };

  let navItems = $state<NavItem[]>([
    { icon: 'home', label: 'Dashboard', href: '/app' },
    { icon: 'users', label: 'Students', href: '/app/students' },
    { icon: 'calendar', label: 'Schedule', href: '/app/schedule' },
    { icon: 'award', label: 'Events', href: '/app/events' },
    { icon: 'clipboard', label: 'Belt Tests', href: '/app/belt-tests' },
    { icon: 'check-square', label: 'Attendance', href: '/app/attendance' },
    { icon: 'settings', label: 'Settings', href: '/app/settings' }
  ]);

  // Derive active state based on current path
  let isActive = $derived((href: string) => page.url.pathname === href);

  onMount(() => {
    if (typeof feather !== 'undefined') {
      feather.replace();
    }
  });

</script>

<aside class="sidebar">
  {#each navItems as { icon, label, href }}
    <a 
      {href}
      class="nav-item"
      class:active={isActive(href)}
      role="menuitem"
    >
      <i data-feather={icon} class="nav-icon" aria-hidden="true"></i>
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