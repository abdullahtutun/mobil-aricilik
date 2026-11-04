// feedback-mail: "Görüş bildir" mesajını ekibe e-postayla yollar.
//
// `private.notify_feedback_mail` tetikleyicisi (pg_net) ya da Dashboard'dan
// kurulan bir Database Webhook çağırır: POST { type, table, record }. İstek
// `x-webhook-secret` başlığında paylaşılan gizli anahtarı (secret
// FEEDBACK_MAIL_SECRET) taşımalı; JWT yok (`verify_jwt = false`).
//
// Secret'lar: FEEDBACK_MAIL_SECRET, SMTP_USER (gönderen posta kutusu, ör.
// bildirim@alanadi.com), SMTP_PASS, FEEDBACK_TO_EMAIL (alıcı). İsteğe bağlı:
// SMTP_HOST (varsayılan smtp.hostinger.com), SMTP_PORT (varsayılan 465, SSL;
// Edge Function'lardan 25 ve 587 kapalı). SMTP kurulmamışsa 503 döner;
// görüş yazmasını etkilemez.
//
// Yanıtla dendiğinde mail görüşü gönderen kullanıcıya gider (Reply-To).

import { createClient } from "npm:@supabase/supabase-js@2";
import nodemailer from "npm:nodemailer@6.9.16";
import { feedbackMail, insertedFeedback, type WebhookPayload } from "./message.ts";

const screenshotUrlSeconds = 7 * 24 * 60 * 60;

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

/// Sabit sürede karşılaştırma.
function sameSecret(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

Deno.serve(async (request) => {
  if (request.method !== "POST") return json({ error: "method" }, 405);

  const expected = Deno.env.get("FEEDBACK_MAIL_SECRET");
  const given = request.headers.get("x-webhook-secret") ?? "";
  if (!expected || !sameSecret(given, expected)) {
    return json({ error: "unauthorized" }, 401);
  }

  const smtpUser = Deno.env.get("SMTP_USER");
  const smtpPass = Deno.env.get("SMTP_PASS");
  const to = Deno.env.get("FEEDBACK_TO_EMAIL");
  if (!smtpUser || !smtpPass || !to) {
    return json({ error: "mail_not_configured" }, 503);
  }

  let payload: WebhookPayload;
  try {
    payload = await request.json();
  } catch {
    return json({ error: "bad_request" }, 400);
  }
  const record = insertedFeedback(payload);
  if (!record) return json({ sent: 0 });

  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { auth: { persistSession: false } },
  );

  // Ek bilgiler yardımcıdır; alınamazsa mail yine gider.
  const { data: org } = await admin
    .from("organizations")
    .select("name")
    .eq("id", record.org_id)
    .maybeSingle();

  let senderEmail: string | null = null;
  if (record.created_by) {
    const { data } = await admin.auth.admin.getUserById(record.created_by);
    senderEmail = data?.user?.email ?? null;
  }

  let screenshotUrl: string | null = null;
  if (record.screenshot_path) {
    const { data } = await admin.storage
      .from("feedback")
      .createSignedUrl(record.screenshot_path, screenshotUrlSeconds);
    screenshotUrl = data?.signedUrl ?? null;
  }

  const mail = feedbackMail(record, {
    orgName: org?.name ?? null,
    senderEmail,
    screenshotUrl,
  });

  const port = Number(Deno.env.get("SMTP_PORT") ?? "465");
  const transport = nodemailer.createTransport({
    host: Deno.env.get("SMTP_HOST") ?? "smtp.hostinger.com",
    port,
    secure: port === 465,
    auth: { user: smtpUser, pass: smtpPass },
  });

  try {
    await transport.sendMail({
      from: `Mobil Arıcı <${smtpUser}>`,
      to,
      replyTo: senderEmail ?? undefined,
      subject: mail.subject,
      text: mail.text,
    });
  } catch (error) {
    console.error("feedback-mail send failed", error);
    return json({ error: "send_failed" }, 502);
  }
  return json({ sent: 1 });
});
