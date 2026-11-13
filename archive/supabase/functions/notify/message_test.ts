import { assertEquals } from "jsr:@std/assert@1";
import { supportedLocales } from "../_shared/locale.ts";
import { formatDay, localeOf, notificationText, supportPeriodText } from "./message.ts";

const task = {
  id: "t",
  org_id: "o",
  title: null,
  assigned_to: "u",
  completed_at: null,
  deleted_at: null,
};

Deno.test("bildirim dili user_metadata.locale'den; bilinmiyorsa İngilizce", () => {
  assertEquals(localeOf("de"), "de");
  assertEquals(localeOf("es-ES"), "es");
  assertEquals(localeOf(undefined), "en");
});

Deno.test("görev başlığı varsa gövde odur; yoksa dilin genel metni", () => {
  assertEquals(notificationText({ ...task, title: " Kontrol " }, "de").body, "Kontrol");
  assertEquals(notificationText(task, "de"), {
    title: "Neue Aufgabe für dich",
    body: "Dir wurde eine Aufgabe zugewiesen.",
  });
  for (const locale of supportedLocales) {
    assertEquals(notificationText(task, locale).title.length > 0, true);
  }
});

Deno.test("son gün dilin kısa tarihiyle yazılır", () => {
  assertEquals(formatDay("2026-12-31", "tr"), "31.12.2026");
  assertEquals(formatDay("2026-12-31", "de"), "31.12.2026");
  assertEquals(formatDay("2026-12-31", "es"), "31/12/2026");
  assertEquals(formatDay("2026-12-31", "en"), "31/12/2026");
  assertEquals(formatDay("bozuk", "tr"), "bozuk");
  assertEquals(
    supportPeriodText(
      { id: "p", name: "Destek", application_starts_on: "2026-12-01", application_ends_on: "2026-12-31" },
      "es",
    ).body,
    "Destek · último día 31/12/2026",
  );
});
