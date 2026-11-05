import { assert, assertEquals } from "jsr:@std/assert@1";
import { completedMail, formatDeletionDate, mailLocale, requestedMail } from "./mail.ts";

Deno.test("dil user_metadata.locale'den gelir, varsayılan Türkçe", () => {
  assertEquals(mailLocale("en"), "en");
  assertEquals(mailLocale("en-GB"), "en");
  assertEquals(mailLocale("tr"), "tr");
  assertEquals(mailLocale(undefined), "tr");
  assertEquals(mailLocale(42), "tr");
});

Deno.test("tarih Türkçede Türkiye saatiyle, İngilizcede UTC ile yazılır", () => {
  assertEquals(formatDeletionDate("2026-11-12T21:30:00Z", "tr"), "13 Kasım 2026 00:30 (TSİ)");
  assertEquals(formatDeletionDate("2026-11-12T21:30:00Z", "en"), "12 November 2026 at 21:30 UTC");
});

Deno.test("talep e-postası tarihi ve giriş yapıp onaylayarak vazgeçmeyi söyler", () => {
  const tr = requestedMail("2026-11-12T09:30:00Z", false, "tr");
  assert(tr.text.includes("12 Kasım 2026 12:30 (TSİ) tarihinde kalıcı olarak silinecek"));
  assert(tr.text.includes("giriş yap ve hesabını korumak istediğini onayla"));
  assert(tr.text.includes("işletmede kalır"));

  const trOrg = requestedMail("2026-11-12T09:30:00Z", true, "tr");
  assert(trOrg.text.includes("işletmen ve işletmenin tüm kayıtları"));

  const en = requestedMail("2026-11-12T09:30:00Z", true, "en");
  assert(en.text.includes("permanently deleted on 12 November 2026 at 09:30 UTC"));
  assert(en.text.includes("sign in"));
});

Deno.test("tamamlanma e-postası kısa onaydır", () => {
  assertEquals(completedMail("tr").subject, "Mobil Arıcı hesabın silindi");
  assertEquals(completedMail("en").subject, "Your Mobil Arıcı account has been deleted");
});
