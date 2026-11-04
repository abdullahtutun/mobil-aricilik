// feedback-mail'in saf kuralları: webhook gövdesinden mail metni üretir.

export interface FeedbackRecord {
  id: string;
  org_id: string;
  kind: string;
  message: string;
  screenshot_path: string | null;
  device_info: Record<string, unknown> | null;
  created_at: string;
  created_by: string | null;
}

export interface WebhookPayload {
  type: string;
  table: string;
  record: FeedbackRecord | null;
}

export interface FeedbackMail {
  subject: string;
  text: string;
}

const kindLabels: Record<string, string> = {
  bug: "Hata",
  suggestion: "Öneri",
  missing_feature: "Eksik özellik",
  thanks: "Teşekkür",
};

/// Mail gerektiren görüş: `feedback` tablosuna eklenen satır.
export function insertedFeedback(
  payload: WebhookPayload,
): FeedbackRecord | null {
  if (payload.table !== "feedback" || payload.type !== "INSERT") return null;
  const record = payload.record;
  if (!record?.id || !record.message) return null;
  return record;
}

/// Mailin konusu ve düz metin gövdesi. Kullanıcıdan gelen metin düz
/// metin olarak gider; HTML üretilmez.
export function feedbackMail(
  record: FeedbackRecord,
  context: {
    orgName: string | null;
    senderEmail: string | null;
    screenshotUrl: string | null;
  },
): FeedbackMail {
  const kind = kindLabels[record.kind] ?? record.kind;
  const org = context.orgName ?? record.org_id;
  // Konu satırına satır sonu girmesin.
  const subject = `[Mobil Arıcı] ${kind} — ${org}`.replace(/[\r\n]+/g, " ");

  const lines = [
    record.message.trim(),
    "",
    "—",
    `Tür: ${kind}`,
    `İşletme: ${org}`,
    `Gönderen: ${context.senderEmail ?? "bilinmiyor"}`,
    `Yazıldığı an: ${record.created_at}`,
  ];
  if (record.device_info && Object.keys(record.device_info).length > 0) {
    lines.push("Cihaz:");
    for (const [key, value] of Object.entries(record.device_info)) {
      lines.push(`  ${key}: ${String(value)}`);
    }
  }
  if (context.screenshotUrl) {
    lines.push(`Ekran görüntüsü (7 gün geçerli): ${context.screenshotUrl}`);
  } else if (record.screenshot_path) {
    lines.push(`Ekran görüntüsü: feedback/${record.screenshot_path}`);
  }
  lines.push(`Kayıt: feedback.id = ${record.id}`);
  return { subject, text: lines.join("\n") };
}
