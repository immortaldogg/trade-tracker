<script>
    import { link } from "svelte-spa-router";

    function goBack() {
        history.back();
    }
</script>

<nav style="display: flex; gap: 1rem; padding: 1rem; background: #f2f2f2;">
    <button on:click={goBack}>⬅️ Back</button>
    <a use:link href="/trades">📈 Trades</a>
    <a use:link href="/trade/new">➕ New Trade</a>
</nav>
