// device-token: Telefonun FCM token'ını kaydeder ya da siler.
//
// İstek: POST { action, token, platform? }, çağıranın JWT'siyle.
//  - register   { token, platform }  Token çağıran kullanıcıya yazılır. Token
//               başka kullanıcıdaysa ona geçer (aynı telefona başka kullanıcı
//               girdi). → { ok: true }
//  - unregister { token }            Yalnız çağıranın token'ı silinir.
//
// `device_tokens` istemciden yazılamaz; yazma service role ile yapılır.

import { createClient } from "npm:@supabase/supabase-js@2";

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
  const token = body.token;
  if (typeof token !== "string" || token.length < 1 || token.length > 4096) {
    return json({ error: "bad_request" }, 400);
  }

  switch (body.action) {
    case "register": {
      if (body.platform !== "android" && body.platform !== "ios") {
        return json({ error: "bad_request" }, 400);
      }
      const { error } = await admin.from("device_tokens").upsert(
        {
          user_id: userId,
          token,
          platform: body.platform,
          updated_at: new Date().toISOString(),
        },
        { onConflict: "token" },
      );
      if (error) return json({ error: "server" }, 500);
      return json({ ok: true });
    }
    case "unregister": {
      const { error } = await admin
        .from("device_tokens")
        .delete()
        .eq("token", token)
        .eq("user_id", userId);
      if (error) return json({ error: "server" }, 500);
      return json({ ok: true });
    }
    default:
      return json({ error: "bad_request" }, 400);
  }
});
