// FCM HTTP v1: servis hesabıyla OAuth2 erişim anahtarı alır ve mesaj yollar.

export interface ServiceAccount {
  client_email: string;
  private_key: string;
  project_id: string;
}

function base64Url(data: ArrayBuffer | string): string {
  const bytes = typeof data === "string"
    ? new TextEncoder().encode(data)
    : new Uint8Array(data);
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replaceAll("+", "-").replaceAll("/", "_").replace(
    /=+$/,
    "",
  );
}

async function signJwt(account: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = base64Url(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const claims = base64Url(JSON.stringify({
    iss: account.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  }));
  const pem = account.private_key
    .replace(/-----(BEGIN|END) PRIVATE KEY-----/g, "")
    .replace(/\s+/g, "");
  const der = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    "pkcs8",
    der,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(`${header}.${claims}`),
  );
  return `${header}.${claims}.${base64Url(signature)}`;
}

export async function accessToken(account: ServiceAccount): Promise<string> {
  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: await signJwt(account),
    }),
  });
  if (!response.ok) throw new Error(`oauth ${response.status}`);
  return (await response.json()).access_token;
}

export type SendResult = "sent" | "invalid_token" | "failed";

/// Tek token'a bildirim yollar. Token artık geçerli değilse (silinmiş,
/// kaydı düşmüş) "invalid_token" döner; çağıran onu siler.
export async function send(
  account: ServiceAccount,
  token: string,
  accessTokenValue: string,
  message: { title: string; body: string; data: Record<string, string> },
): Promise<SendResult> {
  const response = await fetch(
    `https://fcm.googleapis.com/v1/projects/${account.project_id}/messages:send`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessTokenValue}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message: {
          token,
          notification: { title: message.title, body: message.body },
          data: message.data,
          android: { priority: "high" },
          apns: { payload: { aps: { sound: "default" } } },
        },
      }),
    },
  );
  if (response.ok) return "sent";
  if (response.status === 404) return "invalid_token";
  if (response.status === 400) {
    const detail = await response.text();
    if (detail.includes("INVALID_ARGUMENT") && detail.includes("token")) {
      return "invalid_token";
    }
  }
  return "failed";
}
