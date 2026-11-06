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
  pt: { intl: "pt-BR", timeZone: "UTC", suffix: "UTC" },
  ru: { intl: "ru-RU", timeZone: "UTC", suffix: "UTC" },
  uk: { intl: "uk-UA", timeZone: "UTC", suffix: "UTC" },
  fa: { intl: "fa-IR-u-ca-gregory-nu-latn", timeZone: "UTC", suffix: "UTC" },
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
  pt: {
    requestedSubject: "Sua conta do Mobil Arıcı será excluída",
    requestedIntro: "Recebemos um pedido para excluir sua conta do Mobil Arıcı.",
    requestedWithOrganization: (when) =>
      `Sua conta, seu negócio e todos os registros dele serão excluídos definitivamente em ${when}.`,
    requestedAccountOnly: (when) =>
      `Sua conta será excluída definitivamente em ${when}. Os registros que você lançou continuam no negócio.`,
    requestedChangedMind:
      "Mudou de ideia? Entre no app antes dessa data e confirme que quer manter sua conta.",
    requestedNotYou: "Se você não fez este pedido, entre agora.",
    codeSubject: "Seu código para excluir a conta do Mobil Arıcı",
    codeIntro: "Você pediu para excluir sua conta do Mobil Arıcı.",
    codeEnter: (code) => `Para confirmar, digite este código no app: ${code}`,
    codeValidity:
      "O código vale por 10 minutos e pode ser usado uma vez. Não o compartilhe com ninguém.",
    codeNotYou: "Se não foi você, ignore este e-mail; sua conta não será excluída.",
    completedSubject: "Sua conta do Mobil Arıcı foi excluída",
    completedText:
      "Sua conta do Mobil Arıcı foi excluída definitivamente, como você pediu. Obrigado por usar o Mobil Arıcı.",
  },
  ru: {
    requestedSubject: "Ваш аккаунт Mobil Arıcı будет удалён",
    requestedIntro: "Мы получили запрос на удаление вашего аккаунта Mobil Arıcı.",
    requestedWithOrganization: (when) =>
      `Ваш аккаунт, ваше хозяйство и все его записи будут окончательно удалены ${when}.`,
    requestedAccountOnly: (when) =>
      `Ваш аккаунт будет окончательно удалён ${when}. Внесённые вами записи остаются в хозяйстве.`,
    requestedChangedMind:
      "Передумали? Войдите в приложение до этой даты и подтвердите, что хотите сохранить аккаунт.",
    requestedNotYou: "Если вы не отправляли этот запрос, войдите прямо сейчас.",
    codeSubject: "Код для удаления аккаунта Mobil Arıcı",
    codeIntro: "Вы запросили удаление аккаунта Mobil Arıcı.",
    codeEnter: (code) => `Для подтверждения введите этот код в приложении: ${code}`,
    codeValidity:
      "Код действует 10 минут и может быть использован один раз. Никому его не сообщайте.",
    codeNotYou: "Если вы этого не запрашивали, проигнорируйте письмо; аккаунт не будет удалён.",
    completedSubject: "Ваш аккаунт Mobil Arıcı удалён",
    completedText:
      "Ваш аккаунт Mobil Arıcı окончательно удалён по вашему запросу. Спасибо, что пользовались Mobil Arıcı.",
  },
  uk: {
    requestedSubject: "Ваш обліковий запис Mobil Arıcı буде видалено",
    requestedIntro: "Ми отримали запит на видалення вашого облікового запису Mobil Arıcı.",
    requestedWithOrganization: (when) =>
      `Ваш обліковий запис, ваше господарство та всі його записи буде остаточно видалено ${when}.`,
    requestedAccountOnly: (when) =>
      `Ваш обліковий запис буде остаточно видалено ${when}. Внесені вами записи залишаються в господарстві.`,
    requestedChangedMind:
      "Передумали? Увійдіть у застосунок до цієї дати й підтвердьте, що хочете зберегти обліковий запис.",
    requestedNotYou: "Якщо ви не надсилали цей запит, увійдіть просто зараз.",
    codeSubject: "Код для видалення облікового запису Mobil Arıcı",
    codeIntro: "Ви запросили видалення облікового запису Mobil Arıcı.",
    codeEnter: (code) => `Для підтвердження введіть цей код у застосунку: ${code}`,
    codeValidity:
      "Код діє 10 хвилин і може бути використаний один раз. Нікому його не повідомляйте.",
    codeNotYou: "Якщо ви цього не запитували, проігноруйте лист; обліковий запис не буде видалено.",
    completedSubject: "Ваш обліковий запис Mobil Arıcı видалено",
    completedText:
      "Ваш обліковий запис Mobil Arıcı остаточно видалено на ваш запит. Дякуємо, що користувалися Mobil Arıcı.",
  },
  fa: {
    requestedSubject: "حساب Mobil Arıcı شما حذف می‌شود",
    requestedIntro: "درخواستی برای حذف حساب Mobil Arıcı شما دریافت کردیم.",
    requestedWithOrganization: (when) =>
      `حساب شما، کسب‌وکارتان و همه سوابق آن در ${when} برای همیشه حذف می‌شوند.`,
    requestedAccountOnly: (when) =>
      `حساب شما در ${when} برای همیشه حذف می‌شود. سوابقی که وارد کرده‌اید در کسب‌وکار می‌مانند.`,
    requestedChangedMind:
      "نظرتان عوض شد؟ پیش از این تاریخ وارد برنامه شوید و تأیید کنید که می‌خواهید حسابتان بماند.",
    requestedNotYou: "اگر این درخواست را شما نداده‌اید، همین حالا وارد شوید.",
    codeSubject: "کد حذف حساب Mobil Arıcı شما",
    codeIntro: "درخواست حذف حساب Mobil Arıcı خود را داده‌اید.",
    codeEnter: (code) => `برای تأیید، این کد را در برنامه وارد کنید: ${code}`,
    codeValidity: "کد 10 دقیقه اعتبار دارد و یک بار قابل استفاده است. آن را با کسی در میان نگذارید.",
    codeNotYou: "اگر شما درخواست نداده‌اید، این ایمیل را نادیده بگیرید؛ حسابتان حذف نمی‌شود.",
    completedSubject: "حساب Mobil Arıcı شما حذف شد",
    completedText:
      "حساب Mobil Arıcı شما طبق درخواستتان برای همیشه حذف شد. از اینکه از Mobil Arıcı استفاده کردید سپاسگزاریم.",
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
