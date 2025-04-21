import { writable } from "svelte/store";
import { mockTrades } from "../mock/trades";

export const trades = writable([...mockTrades]);