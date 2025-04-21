<script>
    import { get } from "svelte/store";
    import { trades } from "../stores/trades";

    let trade = {
        id: null,
        symbol: "",
        direction: "",
        entry_price: null,
        size: null,
        leverage: null,
        exchange: "",
        notes: "",
    };

    const submit = () => {
        let tradeId =
            get(trades).reduce((max, t) => (t.id > max ? t.id : max), 0) + 1;
        trade.id = tradeId;
        trades.update((current) => [...current, trade]);
        // Clear form
        trade = {
            id: null,
            symbol: "",
            direction: "",
            entry_price: null,
            size: null,
            leverage: null,
            exchange: "",
            notes: "",
        };
    };
</script>

<h2>Add Trade</h2>

<form on:submit|preventDefault={submit}>
    <input placeholder="Symbol" bind:value={trade.symbol} />
    <select bind:value={trade.direction}>
        <option value="long">Long</option>
        <option value="short">Short</option>
    </select>
    <input
        type="number"
        step="any"
        placeholder="Entry price"
        bind:value={trade.entry_price}
    />
    <input type="number" placeholder="Position size" bind:value={trade.size} />
    <input type="number" placeholder="Leverage" bind:value={trade.leverage} />
    <input type="text" placeholder="Exchange" bind:value={trade.exchange} />
    <textarea placeholder="Notes" bind:value={trade.notes}></textarea>
    <button type="submit">Submit</button>
</form>

<style>
    form {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
        margin-bottom: 1rem;
    }

    input,
    select,
    textarea {
        padding: 0.5rem;
        font-size: 1rem;
    }
</style>
