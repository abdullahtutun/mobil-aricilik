// invite: Ekip daveti ve üyelik yönetimi. Hepsi online çalışır.
//
// İstek: POST { action, ... }, çağıranın JWT'siyle.
//  - create   { org_id, role }  Owner/partner 6 haneli, 48 saat geçerli kod
//             üretir (role: partner | worker | viewer). → { code, role,
//             expires_at }
//  - redeem   { code }          Kodu kullanır, kodun rolüyle `memberships`'e
//             satır ekler. → { org_id, role }. Hatalar: 404 invalid_code
//             (yok, süresi dolmuş ya da kullanılmış; ayrım yapılmaz), 409
//             already_member.
//  - members  { org_id }        İşletmenin üyeleri e-postalarıyla (üyeler
//             çağırır). → { members: [{ user_id, email }] }
//  - set_role { org_id, user_id, role }  Yalnız owner; owner'ın rolü ve
//             owner'ın kendisi değişmez (işletme owner'sız kalmasın).
//  - remove   { org_id, user_id }        Yalnız owner; üyelik yumuşak silinir.
//
// Üyelik yazmaları service role ile yapılır; çağıranın yetkisi önce kendi
// JWT'siyle (RLS) doğrulanır.

import { createClient } from "npm:@supabase/supabase-js@2";
import { generateCode, isCode, isInviteRole, normalizeCode } from "./code.ts";

const ttlMs = 48 * 60 * 60 * 1000;
const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

Deno.serve(async (request) => {
  if (request.method !== "POST") return json({ error: "method" }, 405);
  const authorization = request.headers.get("Authorization");
  if (!authorization) return json({ error: "unauthorized" }, 401);

  const url = Deno.env.get("SUPABASE_URL")!;
  const user = createClient(url, Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: authorization } },
    auth: { persistSession: false },
  });
  const admin = createClient(url, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
    auth: { persistSession: false },
  });

  const { data: auth, error: authError } = await user.auth.getUser();
  if (authError || !auth.user) return json({ error: "unauthorized" }, 401);
  const userId = auth.user.id;

  // deno-lint-ignore no-explicit-any
  let body: Record<string, any>;
  try {
    body = await request.json();
  } catch {
    return json({ error: "bad_request" }, 400);
  }

  /// Çağıranın işletmedeki etkin rolü; üye değilse null.
  async function roleOf(orgId: string): Promise<string | null> {
    const { data } = await user
      .from("memberships")
      .select("role")
      .eq("org_id", orgId)
      .eq("user_id", userId)
      .is("deleted_at", null)
      .maybeSingle();
    return data?.role ?? null;
  }

  const orgId = body.org_id;
  switch (body.action) {
    case "create": {
      if (typeof orgId !== "string" || !uuid.test(orgId)) {
        return json({ error: "bad_request" }, 400);
      }
      if (!isInviteRole(body.role)) return json({ error: "bad_role" }, 400);
      const role = await roleOf(orgId);
      if (role !== "owner" && role !== "partner") {
        return json({ error: "forbidden" }, 403);
      }
      // Kullanıcının JWT'siyle yazılır: insert politikası yetkiyi bir kez
      // daha denetler. Kod çakışırsa (23505) yenisi denenir.
      for (let attempt = 0; attempt < 5; attempt++) {
        const code = generateCode();
        const expiresAt = new Date(Date.now() + ttlMs).toISOString();
        const { error } = await user.from("invites").insert({
          org_id: orgId,
          code,
          role: body.role,
          expires_at: expiresAt,
        });
        if (!error) return json({ code, role: body.role, expires_at: expiresAt });
        if (error.code !== "23505") {
          console.error(error);
          return json({ error: "server" }, 500);
        }
      }
      return json({ error: "server" }, 500);
    }

    case "redeem": {
      const code = typeof body.code === "string" ? normalizeCode(body.code) : "";
      if (!isCode(code)) return json({ error: "invalid_code" }, 404);

      // Kullanılmamış ve süresi dolmamış kodu tek ifadede "alır"; iki kişi
      // aynı kodu aynı anda giremez.
      const { data: claimed, error: claimError } = await admin
        .from("invites")
        .update({ used_at: new Date().toISOString(), used_by: userId })
        .eq("code", code)
        .is("used_at", null)
        .gt("expires_at", new Date().toISOString())
        .select("id, org_id, role")
        .maybeSingle();
      if (claimError) {
        console.error(claimError);
        return json({ error: "server" }, 500);
      }
      if (!claimed) return json({ error: "invalid_code" }, 404);

      /// Katılım olmadıysa kod yeniden kullanılabilsin.
      const release = () =>
        admin.from("invites").update({ used_at: null, used_by: null }).eq(
          "id",
          claimed.id,
        );

      const { data: existing } = await admin
        .from("memberships")
        .select("id")
        .eq("org_id", claimed.org_id)
        .eq("user_id", userId)
        .is("deleted_at", null)
        .maybeSingle();
      if (existing) {
        await release();
        return json({ error: "already_member" }, 409);
      }

      const { error: insertError } = await admin.from("memberships").insert({
        id: crypto.randomUUID(),
        org_id: claimed.org_id,
        user_id: userId,
        role: claimed.role,
        created_by: userId,
      });
      if (insertError) {
        console.error(insertError);
        await release();
        return json({ error: "server" }, 500);
      }
      return json({ org_id: claimed.org_id, role: claimed.role });
    }

    case "members": {
      if (typeof orgId !== "string" || !uuid.test(orgId)) {
        return json({ error: "bad_request" }, 400);
      }
      if (!(await roleOf(orgId))) return json({ error: "forbidden" }, 403);
      const { data: rows, error } = await admin
        .from("memberships")
        .select("user_id")
        .eq("org_id", orgId)
        .is("deleted_at", null);
      if (error) {
        console.error(error);
        return json({ error: "server" }, 500);
      }
      const members = await Promise.all(
        (rows ?? []).map(async ({ user_id }: { user_id: string }) => {
          const { data } = await admin.auth.admin.getUserById(user_id);
          return { user_id, email: data.user?.email ?? null };
        }),
      );
      return json({ members });
    }

    case "set_role":
    case "remove": {
      const target = body.user_id;
      if (
        typeof orgId !== "string" || !uuid.test(orgId) ||
        typeof target !== "string" || !uuid.test(target)
      ) {
        return json({ error: "bad_request" }, 400);
      }
      if (body.action === "set_role" && !isInviteRole(body.role)) {
        return json({ error: "bad_role" }, 400);
      }
      if ((await roleOf(orgId)) !== "owner") {
        return json({ error: "forbidden" }, 403);
      }
      const { data: membership } = await admin
        .from("memberships")
        .select("id, role")
        .eq("org_id", orgId)
        .eq("user_id", target)
        .is("deleted_at", null)
        .maybeSingle();
      if (!membership) return json({ error: "not_found" }, 404);
      if (membership.role === "owner") {
        return json({ error: "owner_locked" }, 409);
      }
      const change = body.action === "set_role"
        ? { role: body.role }
        : { deleted_at: new Date().toISOString() };
      const { error } = await admin
        .from("memberships")
        .update({ ...change, updated_at: new Date().toISOString() })
        .eq("id", membership.id);
      if (error) {
        console.error(error);
        return json({ error: "server" }, 500);
      }
      return json({ ok: true });
    }

    default:
      return json({ error: "bad_request" }, 400);
  }
});
