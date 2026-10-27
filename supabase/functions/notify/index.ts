// notify: Göreve kişi atanınca atanana push (FCM) gönderir.
//
// `private.notify_task_assigned` tetikleyicisi (pg_net) ya da Dashboard'dan
// kurulan bir Database Webhook çağırır: POST { type, table, record,
// old_record }. İstek `x-webhook-secret` başlığında paylaşılan gizli
// anahtarı (secret NOTIFY_SECRET) taşımalı; JWT yok (`verify_jwt = false`).
//
// Secret'lar: NOTIFY_SECRET, FCM_SERVICE_ACCOUNT (servis hesabı JSON'u).
// FCM_SERVICE_ACCOUNT yoksa 503 döner; push kurulana kadar görev yazmayı
// etkilemez.
//
// Alıcı atandığı işletmenin etkin üyesi olmalı. Bildirim dili kullanıcının
// `user_metadata.locale` değeri (yoksa Türkçe). Bildirime dokununca
// uygulama `data.task_id` ile görevi açar. Geçersiz token'lar silinir.

import { createClient } from "npm:@supabase/supabase-js@2";
import { accessToken, type ServiceAccount, send } from "./fcm.ts";
import {
  assignedTask,
  localeOf,
  notificationText,
  type WebhookPayload,
} from "./message.ts";

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

  const expected = Deno.env.get("NOTIFY_SECRET");
  const given = request.headers.get("x-webhook-secret") ?? "";
  if (!expected || !sameSecret(given, expected)) {
    return json({ error: "unauthorized" }, 401);
  }

  const serviceAccountJson = Deno.env.get("FCM_SERVICE_ACCOUNT");
  if (!serviceAccountJson) return json({ error: "push_not_configured" }, 503);

  let payload: WebhookPayload;
  try {
    payload = await request.json();
  } catch {
    return json({ error: "bad_request" }, 400);
  }
  const task = assignedTask(payload);
  if (!task) return json({ sent: 0 });

  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { auth: { persistSession: false } },
  );

  // Alıcı hâlâ işletmenin etkin üyesi mi.
  const { data: membership } = await admin
    .from("memberships")
    .select("id")
    .eq("org_id", task.org_id)
    .eq("user_id", task.assigned_to!)
    .is("deleted_at", null)
    .maybeSingle();
  if (!membership) return json({ sent: 0 });

  const { data: tokens, error } = await admin
    .from("device_tokens")
    .select("token")
    .eq("user_id", task.assigned_to!);
  if (error) return json({ error: "server" }, 500);
  if (!tokens?.length) return json({ sent: 0 });

  const { data: recipient } = await admin.auth.admin.getUserById(
    task.assigned_to!,
  );
  const text = notificationText(
    task,
    localeOf(recipient.user?.user_metadata?.locale),
  );

  const account: ServiceAccount = JSON.parse(serviceAccountJson);
  let access: string;
  try {
    access = await accessToken(account);
  } catch {
    return json({ error: "fcm_auth" }, 502);
  }

  let sent = 0;
  const invalid: string[] = [];
  for (const { token } of tokens) {
    const result = await send(account, token, access, {
      ...text,
      data: { type: "task", task_id: task.id },
    });
    if (result === "sent") sent++;
    if (result === "invalid_token") invalid.push(token);
  }
  if (invalid.length) {
    await admin.from("device_tokens").delete().in("token", invalid);
  }
  return json({ sent });
});
