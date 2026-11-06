// account-delete'in e-posta metinleri, her desteklenen dilde. Saf
// fonksiyonlar.

import { type AppLocale, pickLocale } from "../_shared/locale.ts";

export type MailLocale = AppLocale;

export interface Mail {
  subject: string;
  text: string;
}

/// Kullanıcının dili `user_metadata.locale`'den; yoksa ya da
/// desteklenmiyorsa İngilizce.
export const mailLocale = pickLocale;

/// Tarih biçimi: Türkçede Türkiye saatiyle (TSİ), diğer dillerde UTC.
const dateFormats: Record<MailLocale, { intl: string; timeZone: string; suffix: string }> = {
  tr: { intl: "tr-TR", timeZone: "Europe/Istanbul", suffix: "(TSİ)" },
  en: { intl: "en-GB", timeZone: "UTC", suffix: "UTC" },
  de: { intl: "de-DE", timeZone: "UTC", suffix: "UTC" },
  es: { intl: "es-ES", timeZone: "UTC", suffix: "UTC" },
};

/// Silme anı: Türkçede Türkiye saatiyle, diğer dillerde UTC.
export function formatDeletionDate(iso: string, locale: MailLocale): string {
  const { intl, timeZone, suffix } = dateFormats[locale];
  const text = new Intl.DateTimeFormat(intl, {
    dateStyle: "long",
    timeStyle: "short",
    timeZone,
  }).format(new Date(iso));
  return `${text} ${suffix}`;
}

interface MailText {
  requestedSubject: string;
  requestedIntro: string;
  /// İşletmeyle birlikte silinecekse.
  requestedWithOrganization: (when: string) => string;
  requestedAccountOnly: (when: string) => string;
  requestedChangedMind: string;
  requestedNotYou: string;
  codeSubject: string;
  codeIntro: string;
  codeEnter: (code: string) => string;
  codeValidity: string;
  codeNotYou: string;
  completedSubject: string;
  completedText: string;
}

const text: Record<MailLocale, MailText> = {
  tr: {
    requestedSubject: "Mobil Arıcı hesabın silinecek",
    requestedIntro: "Mobil Arıcı hesabını silme talebini aldık.",
    requestedWithOrganization: (when) =>
      `Hesabın, işletmen ve işletmenin tüm kayıtları ${when} tarihinde kalıcı olarak silinecek.`,
    requestedAccountOnly: (when) =>
      `Hesabın ${when} tarihinde kalıcı olarak silinecek. Girdiğin işletme kayıtları işletmede kalır.`,
    requestedChangedMind:
      "Vazgeçtiysen bu tarihten önce uygulamaya giriş yap ve hesabını korumak istediğini onayla.",
    requestedNotYou: "Bu talebi sen yapmadıysan hemen giriş yap.",
    codeSubject: "Mobil Arıcı hesap silme kodun",
    codeIntro: "Mobil Arıcı hesabını silmek istedin.",
    codeEnter: (code) => `Onaylamak için bu kodu uygulamaya gir: ${code}`,
    codeValidity: "Kod 10 dakika geçerli ve bir kez kullanılabilir. Kodu kimseyle paylaşma.",
    codeNotYou: "Bunu sen istemediysen bu e-postayı yok say; hesabın silinmez.",
    completedSubject: "Mobil Arıcı hesabın silindi",
    completedText:
      "Mobil Arıcı hesabın isteğin üzerine kalıcı olarak silindi. Mobil Arıcı'yı kullandığın için teşekkürler.",
  },
  en: {
    requestedSubject: "Your Mobil Arıcı account will be deleted",
    requestedIntro: "We received a request to delete your Mobil Arıcı account.",
    requestedWithOrganization: (when) =>
      `Your account, your business and all of its records will be permanently deleted on ${when}.`,
    requestedAccountOnly: (when) =>
      `Your account will be permanently deleted on ${when}. The business records you entered stay with the business.`,
    requestedChangedMind:
      "Changed your mind? Sign in to the app before that date and confirm that you want to keep your account.",
    requestedNotYou: "If you did not make this request, sign in now.",
    codeSubject: "Your Mobil Arıcı account deletion code",
    codeIntro: "You asked to delete your Mobil Arıcı account.",
    codeEnter: (code) => `To confirm, enter this code in the app: ${code}`,
    codeValidity:
      "The code is valid for 10 minutes and can be used once. Don't share it with anyone.",
    codeNotYou: "If you didn't ask for this, ignore this email; your account will not be deleted.",
    completedSubject: "Your Mobil Arıcı account has been deleted",
    completedText:
      "Your Mobil Arıcı account has been permanently deleted as you requested. Thank you for using Mobil Arıcı.",
  },
  de: {
    requestedSubject: "Dein Mobil-Arıcı-Konto wird gelöscht",
    requestedIntro: "Wir haben eine Anfrage zum Löschen deines Mobil-Arıcı-Kontos erhalten.",
    requestedWithOrganization: (when) =>
      `Dein Konto, dein Betrieb und alle seine Einträge werden am ${when} endgültig gelöscht.`,
    requestedAccountOnly: (when) =>
      `Dein Konto wird am ${when} endgültig gelöscht. Die Einträge, die du im Betrieb erfasst hast, bleiben beim Betrieb.`,
    requestedChangedMind:
      "Du hast es dir anders überlegt? Melde dich vor diesem Datum in der App an und bestätige, dass du dein Konto behalten möchtest.",
    requestedNotYou: "Wenn du diese Anfrage nicht gestellt hast, melde dich sofort an.",
    codeSubject: "Dein Code zum Löschen des Mobil-Arıcı-Kontos",
    codeIntro: "Du möchtest dein Mobil-Arıcı-Konto löschen.",
    codeEnter: (code) => `Gib zur Bestätigung diesen Code in der App ein: ${code}`,
    codeValidity:
      "Der Code gilt 10 Minuten und kann einmal verwendet werden. Gib ihn an niemanden weiter.",
    codeNotYou:
      "Wenn du das nicht angefordert hast, ignoriere diese E-Mail; dein Konto wird nicht gelöscht.",
    completedSubject: "Dein Mobil-Arıcı-Konto wurde gelöscht",
    completedText:
      "Dein Mobil-Arıcı-Konto wurde auf deinen Wunsch endgültig gelöscht. Danke, dass du Mobil Arıcı genutzt hast.",
  },
  es: {
    requestedSubject: "Tu cuenta de Mobil Arıcı se eliminará",
    requestedIntro: "Hemos recibido una solicitud para eliminar tu cuenta de Mobil Arıcı.",
    requestedWithOrganization: (when) =>
      `Tu cuenta, tu explotación y todos sus registros se eliminarán definitivamente el ${when}.`,
    requestedAccountOnly: (when) =>
      `Tu cuenta se eliminará definitivamente el ${when}. Los registros que introdujiste se quedan en la explotación.`,
    requestedChangedMind:
      "¿Has cambiado de opinión? Inicia sesión en la app antes de esa fecha y confirma que quieres conservar tu cuenta.",
    requestedNotYou: "Si no has hecho esta solicitud, inicia sesión ahora.",
    codeSubject: "Tu código para eliminar la cuenta de Mobil Arıcı",
    codeIntro: "Has pedido eliminar tu cuenta de Mobil Arıcı.",
    codeEnter: (code) => `Para confirmar, introduce este código en la app: ${code}`,
    codeValidity:
      "El código es válido durante 10 minutos y se puede usar una vez. No lo compartas con nadie.",
    codeNotYou: "Si no lo has pedido tú, ignora este correo; tu cuenta no se eliminará.",
    completedSubject: "Tu cuenta de Mobil Arıcı se ha eliminado",
    completedText:
      "Tu cuenta de Mobil Arıcı se ha eliminado definitivamente, como pediste. Gracias por usar Mobil Arıcı.",
  },
};

/// Talep alındı: "<tarih> tarihinde silinecek, vazgeçmek için giriş yapıp
/// onayla".
export function requestedMail(
  scheduledFor: string,
  withOrganization: boolean,
  locale: MailLocale,
): Mail {
  const t = text[locale];
  const when = formatDeletionDate(scheduledFor, locale);
  return {
    subject: t.requestedSubject,
    text: [
      t.requestedIntro,
      "",
      withOrganization ? t.requestedWithOrganization(when) : t.requestedAccountOnly(when),
      "",
      t.requestedChangedMind,
      t.requestedNotYou,
    ].join("\n"),
  };
}

/// Silme isteğini onaylama kodu (giriş kodu değil).
export function codeMail(code: string, locale: MailLocale): Mail {
  const t = text[locale];
  return {
    subject: t.codeSubject,
    text: [t.codeIntro, "", t.codeEnter(code), "", t.codeValidity, t.codeNotYou].join("\n"),
  };
}

/// Silme tamamlandı: kısa onay.
export function completedMail(locale: MailLocale): Mail {
  const t = text[locale];
  return { subject: t.completedSubject, text: t.completedText };
}
