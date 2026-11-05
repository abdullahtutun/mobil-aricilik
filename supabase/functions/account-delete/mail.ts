// account-delete'in e-posta metinleri (TR ve EN). Saf fonksiyonlar.

export type MailLocale = "tr" | "en";

export interface Mail {
  subject: string;
  text: string;
}

/// Kullanıcının dili: `user_metadata.locale` "en…" ise İngilizce, değilse
/// Türkçe.
export function mailLocale(locale: unknown): MailLocale {
  return typeof locale === "string" && locale.toLowerCase().startsWith("en")
    ? "en"
    : "tr";
}

/// Silme anı: Türkçede Türkiye saatiyle, İngilizcede UTC.
export function formatDeletionDate(iso: string, locale: MailLocale): string {
  const date = new Date(iso);
  if (locale === "tr") {
    const text = new Intl.DateTimeFormat("tr-TR", {
      dateStyle: "long",
      timeStyle: "short",
      timeZone: "Europe/Istanbul",
    }).format(date);
    return `${text} (TSİ)`;
  }
  const text = new Intl.DateTimeFormat("en-GB", {
    dateStyle: "long",
    timeStyle: "short",
    timeZone: "UTC",
  }).format(date);
  return `${text} UTC`;
}

/// Talep alındı: "<tarih> tarihinde silinecek, vazgeçmek için giriş yapıp
/// onayla".
export function requestedMail(
  scheduledFor: string,
  withOrganization: boolean,
  locale: MailLocale,
): Mail {
  const when = formatDeletionDate(scheduledFor, locale);
  if (locale === "en") {
    return {
      subject: "Your Mobil Arıcı account will be deleted",
      text: [
        "We received a request to delete your Mobil Arıcı account.",
        "",
        withOrganization
          ? `Your account, your business and all of its records will be permanently deleted on ${when}.`
          : `Your account will be permanently deleted on ${when}. The business records you entered stay with the business.`,
        "",
        "Changed your mind? Sign in to the app before that date and confirm that you want to keep your account.",
        "If you did not make this request, sign in now.",
      ].join("\n"),
    };
  }
  return {
    subject: "Mobil Arıcı hesabın silinecek",
    text: [
      "Mobil Arıcı hesabını silme talebini aldık.",
      "",
      withOrganization
        ? `Hesabın, işletmen ve işletmenin tüm kayıtları ${when} tarihinde kalıcı olarak silinecek.`
        : `Hesabın ${when} tarihinde kalıcı olarak silinecek. Girdiğin işletme kayıtları işletmede kalır.`,
      "",
      "Vazgeçtiysen bu tarihten önce uygulamaya giriş yap ve hesabını korumak istediğini onayla.",
      "Bu talebi sen yapmadıysan hemen giriş yap.",
    ].join("\n"),
  };
}

/// Silme tamamlandı: kısa onay.
export function completedMail(locale: MailLocale): Mail {
  if (locale === "en") {
    return {
      subject: "Your Mobil Arıcı account has been deleted",
      text:
        "Your Mobil Arıcı account has been permanently deleted as you requested. Thank you for using Mobil Arıcı.",
    };
  }
  return {
    subject: "Mobil Arıcı hesabın silindi",
    text:
      "Mobil Arıcı hesabın isteğin üzerine kalıcı olarak silindi. Mobil Arıcı'yı kullandığın için teşekkürler.",
  };
}
