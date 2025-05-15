<script lang="ts">
  import { invalidate } from '$app/navigation';
  import { onMount } from 'svelte';
  import Header from '$lib/components/Header.svelte';
  import Sidebar from '$lib/components/Sidebar.svelte';
  import feather from 'feather-icons';
  import '../app.css';
  
  let { data, children } = $props();
  let { session, supabase } = $derived(data);
  
  onMount(() => {
    const { data } = supabase.auth.onAuthStateChange((_, newSession) => {
      if (newSession?.expires_at !== session?.expires_at) {
        invalidate('supabase:auth');
      }
    });

    // Initialize Feather icons
    if (typeof feather !== 'undefined') {
      feather.replace();
    }

    return () => data.subscription.unsubscribe();
  });
</script>

<div class="container">
  <Header />
  <div class="content-wrapper">
    <Sidebar />
    <main class="main-content">
      {@render children()}
    </main>
  </div>
</div>

<style>
  .container {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }

  .content-wrapper {
    flex: 1;
    display: grid;
    grid-template-columns: 250px 1fr;
  }

  .main-content {
    padding: 1.5rem 2rem;
    background-color: var(--bg-primary);
  }
</style>

