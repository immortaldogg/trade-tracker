<script>
    import { createEventDispatcher } from "svelte";

    const dispatch = createEventDispatcher();

    let trade = {
        symbol: "",
        direction: "",
        entry_price: "",
        size: "",
        leverage: "",
        exchange: "",
        notes: "",
    };

    const submit = () => {
        dispatch("submitTrade", { ...trade });
        // Clear form
        trade = {
            symbol: "",
            direction: "",
            entry_price: "",
            size: "",
            leverage: "",
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
