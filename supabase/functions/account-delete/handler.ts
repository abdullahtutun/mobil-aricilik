// account-delete'in istek işleyicisi. Ağ ve veritabanı erişimi `Deps`
// üzerinden gelir; testler sahte bağımlılıkla çalışır (handler_test.ts).
//
// Kullanıcı istekleri: POST { action, ... }, `Authorization: Bearer <JWT>`.
// JWT auth sunucusunda doğrulanır; oturumsuz ve anonim çağrı reddedilir.
// İşlemler hep JWT'nin kullanıcısı için yapılır; gövdedeki kullanıcı
// kimliği yok sayılır.
//  - request { org_id?, delete_organization?, channel? }  Silme talebi.
//      → 200 { request, counts, already_pending }. Hatalar: 409
//      owner_must_transfer { org_ids }, 429 rate_limited, 403 forbidden,
//      400 bad_request. Talepte tüm oturumlar kapanır (bekleyen talepte de
//      yeniden denenir); yeni talepte "silinecek" e-postası gider.
//  - cancel  → 200 { cancelled }. Giriş yapmak da talebi iptal eder
//      (auth.sessions tetikleyicisi); bu, oturum açıkken iptal yoludur.
//
// Kalıcı silme: pg_cron `x-cron-secret` başlığıyla POST { action:
// "purge_due" } yollar. Süresi dolan her talep için sırayla: kayıtlar, Storage
// dosyaları, auth kullanıcısı, silme kaydı; sonra kısa onay e-postası. Bir
// talep yarıda kesilirse sonraki turda aynı adımlar yeniden çalışır ve
// kaldığı yerden tamamlanır.

import { completedMail, type Mail, mailLocale, requestedMail } from "./mail.ts";

export interface AuthUser {
  id: string;
  email: string | null;
  isAnonymous: boolean;
  locale: unknown;
}

export interface RpcError {
  code?: string;
  message: string;
  details?: string | null;
}

export interface RpcResult<T> {
  data: T | null;
  error: RpcError | null;
}

export interface Deps {
  /// ACCOUNT_DELETE_CRON_SECRET; yoksa cron çağrısı kabul edilmez.
  cronSecret?: string;
  /// JWT'yi auth sunucusunda doğrular; geçersizse null.
  getUserFromJwt(jwt: string): Promise<AuthUser | null>;
  /// Service role ile RPC.
  rpc<T>(fn: string, args: Record<string, unknown>): Promise<RpcResult<T>>;
  /// Kullanıcının tüm oturumlarını kapatır.
  signOutEverywhere(jwt: string): Promise<void>;
  removeObjects(bucket: string, paths: string[]): Promise<void>;
  /// Kullanıcı yoksa null.
  getUserById(id: string): Promise<AuthUser | null>;
  /// auth.admin.deleteUser; kullanıcı zaten yoksa da başarılı.
  deleteUser(id: string): Promise<void>;
  /// SMTP kurulmamışsa sessizce geçer.
  sendMail(to: string, mail: Mail): Promise<void>;
  log(...args: unknown[]): void;
}

const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const channels = new Set(["uygulama", "web"]);
const storageBatch = 1000;
const maxStorageRounds = 100;
const purgeBatch = 20;

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

function bearer(request: Request): string | null {
  const header = request.headers.get("Authorization") ?? "";
  const match = /^Bearer\s+(\S+)$/i.exec(header);
  return match ? match[1] : null;
}

interface RequestResult {
  request: { id: string; kind: string; scheduled_for: string };
  counts: Record<string, number>;
  already_pending: boolean;
}

interface PurgeRecordsResult {
  status: string;
  user_id: string | null;
  kind: string;
}

export type PurgeOutcome = "completed" | "already_completed";

/// Tek bir talebin kalıcı silmesi. Her adım tekrar çalıştırılabilir; hata
/// fırlatırsa talep "bekliyor" kalır ve sonraki turda yeniden denenir.
export async function purgeRequest(
  deps: Deps,
  requestId: string,
): Promise<PurgeOutcome> {
  // 1. Veritabanı kayıtları (işletme, üyelik, görüş, token, davet).
  const records = await deps.rpc<PurgeRecordsResult>(
    "account_deletion_purge_records",
    { p_request_id: requestId },
  );
  if (records.error || !records.data) {
    throw new Error(`purge_records: ${records.error?.message ?? "no data"}`);
  }
  if (records.data.status === "tamamlandi") return "already_completed";

  // 2. Storage dosyaları: liste boşalana kadar.
  let previous = "";
  for (let round = 0;; round++) {
    if (round >= maxStorageRounds) throw new Error("storage: too many rounds");
    const objects = await deps.rpc<{ bucket_id: string; name: string }[]>(
      "account_deletion_storage_objects",
      { p_request_id: requestId, p_limit: storageBatch },
    );
    if (objects.error) throw new Error(`storage_objects: ${objects.error.message}`);
    const rows = objects.data ?? [];
    if (rows.length === 0) break;
    const signature = JSON.stringify(rows);
    if (signature === previous) throw new Error("storage: objects not removed");
    previous = signature;
    const byBucket = new Map<string, string[]>();
    for (const row of rows) {
      byBucket.set(row.bucket_id, [...(byBucket.get(row.bucket_id) ?? []), row.name]);
    }
    for (const [bucket, paths] of byBucket) {
      await deps.removeObjects(bucket, paths);
    }
  }

  // 3. En son auth kullanıcısı. Onay e-postası için adres önce alınır.
  let recipient: AuthUser | null = null;
  const userId = records.data.user_id;
  if (userId) {
    recipient = await deps.getUserById(userId);
    if (recipient) await deps.deleteUser(userId);
  }

  // 4. Silme kaydı ve talebin tamamlanması.
  const completed = await deps.rpc<boolean>("account_deletion_complete", {
    p_request_id: requestId,
  });
  if (completed.error) throw new Error(`complete: ${completed.error.message}`);

  if (recipient?.email) {
    try {
      await deps.sendMail(recipient.email, completedMail(mailLocale(recipient.locale)));
    } catch (error) {
      deps.log("account-delete: completion mail failed", error);
    }
  }
  return completed.data ? "completed" : "already_completed";
}

async function purgeDue(deps: Deps): Promise<Response> {
  const due = await deps.rpc<{ id: string }[]>("account_deletion_due", {
    p_limit: purgeBatch,
  });
  if (due.error) {
    deps.log("account-delete: due", due.error);
    return json({ error: "server" }, 500);
  }
  let completed = 0;
  let failed = 0;
  for (const { id } of due.data ?? []) {
    try {
      await purgeRequest(deps, id);
      completed++;
    } catch (error) {
      // Talep bekliyor kalır; sonraki cron turu kaldığı yerden sürdürür.
      deps.log("account-delete: purge failed", id, error);
      failed++;
    }
  }
  return json({ completed, failed });
}

async function requestDeletion(
  deps: Deps,
  user: AuthUser,
  jwt: string,
  // deno-lint-ignore no-explicit-any
  body: Record<string, any>,
): Promise<Response> {
  const orgId = body.org_id ?? null;
  const deleteOrganization = body.delete_organization ?? false;
  const channel = body.channel ?? "uygulama";
  if (
    (orgId !== null && (typeof orgId !== "string" || !uuid.test(orgId))) ||
    typeof deleteOrganization !== "boolean" ||
    !channels.has(channel) ||
    (deleteOrganization && orgId === null)
  ) {
    return json({ error: "bad_request" }, 400);
  }

  const { data, error } = await deps.rpc<RequestResult>("account_deletion_request", {
    p_user_id: user.id,
    p_email: user.email,
    p_org_id: orgId,
    p_delete_organization: deleteOrganization,
    p_channel: channel,
  });
  if (error || !data) {
    switch (error?.code) {
      case "DL409":
        return json({
          error: "owner_must_transfer",
          org_ids: (error.details ?? "").split(",").filter(Boolean),
        }, 409);
      case "DL429":
        return json({ error: "rate_limited" }, 429);
      case "42501":
        return json({ error: "forbidden" }, 403);
      case "22023":
        return json({ error: "bad_request" }, 400);
      default:
        deps.log("account-delete: request", error);
        return json({ error: "server" }, 500);
    }
  }

  // Tüm oturumlar kapanır. Başarısızsa istemci yeniden dener; bekleyen
  // talep yeniden yazılmaz, yalnız oturum kapatma tekrarlanır.
  try {
    await deps.signOutEverywhere(jwt);
  } catch (signOutError) {
    deps.log("account-delete: sign out failed", signOutError);
    return json({ error: "sign_out_failed", ...data }, 502);
  }

  if (!data.already_pending && user.email) {
    try {
      await deps.sendMail(
        user.email,
        requestedMail(
          data.request.scheduled_for,
          data.request.kind === "hesap_ve_isletme",
          mailLocale(user.locale),
        ),
      );
    } catch (mailError) {
      deps.log("account-delete: request mail failed", mailError);
    }
  }
  return json(data);
}

export function createHandler(deps: Deps): (request: Request) => Promise<Response> {
  return async (request) => {
    if (request.method !== "POST") return json({ error: "method" }, 405);

    // deno-lint-ignore no-explicit-any
    let body: Record<string, any>;
    try {
      body = await request.json();
    } catch {
      body = {};
    }

    const cronHeader = request.headers.get("x-cron-secret");
    if (cronHeader !== null) {
      if (!deps.cronSecret || !sameSecret(cronHeader, deps.cronSecret)) {
        return json({ error: "unauthorized" }, 401);
      }
      if (body.action !== "purge_due") return json({ error: "bad_request" }, 400);
      return purgeDue(deps);
    }

    const jwt = bearer(request);
    if (!jwt) return json({ error: "unauthorized" }, 401);
    const user = await deps.getUserFromJwt(jwt);
    if (!user) return json({ error: "unauthorized" }, 401);
    if (user.isAnonymous) return json({ error: "anonymous_user" }, 403);

    switch (body.action) {
      case "request":
        return requestDeletion(deps, user, jwt, body);
      case "cancel": {
        const { data, error } = await deps.rpc<boolean>("account_deletion_cancel", {
          p_user_id: user.id,
        });
        if (error) {
          deps.log("account-delete: cancel", error);
          return json({ error: "server" }, 500);
        }
        return json({ cancelled: data === true });
      }
      default:
        return json({ error: "bad_request" }, 400);
    }
  };
}
