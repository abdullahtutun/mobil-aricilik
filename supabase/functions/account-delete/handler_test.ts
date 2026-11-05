// account-delete handler testleri: sahte arka uçla (veritabanı, auth,
// Storage, SMTP yok). Çalıştırma: supabase/functions/account-delete
// klasöründe `deno test`.

import { assert, assertEquals } from "jsr:@std/assert@1";
import { type AuthUser, createHandler, type Deps, type RpcError } from "./handler.ts";
import type { Mail } from "./mail.ts";

const workerId = "33333333-3333-3333-3333-333333333333";
const otherId = "99999999-9999-9999-9999-999999999999";
const orgId = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";

interface FakeRequest {
  id: string;
  userId: string;
  status: "bekliyor" | "tamamlandi";
  purged: boolean;
  files: Map<string, Set<string>>;
}

/// Veritabanı fonksiyonlarının, auth'un ve Storage'ın bellek içi taklidi.
class FakeBackend {
  users = new Map<string, AuthUser>();
  jwts = new Map<string, string>();
  requests: FakeRequest[] = [];
  rpcCalls: { fn: string; args: Record<string, unknown> }[] = [];
  signOuts: string[] = [];
  mails: { to: string; mail: Mail }[] = [];
  deletedUsers: string[] = [];
  requestResponse: unknown = null;
  requestError: RpcError | null = null;
  pendingRequest: Record<string, unknown> | null = null;
  /// Son 15 dakikada doğrulanmış silme kodu var mı.
  codeVerified = true;
  codeConsumed = 0;
  /// account_deletion_verify_code yanıtı.
  verifyResult = "ok";
  sendCodeError: RpcError | null = null;
  failDeleteUser = 0;
  failComplete = 0;
  logs: unknown[][] = [];

  addUser(id: string, jwt: string, extra: Partial<AuthUser> = {}) {
    this.users.set(id, {
      id,
      email: `${id.slice(0, 4)}@test.local`,
      isAnonymous: false,
      locale: "tr",
      ...extra,
    });
    this.jwts.set(jwt, id);
  }

  deps(cronSecret?: string): Deps {
    return {
      cronSecret,
      getUserFromJwt: (jwt) => {
        const id = this.jwts.get(jwt);
        return Promise.resolve(id ? this.users.get(id) ?? null : null);
      },
      rpc: <T>(fn: string, args: Record<string, unknown>) => {
        this.rpcCalls.push({ fn, args });
        return Promise.resolve(this.rpc(fn, args) as { data: T | null; error: RpcError | null });
      },
      signOutEverywhere: (jwt) => {
        this.signOuts.push(jwt);
        return Promise.resolve();
      },
      removeObjects: (bucket, paths) => {
        for (const request of this.requests) {
          for (const path of paths) request.files.get(bucket)?.delete(path);
        }
        return Promise.resolve();
      },
      getUserById: (id) => Promise.resolve(this.users.get(id) ?? null),
      deleteUser: (id) => {
        if (this.failDeleteUser > 0) {
          this.failDeleteUser--;
          return Promise.reject(new Error("auth down"));
        }
        this.users.delete(id);
        this.deletedUsers.push(id);
        return Promise.resolve();
      },
      sendMail: (to, mail) => {
        this.mails.push({ to, mail });
        return Promise.resolve();
      },
      log: (...args) => this.logs.push(args),
    };
  }

  private find(args: Record<string, unknown>) {
    return this.requests.find((r) => r.id === args.p_request_id)!;
  }

  private rpc(fn: string, args: Record<string, unknown>): { data: unknown; error: RpcError | null } {
    switch (fn) {
      case "account_deletion_request":
        return { data: this.requestResponse, error: this.requestError };
      case "account_deletion_cancel":
        return { data: true, error: null };
      case "account_deletion_pending":
        return { data: this.pendingRequest, error: null };
      case "account_deletion_code_verified":
        return { data: this.codeVerified, error: null };
      case "account_deletion_consume_code":
        this.codeConsumed++;
        return { data: null, error: null };
      case "account_deletion_send_code":
        return this.sendCodeError
          ? { data: null, error: this.sendCodeError }
          : { data: "482913", error: null };
      case "account_deletion_verify_code":
        return { data: this.verifyResult, error: null };
      case "account_deletion_due":
        return {
          data: this.requests.filter((r) => r.status === "bekliyor").map((r) => ({ id: r.id })),
          error: null,
        };
      case "account_deletion_purge_records": {
        const request = this.find(args);
        if (request.status === "tamamlandi") {
          return { data: { status: "tamamlandi", user_id: null, kind: "hesap" }, error: null };
        }
        request.purged = true;
        // auth kullanıcısı silinince FK talepteki kimliği boşaltır.
        const userId = this.users.has(request.userId) ? request.userId : null;
        return { data: { status: "bekliyor", user_id: userId, kind: "hesap" }, error: null };
      }
      case "account_deletion_storage_objects": {
        const request = this.find(args);
        const rows = [...request.files].flatMap(([bucket, names]) =>
          [...names].map((name) => ({ bucket_id: bucket, name }))
        );
        return { data: request.purged ? rows : [], error: null };
      }
      case "account_deletion_complete": {
        const request = this.find(args);
        if (request.status === "tamamlandi") return { data: false, error: null };
        const filesLeft = [...request.files.values()].some((s) => s.size > 0);
        if (!request.purged || filesLeft || this.users.has(request.userId)) {
          return { data: null, error: { code: "55000", message: "önceki adımlar bitmedi" } };
        }
        if (this.failComplete > 0) {
          this.failComplete--;
          return { data: null, error: { code: "08006", message: "bağlantı koptu" } };
        }
        request.status = "tamamlandi";
        return { data: true, error: null };
      }
      default:
        return { data: null, error: { message: `unknown ${fn}` } };
    }
  }
}

function post(body: unknown, headers: Record<string, string> = {}): Request {
  return new Request("http://localhost/account-delete", {
    method: "POST",
    headers: { "Content-Type": "application/json", ...headers },
    body: JSON.stringify(body),
  });
}

const pendingResponse = {
  request: {
    id: "r1",
    kind: "hesap",
    scheduled_for: "2026-11-12T09:30:00Z",
  },
  counts: { hives: 0, apiaries: 0, inspections: 0, harvests: 0, documents: 0, photos: 0, public_lot_pages: 0 },
  already_pending: false,
};

// ---------------------------------------------------------------------------
// Kimlik doğrulama
// ---------------------------------------------------------------------------

Deno.test("oturumsuz çağrı reddedilir ve veritabanına gitmez", async () => {
  const backend = new FakeBackend();
  const handle = createHandler(backend.deps());

  const response = await handle(post({ action: "request" }));

  assertEquals(response.status, 401);
  assertEquals(backend.rpcCalls.length, 0);
});

Deno.test("geçersiz JWT reddedilir", async () => {
  const backend = new FakeBackend();
  const handle = createHandler(backend.deps());

  const response = await handle(post({ action: "request" }, { Authorization: "Bearer bozuk" }));

  assertEquals(response.status, 401);
  assertEquals(backend.rpcCalls.length, 0);
});

Deno.test("anonim kullanıcının çağrısı reddedilir", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "anon-jwt", { isAnonymous: true, email: null });
  const handle = createHandler(backend.deps());

  const response = await handle(post({ action: "request" }, { Authorization: "Bearer anon-jwt" }));

  assertEquals(response.status, 403);
  assertEquals((await response.json()).error, "anonymous_user");
  assertEquals(backend.rpcCalls.length, 0);
});

Deno.test("cron gizli anahtarı yanlışsa ya da tanımlı değilse reddedilir", async () => {
  const backend = new FakeBackend();

  const wrong = await createHandler(backend.deps("dogru"))(
    post({ action: "purge_due" }, { "x-cron-secret": "yanlis" }),
  );
  const unset = await createHandler(backend.deps())(
    post({ action: "purge_due" }, { "x-cron-secret": "" }),
  );

  assertEquals(wrong.status, 401);
  assertEquals(unset.status, 401);
  assertEquals(backend.rpcCalls.length, 0);
});

Deno.test("kullanıcı kalıcı silmeyi doğrudan başlatamaz", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  const handle = createHandler(backend.deps("gizli"));

  const response = await handle(post({ action: "purge_due" }, { Authorization: "Bearer jwt" }));

  assertEquals(response.status, 400);
  assertEquals(backend.rpcCalls.length, 0);
});

// ---------------------------------------------------------------------------
// Talep ve iptal
// ---------------------------------------------------------------------------

Deno.test("talep JWT'nin kullanıcısı için açılır, oturumlar kapanır, e-posta gider", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  backend.requestResponse = pendingResponse;
  const handle = createHandler(backend.deps());

  const response = await handle(post(
    { action: "request", org_id: orgId, user_id: otherId },
    { Authorization: "Bearer jwt" },
  ));

  assertEquals(response.status, 200);
  assertEquals(await response.json(), pendingResponse);
  assertEquals(backend.rpcCalls.map((c) => c.fn), [
    "account_deletion_code_verified",
    "account_deletion_request",
    "account_deletion_consume_code",
  ]);
  assertEquals(backend.rpcCalls.slice(1, 2), [{
    fn: "account_deletion_request",
    args: {
      p_user_id: workerId,
      p_email: "3333@test.local",
      p_org_id: orgId,
      p_delete_organization: false,
      p_channel: "uygulama",
      p_transfer_to: null,
    },
  }]);
  assertEquals(backend.signOuts, ["jwt"]);
  assertEquals(backend.mails.length, 1);
  assertEquals(backend.mails[0].to, "3333@test.local");
  assert(backend.mails[0].mail.text.includes("12 Kasım 2026 12:30 (TSİ)"));
  assert(backend.mails[0].mail.text.includes("giriş yap ve hesabını korumak istediğini onayla"));
});

Deno.test("sahiplik devri ortağın kimliğiyle RPC'ye gider", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  backend.requestResponse = pendingResponse;
  const handle = createHandler(backend.deps());

  const response = await handle(post(
    { action: "request", org_id: orgId, transfer_to: otherId },
    { Authorization: "Bearer jwt" },
  ));

  assertEquals(response.status, 200);
  const call = backend.rpcCalls.find((c) => c.fn === "account_deletion_request")!;
  assertEquals(call.args.p_transfer_to, otherId);
  assertEquals(call.args.p_delete_organization, false);
});

Deno.test("devir hedefi uygun değilse 422 alır, oturumlar kapanmaz", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  backend.requestError = { code: "DL422", message: "ortak değil" };
  const handle = createHandler(backend.deps());

  const response = await handle(post(
    { action: "request", org_id: orgId, transfer_to: otherId },
    { Authorization: "Bearer jwt" },
  ));

  assertEquals(response.status, 422);
  assertEquals(await response.json(), { error: "invalid_transfer_target" });
  assertEquals(backend.signOuts.length, 0);
  assertEquals(backend.mails.length, 0);
});

Deno.test("status bekleyen talebi ya da null döner, talebi iptal etmez", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  const handle = createHandler(backend.deps());
  const auth = { Authorization: "Bearer jwt" };

  const none = await handle(post({ action: "status" }, auth));
  assertEquals(none.status, 200);
  assertEquals(await none.json(), { request: null });

  backend.pendingRequest = { id: "r1", status: "bekliyor", scheduled_for: "2026-11-12T09:30:00Z" };
  const pending = await handle(post({ action: "status" }, auth));
  assertEquals(await pending.json(), { request: backend.pendingRequest });
  assertEquals(backend.rpcCalls.map((c) => c.fn), ["account_deletion_pending", "account_deletion_pending"]);
  assertEquals(backend.rpcCalls[0].args, { p_user_id: workerId });
  assertEquals(backend.signOuts.length, 0);
});

Deno.test("bekleyen talep tekrar istenirse e-posta yinelenmez, oturumlar yine kapanır", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  backend.requestResponse = { ...pendingResponse, already_pending: true };
  const handle = createHandler(backend.deps());

  const response = await handle(post({ action: "request" }, { Authorization: "Bearer jwt" }));

  assertEquals(response.status, 200);
  assertEquals(backend.signOuts, ["jwt"]);
  assertEquals(backend.mails.length, 0);
});

Deno.test("devir yapılmadan owner'ın talebi 409 ile işletmeleri döner", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  backend.requestError = { code: "DL409", message: "ekip var", details: `${orgId}` };
  const handle = createHandler(backend.deps());

  const response = await handle(post({ action: "request" }, { Authorization: "Bearer jwt" }));

  assertEquals(response.status, 409);
  assertEquals(await response.json(), { error: "owner_must_transfer", org_ids: [orgId] });
  assertEquals(backend.signOuts.length, 0);
  assertEquals(backend.mails.length, 0);
});

Deno.test("sık tekrarlanan talep 429 alır", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  backend.requestError = { code: "DL429", message: "çok fazla" };
  const handle = createHandler(backend.deps());

  const response = await handle(post({ action: "request" }, { Authorization: "Bearer jwt" }));

  assertEquals(response.status, 429);
  assertEquals(backend.signOuts.length, 0);
});

Deno.test("geçersiz girdi 400 alır", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  const handle = createHandler(backend.deps());
  const auth = { Authorization: "Bearer jwt" };

  for (
    const body of [
      { action: "request", delete_organization: true },
      { action: "request", org_id: "bozuk" },
      { action: "request", channel: "sms" },
      { action: "request", transfer_to: otherId },
      { action: "request", org_id: orgId, transfer_to: "bozuk" },
      { action: "request", org_id: orgId, transfer_to: otherId, delete_organization: true },
      { action: "bilinmeyen" },
    ]
  ) {
    assertEquals((await handle(post(body, auth))).status, 400, JSON.stringify(body));
  }
  assertEquals(backend.rpcCalls.length, 0);
});

Deno.test("iptal yalnız JWT'nin kullanıcısının talebini iptal eder", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  const handle = createHandler(backend.deps());

  const response = await handle(post(
    { action: "cancel", user_id: otherId },
    { Authorization: "Bearer jwt" },
  ));

  assertEquals(await response.json(), { cancelled: true });
  assertEquals(backend.rpcCalls, [{ fn: "account_deletion_cancel", args: { p_user_id: workerId } }]);
});

// ---------------------------------------------------------------------------
// Kalıcı silme (cron)
// ---------------------------------------------------------------------------

function dueRequest(backend: FakeBackend, locale = "tr"): FakeRequest {
  backend.addUser(workerId, "jwt", { locale });
  const request: FakeRequest = {
    id: "r1",
    userId: workerId,
    status: "bekliyor",
    purged: false,
    files: new Map([
      ["media", new Set(["org/hive/1.jpg", "org/hive/2.jpg"])],
      ["public-lots", new Set(["lot/report.pdf"])],
    ]),
  };
  backend.requests.push(request);
  return request;
}

const cron = { "x-cron-secret": "gizli" };

Deno.test("cron süresi dolanı sırayla siler: kayıtlar, Storage, en son auth", async () => {
  const backend = new FakeBackend();
  const request = dueRequest(backend, "en-US");
  const handle = createHandler(backend.deps("gizli"));

  const response = await handle(post({ action: "purge_due" }, cron));

  assertEquals(await response.json(), { completed: 1, failed: 0 });
  assertEquals(request.status, "tamamlandi");
  assertEquals([...request.files.values()].every((s) => s.size === 0), true);
  assertEquals(backend.deletedUsers, [workerId]);
  assertEquals(
    backend.rpcCalls.map((c) => c.fn),
    [
      "account_deletion_due",
      "account_deletion_purge_records",
      "account_deletion_storage_objects",
      "account_deletion_storage_objects",
      "account_deletion_complete",
    ],
  );
  assertEquals(backend.mails.length, 1);
  assertEquals(backend.mails[0].mail.subject, "Your Mobil Arıcı account has been deleted");
});

Deno.test("auth silmesinde kesilen silme sonraki turda tamamlanır", async () => {
  const backend = new FakeBackend();
  const request = dueRequest(backend);
  backend.failDeleteUser = 1;
  const handle = createHandler(backend.deps("gizli"));

  const first = await handle(post({ action: "purge_due" }, cron));

  assertEquals(await first.json(), { completed: 0, failed: 1 });
  assertEquals(request.status, "bekliyor");
  assertEquals(backend.users.has(workerId), true);
  assertEquals(backend.mails.length, 0);

  const second = await handle(post({ action: "purge_due" }, cron));

  assertEquals(await second.json(), { completed: 1, failed: 0 });
  assertEquals(request.status, "tamamlandi");
  assertEquals(backend.users.has(workerId), false);
  assertEquals(backend.mails.length, 1);
  assertEquals(backend.mails[0].mail.subject, "Mobil Arıcı hesabın silindi");

  const third = await handle(post({ action: "purge_due" }, cron));
  assertEquals(await third.json(), { completed: 0, failed: 0 });
});

Deno.test("auth silindikten sonra kesilen silme kullanıcıyı yeniden aramadan tamamlanır", async () => {
  const backend = new FakeBackend();
  const request = dueRequest(backend);
  backend.failComplete = 1;
  const handle = createHandler(backend.deps("gizli"));

  const first = await handle(post({ action: "purge_due" }, cron));
  assertEquals(await first.json(), { completed: 0, failed: 1 });
  assertEquals(backend.deletedUsers, [workerId]);

  const second = await handle(post({ action: "purge_due" }, cron));

  assertEquals(await second.json(), { completed: 1, failed: 0 });
  assertEquals(request.status, "tamamlandi");
  assertEquals(backend.deletedUsers, [workerId]);
});

Deno.test("silinemeyen Storage dosyası talebi tamamlatmaz", async () => {
  const backend = new FakeBackend();
  const request = dueRequest(backend);
  const deps = backend.deps("gizli");
  deps.removeObjects = () => Promise.resolve(); // sessizce silmiyor
  const handle = createHandler(deps);

  const response = await handle(post({ action: "purge_due" }, cron));

  assertEquals(await response.json(), { completed: 0, failed: 1 });
  assertEquals(request.status, "bekliyor");
  assertEquals(backend.deletedUsers, []);
});

// ---------------------------------------------------------------------------
// Silme kodu
// ---------------------------------------------------------------------------

Deno.test("doğrulanmış kod yoksa talep açılmaz, oturumlar kapanmaz", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  backend.codeVerified = false;
  const handle = createHandler(backend.deps());

  const response = await handle(post({ action: "request" }, { Authorization: "Bearer jwt" }));

  assertEquals(response.status, 403);
  assertEquals(await response.json(), { error: "code_required" });
  assertEquals(backend.rpcCalls.map((c) => c.fn), ["account_deletion_code_verified"]);
  assertEquals(backend.signOuts.length, 0);
  assertEquals(backend.codeConsumed, 0);
});

Deno.test("reddedilen talepte kod tüketilmez", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  backend.requestError = { code: "DL409", message: "ekip var", details: orgId };
  const handle = createHandler(backend.deps());

  await handle(post({ action: "request" }, { Authorization: "Bearer jwt" }));

  assertEquals(backend.codeConsumed, 0);
});

Deno.test("kod silme e-postasıyla gider, giriş kodu demez", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  const handle = createHandler(backend.deps());

  const response = await handle(post({ action: "send_code" }, { Authorization: "Bearer jwt" }));

  assertEquals(response.status, 200);
  assertEquals(backend.rpcCalls[0], {
    fn: "account_deletion_send_code",
    args: { p_user_id: workerId },
  });
  const { to, mail } = backend.mails[0];
  assertEquals(to, "3333@test.local");
  assertEquals(mail.subject, "Mobil Arıcı hesap silme kodun");
  assert(mail.text.includes("482913"));
  assert(!mail.text.toLowerCase().includes("giriş kod"));
});

Deno.test("sık kod isteği 429 alır, e-posta gitmez", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  backend.sendCodeError = { code: "DL429", message: "çok sık" };
  const handle = createHandler(backend.deps());

  const response = await handle(post({ action: "send_code" }, { Authorization: "Bearer jwt" }));

  assertEquals(response.status, 429);
  assertEquals(backend.mails.length, 0);
});

Deno.test("kod doğrulama: doğru, yanlış, kilitli, biçimsiz", async () => {
  const backend = new FakeBackend();
  backend.addUser(workerId, "jwt");
  const handle = createHandler(backend.deps());
  const auth = { Authorization: "Bearer jwt" };

  const ok = await handle(post({ action: "verify_code", code: "482913" }, auth));
  assertEquals(ok.status, 200);
  assertEquals(await ok.json(), { verified: true });
  assertEquals(backend.rpcCalls[0].args, { p_user_id: workerId, p_code: "482913" });

  backend.verifyResult = "invalid";
  assertEquals((await handle(post({ action: "verify_code", code: "111111" }, auth))).status, 400);
  backend.verifyResult = "expired";
  assertEquals((await handle(post({ action: "verify_code", code: "111111" }, auth))).status, 400);
  backend.verifyResult = "too_many";
  assertEquals((await handle(post({ action: "verify_code", code: "111111" }, auth))).status, 429);

  const calls = backend.rpcCalls.length;
  assertEquals((await handle(post({ action: "verify_code", code: "12ab" }, auth))).status, 400);
  assertEquals(backend.rpcCalls.length, calls);
});
