// notify'ın saf kuralları: webhook gövdesinden bildirim üretir.

export interface TaskRecord {
  id: string;
  org_id: string;
  title: string | null;
  assigned_to: string | null;
  completed_at: string | null;
  deleted_at: string | null;
}

export interface WebhookPayload {
  type: string;
  table: string;
  record: TaskRecord | null;
  old_record: TaskRecord | null;
}

/// Görev ataması bildirimi gerektiriyor mu: eklenen ya da atananı değişen,
/// atanmış, açık ve silinmemiş görev.
export function assignedTask(payload: WebhookPayload): TaskRecord | null {
  if (payload.table !== "tasks") return null;
  if (payload.type !== "INSERT" && payload.type !== "UPDATE") return null;
  const task = payload.record;
  if (!task?.assigned_to || task.deleted_at || task.completed_at) return null;
  if (
    payload.type === "UPDATE" &&
    payload.old_record?.assigned_to === task.assigned_to
  ) {
    return null;
  }
  return task;
}

export type Locale = "tr" | "en";

export function localeOf(value: unknown): Locale {
  return value === "en" ? "en" : "tr";
}

/// Bildirim metni. Otomatik görevin başlığı yoktur; genel metin gösterilir.
export function notificationText(
  task: TaskRecord,
  locale: Locale,
): { title: string; body: string } {
  const title = task.title?.trim();
  if (locale === "en") {
    return {
      title: "New task for you",
      body: title ? title : "A task was assigned to you.",
    };
  }
  return {
    title: "Sana yeni görev atandı",
    body: title ? title : "Bir görev sana atandı.",
  };
}

export interface SupportPeriodRecord {
  id: string;
  name: string;
  application_starts_on: string;
  application_ends_on: string;
}

/// `private.notify_support_periods`'un gövdesi: açılan destek dönemi ve
/// alıcıları (TR işletmelerinin owner ve partner üyeleri).
export interface SupportPeriodPayload {
  type: string;
  table: string;
  record: SupportPeriodRecord | null;
  recipients: string[] | null;
}

/// Gövde açılan bir destek dönemi mi; dönem ve alıcılar.
export function openedSupportPeriod(
  payload: { table?: string; type?: string },
): { period: SupportPeriodRecord; recipients: string[] } | null {
  if (payload.table !== "ref_support_periods") return null;
  const { type, record, recipients } = payload as SupportPeriodPayload;
  if (type !== "OPENED" || !record?.id || !record.name) return null;
  if (!Array.isArray(recipients) || recipients.length === 0) return null;
  return { period: record, recipients };
}

/// "2026-12-31" → "31.12.2026" (TR) ya da "2026-12-31" (EN).
function formatDay(day: string, locale: Locale): string {
  const [year, month, date] = day.split("-");
  if (locale === "en" || !year || !month || !date) return day;
  return `${date}.${month}.${year}`;
}

/// Destek dönemi bildirimi: başlık ve "ad · son gün".
export function supportPeriodText(
  period: SupportPeriodRecord,
  locale: Locale,
): { title: string; body: string } {
  const last = formatDay(period.application_ends_on, locale);
  if (locale === "en") {
    return {
      title: "Support application is open",
      body: `${period.name} · last day ${last}`,
    };
  }
  return {
    title: "Destek başvurusu açıldı",
    body: `${period.name} · son gün ${last}`,
  };
}
