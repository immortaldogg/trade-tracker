<script>
  import TradeList from "./components/TradeList.svelte";
  import TradeForm from "./components/TradeForm.svelte";

  const handleNewTrade = (eh) => {
    console.log(eh);
  };
</script>

<main>
  <h1>Trade Tracker UI</h1>
  <TradeList />
  <TradeForm on:submitTrade={handleNewTrade} />
</main>

<style>
  main {
    padding: 2rem;
    font-family: sans-serif;
  }

  h1 {
    color: #333;
  }
</style>
