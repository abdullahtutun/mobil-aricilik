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
