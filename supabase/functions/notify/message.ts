// notify'ın saf kuralları: webhook gövdesinden bildirim üretir.

import { type AppLocale, pickLocale } from "../_shared/locale.ts";

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

export type Locale = AppLocale;

/// Kullanıcının `user_metadata.locale` değerinden bildirim dili; yoksa ya
/// da desteklenmiyorsa İngilizce.
export const localeOf = pickLocale;

/// Dillere göre bildirim metinleri. `last` destek döneminin son günü.
const text: Record<Locale, {
  taskTitle: string;
  taskBody: string;
  supportTitle: string;
  supportBody: (name: string, last: string) => string;
}> = {
  tr: {
    taskTitle: "Sana yeni görev atandı",
    taskBody: "Bir görev sana atandı.",
    supportTitle: "Destek başvurusu açıldı",
    supportBody: (name, last) => `${name} · son gün ${last}`,
  },
  en: {
    taskTitle: "New task for you",
    taskBody: "A task was assigned to you.",
    supportTitle: "Support application is open",
    supportBody: (name, last) => `${name} · last day ${last}`,
  },
  de: {
    taskTitle: "Neue Aufgabe für dich",
    taskBody: "Dir wurde eine Aufgabe zugewiesen.",
    supportTitle: "Förderantrag ist geöffnet",
    supportBody: (name, last) => `${name} · letzter Tag ${last}`,
  },
  es: {
    taskTitle: "Tienes una tarea nueva",
    taskBody: "Se te ha asignado una tarea.",
    supportTitle: "La solicitud de ayudas está abierta",
    supportBody: (name, last) => `${name} · último día ${last}`,
  },
};

/// Bildirim metni. Otomatik görevin başlığı yoktur; genel metin gösterilir.
export function notificationText(
  task: TaskRecord,
  locale: Locale,
): { title: string; body: string } {
  const title = task.title?.trim();
  return {
    title: text[locale].taskTitle,
    body: title ? title : text[locale].taskBody,
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

/// Gün biçimi yereli.
const dayLocales: Record<Locale, string> = {
  tr: "tr-TR",
  en: "en-GB",
  de: "de-DE",
  es: "es-ES",
};

/// "2026-12-31" → dilin kısa tarihi: "31.12.2026" (TR, DE), "31/12/2026"
/// (EN, ES). Biçimsiz gün olduğu gibi döner.
export function formatDay(day: string, locale: Locale): string {
  const [year, month, date] = day.split("-").map(Number);
  if (!year || !month || !date) return day;
  return new Intl.DateTimeFormat(dayLocales[locale], {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    timeZone: "UTC",
  }).format(new Date(Date.UTC(year, month - 1, date)));
}

/// Destek dönemi bildirimi: başlık ve "ad · son gün".
export function supportPeriodText(
  period: SupportPeriodRecord,
  locale: Locale,
): { title: string; body: string } {
  const last = formatDay(period.application_ends_on, locale);
  return {
    title: text[locale].supportTitle,
    body: text[locale].supportBody(period.name, last),
  };
}
