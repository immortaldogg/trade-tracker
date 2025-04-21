<script>
  import Router from "svelte-spa-router";
  import { location } from "svelte-spa-router";
  import wrap from "svelte-spa-router/wrap";
  import Navbar from "./components/Navbar.svelte";

  const routes = {
    "/": wrap({
      asyncComponent: () => import("./routes/TradeList.svelte"),
    }),
    "/trades": wrap({
      asyncComponent: () => import("./routes/TradeList.svelte"),
    }),
    "/trade/new": wrap({
      asyncComponent: () => import("./routes/TradeForm.svelte"),
    }),
    "/trade/:id": wrap({
      asyncComponent: () => import("./routes/TradeDetail.svelte"),
    }),
  };
  $: console.log("Current route:", $location);
</script>

<main>
  <h1>Trade Tracker UI</h1>
  <Navbar />
  <Router {routes} />
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
