import { assert, assertEquals } from "jsr:@std/assert@1";
import { supportedLocales } from "../_shared/locale.ts";
import { codeMail, completedMail, formatDeletionDate, mailLocale, requestedMail } from "./mail.ts";

Deno.test("dil user_metadata.locale'den gelir, varsayılan İngilizce", () => {
  assertEquals(mailLocale("en"), "en");
  assertEquals(mailLocale("en-GB"), "en");
  assertEquals(mailLocale("tr"), "tr");
  assertEquals(mailLocale("tr-TR"), "tr");
  assertEquals(mailLocale("xx"), "en");
  assertEquals(mailLocale(undefined), "en");
  assertEquals(mailLocale(42), "en");
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

Deno.test("silme kodu e-postası giriş kodundan ayrı", () => {
  const tr = codeMail("482913", "tr");
  assertEquals(tr.subject, "Mobil Arıcı hesap silme kodun");
  assert(tr.text.includes("482913"));
  assert(tr.text.includes("hesabın silinmez"));
  const en = codeMail("482913", "en");
  assertEquals(en.subject, "Your Mobil Arıcı account deletion code");
  assert(en.text.includes("482913"));
});

Deno.test("her dilde üç e-posta da kodu ve tarihi taşır", () => {
  for (const locale of supportedLocales) {
    const requested = requestedMail("2026-11-12T09:30:00Z", true, locale);
    assert(requested.subject.includes("Mobil"), locale);
    assert(requested.text.includes("2026"), locale);
    assert(codeMail("482913", locale).text.includes("482913"), locale);
    assert(completedMail(locale).subject.length > 0, locale);
  }
  assertEquals(formatDeletionDate("2026-11-12T21:30:00Z", "de"), "12. November 2026 um 21:30 UTC");
  assertEquals(formatDeletionDate("2026-11-12T21:30:00Z", "es"), "12 de noviembre de 2026, 21:30 UTC");
});

Deno.test("Farsçada tarih Miladi takvim ve Latin rakamla", () => {
  const text = formatDeletionDate("2026-11-12T21:30:00Z", "fa");
  assert(text.includes("2026"), text);
  assert(text.includes("نوامبر"), text);
  assert(!/[۰-۹]/.test(text), text);
});
