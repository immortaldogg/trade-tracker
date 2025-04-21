<script>
    import { onMount } from "svelte";
    import { trades } from "../stores/trades";

    export let params;

    let trade;
    $: trade = $trades.find((t) => t.id == params.id);

</script>

{#if trade}
    <h2>Trade Detail</h2>
    <p><strong>Symbol:</strong> {trade.symbol}</p>
    <p><strong>Direction:</strong> {trade.direction}</p>
    <p><strong>Price:</strong> {trade.entry_price}</p>
    <p><strong>Size:</strong> {trade.size}</p>
    <p><strong>Leverage:</strong> {trade.leverage}</p>
    <p><strong>Exchange:</strong> {trade.exchange}</p>
    <p><strong>Notes:</strong> {trade.notes}</p>
{:else}
    <p>Trade not found</p>
{/if}
