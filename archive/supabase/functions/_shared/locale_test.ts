import { assertEquals } from "jsr:@std/assert@1";
import { pickAcceptLanguage, pickLocale } from "./locale.ts";

Deno.test("dil kodu bölgeden bağımsız seçilir", () => {
  assertEquals(pickLocale("tr"), "tr");
  assertEquals(pickLocale("tr-TR"), "tr");
  assertEquals(pickLocale("EN_gb"), "en");
});

Deno.test("desteklenmeyen ya da bilinmeyen dilde İngilizce", () => {
  assertEquals(pickLocale("xx"), "en");
  assertEquals(pickLocale(""), "en");
  assertEquals(pickLocale(undefined), "en");
  assertEquals(pickLocale(42), "en");
});

Deno.test("Accept-Language'da sırayla ilk desteklenen dil", () => {
  assertEquals(pickAcceptLanguage("tr-TR,tr;q=0.9,en;q=0.8"), "tr");
  assertEquals(pickAcceptLanguage("xx-XX,tr;q=0.8"), "tr");
  assertEquals(pickAcceptLanguage("en-US,tr;q=0.8"), "en");
  assertEquals(pickAcceptLanguage("xx"), "en");
  assertEquals(pickAcceptLanguage(null), "en");
});
