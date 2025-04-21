<script>
    import { mockTrades } from "../mock/trades.js";
</script>

<h2>Me trades</h2>

<table>
    <thead>
        <tr>
            <th>Symbol</th>
            <th>Direction</th>
            <th>Price</th>
            <th>Size</th>
            <th>Leverage</th>
            <th>Exchange</th>
            <th>Notes</th>
        </tr>
    </thead>
    <tbody>
        {#each mockTrades as trade}
            <tr>
                <td>{trade.symbol}</td>
                <td>{trade.direction}</td>
                <td>{trade.entry_price}</td>
                <td>{trade.size}</td>
                <td>{trade.leverage}</td>
                <td>{trade.exchange}</td>
                <td>{trade.notes}</td>
            </tr>
        {/each}
    </tbody>
</table>

<style>
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 1rem;
    }

    th,
    td {
        border: 1px solid #ccc;
        padding: 0.5rem;
        text-align: left;
    }

    th {
        background-color: #f2f2f2;
    }
</style>
