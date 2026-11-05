// account-delete: hesap ve işletme silme (KVKK). Ayrıntı: handler.ts ve
// supabase/migrations/20261113120000_account_deletion.sql.
//
// `verify_jwt = false`: kullanıcı çağrılarında JWT burada auth sunucusunda
// doğrulanır; pg_cron çağrısı JWT değil `x-cron-secret` taşır.
//
// Secret'lar: ACCOUNT_DELETE_CRON_SECRET (Vault'taki account_delete_secret
// ile aynı), ACCOUNT_MAIL_SMTP_USER + ACCOUNT_MAIL_SMTP_PASS (silme kodu ve
// bilgilendirme e-postalarının posta kutusu, noreply@tutunsoft.com; gönderen
// de bu adres). İkisi birlikte yoksa ortak SMTP_USER + SMTP_PASS kullanılır.
// İsteğe bağlı SMTP_HOST (varsayılan smtp.hostinger.com), SMTP_PORT
// (varsayılan 465). SMTP kurulmamışsa e-posta atlanır, silme yine çalışır.

import { createClient } from "npm:@supabase/supabase-js@2";
import nodemailer from "npm:nodemailer@6.9.16";
import { type AuthUser, createHandler } from "./handler.ts";

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  { auth: { persistSession: false, autoRefreshToken: false } },
);

// deno-lint-ignore no-explicit-any
function toAuthUser(user: any): AuthUser {
  return {
    id: user.id,
    email: user.email ?? null,
    isAnonymous: user.is_anonymous === true,
    locale: user.user_metadata?.locale,
  };
}

// Kendi posta kutusu ancak kullanıcı ve şifre birlikte girilince kullanılır;
// yarım ayar eski kutudan göndermeyi bozmasın.
const ownUser = Deno.env.get("ACCOUNT_MAIL_SMTP_USER");
const ownPass = Deno.env.get("ACCOUNT_MAIL_SMTP_PASS");
const [smtpUser, smtpPass] = ownUser && ownPass
  ? [ownUser, ownPass]
  : [Deno.env.get("SMTP_USER"), Deno.env.get("SMTP_PASS")];
const smtpPort = Number(Deno.env.get("SMTP_PORT") ?? "465");
const transport = smtpUser && smtpPass
  ? nodemailer.createTransport({
    host: Deno.env.get("SMTP_HOST") ?? "smtp.hostinger.com",
    port: smtpPort,
    secure: smtpPort === 465,
    auth: { user: smtpUser, pass: smtpPass },
  })
  : null;

Deno.serve(createHandler({
  cronSecret: Deno.env.get("ACCOUNT_DELETE_CRON_SECRET") || undefined,

  async getUserFromJwt(jwt) {
    const { data, error } = await admin.auth.getUser(jwt);
    if (error || !data.user) return null;
    return toAuthUser(data.user);
  },

  async rpc(fn, args) {
    const { data, error } = await admin.rpc(fn, args);
    return {
      data,
      error: error
        ? { code: error.code, message: error.message, details: error.details }
        : null,
    };
  },

  async signOutEverywhere(jwt) {
    const { error } = await admin.auth.admin.signOut(jwt, "global");
    if (error) throw error;
  },

  async removeObjects(bucket, paths) {
    const { error } = await admin.storage.from(bucket).remove(paths);
    if (error) throw error;
  },

  async getUserById(id) {
    const { data, error } = await admin.auth.admin.getUserById(id);
    if (error) {
      if (error.status === 404) return null;
      throw error;
    }
    return data.user ? toAuthUser(data.user) : null;
  },

  async deleteUser(id) {
    const { error } = await admin.auth.admin.deleteUser(id);
    if (error && error.status !== 404) throw error;
  },

  async sendMail(to, mail) {
    if (!transport) {
      console.warn("account-delete: SMTP not configured, mail skipped");
      return;
    }
    await transport.sendMail({
      from: `Mobil Arıcı <${smtpUser}>`,
      to,
      subject: mail.subject,
      text: mail.text,
    });
  },

  log: (...args) => console.error(...args),
}));
