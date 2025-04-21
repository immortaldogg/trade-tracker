<script>
    import { onMount } from "svelte";

    let stats = null;

    onMount(async() => {
        stats = await fetchStats();
    })
</script>