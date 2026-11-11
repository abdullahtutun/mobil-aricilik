package deletion

import (
	"fmt"
	"strings"
	"time"
	_ "time/tzdata" // Europe/Istanbul without the image's zoneinfo.

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
)

// Mail is an account deletion e-mail: plain text only, like
// supabase/functions/account-delete (index.ts sendMail sends subject + text).
type Mail struct {
	Subject string
	Text    string
}

// mailText is mail.ts's MailText. {when} is the deletion date
// ([FormatDeletionDate]), {code} the deletion code.
type mailText struct {
	requestedSubject          string
	requestedIntro            string
	requestedWithOrganization string
	requestedAccountOnly      string
	requestedChangedMind      string
	requestedNotYou           string
	codeSubject               string
	codeIntro                 string
	codeEnter                 string
	codeValidity              string
	codeNotYou                string
	completedSubject          string
	completedText             string
}

// mailTexts are mail.ts's strings for every language of auth.Locales,
// generated from mail.ts itself (testdata/mails.json holds its output and
// the test compares every e-mail with it). A new language is added there and
// here.
var mailTexts = map[string]mailText{
	"tr": {
		requestedSubject:          "Mobil Arıcı hesabın silinecek",
		requestedIntro:            "Mobil Arıcı hesabını silme talebini aldık.",
		requestedWithOrganization: "Hesabın, işletmen ve işletmenin tüm kayıtları {when} tarihinde kalıcı olarak silinecek.",
		requestedAccountOnly:      "Hesabın {when} tarihinde kalıcı olarak silinecek. Girdiğin işletme kayıtları işletmede kalır.",
		requestedChangedMind:      "Vazgeçtiysen bu tarihten önce uygulamaya giriş yap ve hesabını korumak istediğini onayla.",
		requestedNotYou:           "Bu talebi sen yapmadıysan hemen giriş yap.",
		codeSubject:               "Mobil Arıcı hesap silme kodun",
		codeIntro:                 "Mobil Arıcı hesabını silmek istedin.",
		codeEnter:                 "Onaylamak için bu kodu uygulamaya gir: {code}",
		codeValidity:              "Kod 10 dakika geçerli ve bir kez kullanılabilir. Kodu kimseyle paylaşma.",
		codeNotYou:                "Bunu sen istemediysen bu e-postayı yok say; hesabın silinmez.",
		completedSubject:          "Mobil Arıcı hesabın silindi",
		completedText:             "Mobil Arıcı hesabın isteğin üzerine kalıcı olarak silindi. Mobil Arıcı'yı kullandığın için teşekkürler.",
	},
	"en": {
		requestedSubject:          "Your Mobil Arıcı account will be deleted",
		requestedIntro:            "We received a request to delete your Mobil Arıcı account.",
		requestedWithOrganization: "Your account, your business and all of its records will be permanently deleted on {when}.",
		requestedAccountOnly:      "Your account will be permanently deleted on {when}. The business records you entered stay with the business.",
		requestedChangedMind:      "Changed your mind? Sign in to the app before that date and confirm that you want to keep your account.",
		requestedNotYou:           "If you did not make this request, sign in now.",
		codeSubject:               "Your Mobil Arıcı account deletion code",
		codeIntro:                 "You asked to delete your Mobil Arıcı account.",
		codeEnter:                 "To confirm, enter this code in the app: {code}",
		codeValidity:              "The code is valid for 10 minutes and can be used once. Don't share it with anyone.",
		codeNotYou:                "If you didn't ask for this, ignore this email; your account will not be deleted.",
		completedSubject:          "Your Mobil Arıcı account has been deleted",
		completedText:             "Your Mobil Arıcı account has been permanently deleted as you requested. Thank you for using Mobil Arıcı.",
	},
	"de": {
		requestedSubject:          "Dein Mobil-Arıcı-Konto wird gelöscht",
		requestedIntro:            "Wir haben eine Anfrage zum Löschen deines Mobil-Arıcı-Kontos erhalten.",
		requestedWithOrganization: "Dein Konto, dein Betrieb und alle seine Einträge werden am {when} endgültig gelöscht.",
		requestedAccountOnly:      "Dein Konto wird am {when} endgültig gelöscht. Die Einträge, die du im Betrieb erfasst hast, bleiben beim Betrieb.",
		requestedChangedMind:      "Du hast es dir anders überlegt? Melde dich vor diesem Datum in der App an und bestätige, dass du dein Konto behalten möchtest.",
		requestedNotYou:           "Wenn du diese Anfrage nicht gestellt hast, melde dich sofort an.",
		codeSubject:               "Dein Code zum Löschen des Mobil-Arıcı-Kontos",
		codeIntro:                 "Du möchtest dein Mobil-Arıcı-Konto löschen.",
		codeEnter:                 "Gib zur Bestätigung diesen Code in der App ein: {code}",
		codeValidity:              "Der Code gilt 10 Minuten und kann einmal verwendet werden. Gib ihn an niemanden weiter.",
		codeNotYou:                "Wenn du das nicht angefordert hast, ignoriere diese E-Mail; dein Konto wird nicht gelöscht.",
		completedSubject:          "Dein Mobil-Arıcı-Konto wurde gelöscht",
		completedText:             "Dein Mobil-Arıcı-Konto wurde auf deinen Wunsch endgültig gelöscht. Danke, dass du Mobil Arıcı genutzt hast.",
	},
	"es": {
		requestedSubject:          "Tu cuenta de Mobil Arıcı se eliminará",
		requestedIntro:            "Hemos recibido una solicitud para eliminar tu cuenta de Mobil Arıcı.",
		requestedWithOrganization: "Tu cuenta, tu explotación y todos sus registros se eliminarán definitivamente el {when}.",
		requestedAccountOnly:      "Tu cuenta se eliminará definitivamente el {when}. Los registros que introdujiste se quedan en la explotación.",
		requestedChangedMind:      "¿Has cambiado de opinión? Inicia sesión en la app antes de esa fecha y confirma que quieres conservar tu cuenta.",
		requestedNotYou:           "Si no has hecho esta solicitud, inicia sesión ahora.",
		codeSubject:               "Tu código para eliminar la cuenta de Mobil Arıcı",
		codeIntro:                 "Has pedido eliminar tu cuenta de Mobil Arıcı.",
		codeEnter:                 "Para confirmar, introduce este código en la app: {code}",
		codeValidity:              "El código es válido durante 10 minutos y se puede usar una vez. No lo compartas con nadie.",
		codeNotYou:                "Si no lo has pedido tú, ignora este correo; tu cuenta no se eliminará.",
		completedSubject:          "Tu cuenta de Mobil Arıcı se ha eliminado",
		completedText:             "Tu cuenta de Mobil Arıcı se ha eliminado definitivamente, como pediste. Gracias por usar Mobil Arıcı.",
	},
	"pt": {
		requestedSubject:          "Sua conta do Mobil Arıcı será excluída",
		requestedIntro:            "Recebemos um pedido para excluir sua conta do Mobil Arıcı.",
		requestedWithOrganization: "Sua conta, seu negócio e todos os registros dele serão excluídos definitivamente em {when}.",
		requestedAccountOnly:      "Sua conta será excluída definitivamente em {when}. Os registros que você lançou continuam no negócio.",
		requestedChangedMind:      "Mudou de ideia? Entre no app antes dessa data e confirme que quer manter sua conta.",
		requestedNotYou:           "Se você não fez este pedido, entre agora.",
		codeSubject:               "Seu código para excluir a conta do Mobil Arıcı",
		codeIntro:                 "Você pediu para excluir sua conta do Mobil Arıcı.",
		codeEnter:                 "Para confirmar, digite este código no app: {code}",
		codeValidity:              "O código vale por 10 minutos e pode ser usado uma vez. Não o compartilhe com ninguém.",
		codeNotYou:                "Se não foi você, ignore este e-mail; sua conta não será excluída.",
		completedSubject:          "Sua conta do Mobil Arıcı foi excluída",
		completedText:             "Sua conta do Mobil Arıcı foi excluída definitivamente, como você pediu. Obrigado por usar o Mobil Arıcı.",
	},
	"ru": {
		requestedSubject:          "Ваш аккаунт Mobil Arıcı будет удалён",
		requestedIntro:            "Мы получили запрос на удаление вашего аккаунта Mobil Arıcı.",
		requestedWithOrganization: "Ваш аккаунт, ваше хозяйство и все его записи будут окончательно удалены {when}.",
		requestedAccountOnly:      "Ваш аккаунт будет окончательно удалён {when}. Внесённые вами записи остаются в хозяйстве.",
		requestedChangedMind:      "Передумали? Войдите в приложение до этой даты и подтвердите, что хотите сохранить аккаунт.",
		requestedNotYou:           "Если вы не отправляли этот запрос, войдите прямо сейчас.",
		codeSubject:               "Код для удаления аккаунта Mobil Arıcı",
		codeIntro:                 "Вы запросили удаление аккаунта Mobil Arıcı.",
		codeEnter:                 "Для подтверждения введите этот код в приложении: {code}",
		codeValidity:              "Код действует 10 минут и может быть использован один раз. Никому его не сообщайте.",
		codeNotYou:                "Если вы этого не запрашивали, проигнорируйте письмо; аккаунт не будет удалён.",
		completedSubject:          "Ваш аккаунт Mobil Arıcı удалён",
		completedText:             "Ваш аккаунт Mobil Arıcı окончательно удалён по вашему запросу. Спасибо, что пользовались Mobil Arıcı.",
	},
	"uk": {
		requestedSubject:          "Ваш обліковий запис Mobil Arıcı буде видалено",
		requestedIntro:            "Ми отримали запит на видалення вашого облікового запису Mobil Arıcı.",
		requestedWithOrganization: "Ваш обліковий запис, ваше господарство та всі його записи буде остаточно видалено {when}.",
		requestedAccountOnly:      "Ваш обліковий запис буде остаточно видалено {when}. Внесені вами записи залишаються в господарстві.",
		requestedChangedMind:      "Передумали? Увійдіть у застосунок до цієї дати й підтвердьте, що хочете зберегти обліковий запис.",
		requestedNotYou:           "Якщо ви не надсилали цей запит, увійдіть просто зараз.",
		codeSubject:               "Код для видалення облікового запису Mobil Arıcı",
		codeIntro:                 "Ви запросили видалення облікового запису Mobil Arıcı.",
		codeEnter:                 "Для підтвердження введіть цей код у застосунку: {code}",
		codeValidity:              "Код діє 10 хвилин і може бути використаний один раз. Нікому його не повідомляйте.",
		codeNotYou:                "Якщо ви цього не запитували, проігноруйте лист; обліковий запис не буде видалено.",
		completedSubject:          "Ваш обліковий запис Mobil Arıcı видалено",
		completedText:             "Ваш обліковий запис Mobil Arıcı остаточно видалено на ваш запит. Дякуємо, що користувалися Mobil Arıcı.",
	},
	"fa": {
		requestedSubject:          "حساب Mobil Arıcı شما حذف می‌شود",
		requestedIntro:            "درخواستی برای حذف حساب Mobil Arıcı شما دریافت کردیم.",
		requestedWithOrganization: "حساب شما، کسب‌وکارتان و همه سوابق آن در {when} برای همیشه حذف می‌شوند.",
		requestedAccountOnly:      "حساب شما در {when} برای همیشه حذف می‌شود. سوابقی که وارد کرده‌اید در کسب‌وکار می‌مانند.",
		requestedChangedMind:      "نظرتان عوض شد؟ پیش از این تاریخ وارد برنامه شوید و تأیید کنید که می‌خواهید حسابتان بماند.",
		requestedNotYou:           "اگر این درخواست را شما نداده‌اید، همین حالا وارد شوید.",
		codeSubject:               "کد حذف حساب Mobil Arıcı شما",
		codeIntro:                 "درخواست حذف حساب Mobil Arıcı خود را داده‌اید.",
		codeEnter:                 "برای تأیید، این کد را در برنامه وارد کنید: {code}",
		codeValidity:              "کد 10 دقیقه اعتبار دارد و یک بار قابل استفاده است. آن را با کسی در میان نگذارید.",
		codeNotYou:                "اگر شما درخواست نداده‌اید، این ایمیل را نادیده بگیرید؛ حسابتان حذف نمی‌شود.",
		completedSubject:          "حساب Mobil Arıcı شما حذف شد",
		completedText:             "حساب Mobil Arıcı شما طبق درخواستتان برای همیشه حذف شد. از اینکه از Mobil Arıcı استفاده کردید سپاسگزاریم.",
	},
	"hi": {
		requestedSubject:          "आपका Mobil Arıcı खाता हटाया जाएगा",
		requestedIntro:            "हमें आपका Mobil Arıcı खाता हटाने का अनुरोध मिला है।",
		requestedWithOrganization: "आपका खाता, आपका व्यवसाय और उसके सभी रिकॉर्ड {when} को स्थायी रूप से हटा दिए जाएँगे।",
		requestedAccountOnly:      "आपका खाता {when} को स्थायी रूप से हटा दिया जाएगा। आपके डाले व्यवसाय रिकॉर्ड व्यवसाय में बने रहेंगे।",
		requestedChangedMind:      "मन बदल गया? उस तारीख़ से पहले ऐप में साइन इन करें और पुष्टि करें कि आप अपना खाता रखना चाहते हैं।",
		requestedNotYou:           "अगर यह अनुरोध आपने नहीं किया, तो अभी साइन इन करें।",
		codeSubject:               "आपका Mobil Arıcı खाता हटाने का कोड",
		codeIntro:                 "आपने अपना Mobil Arıcı खाता हटाने का अनुरोध किया है।",
		codeEnter:                 "पुष्टि के लिए ऐप में यह कोड डालें: {code}",
		codeValidity:              "कोड 10 मिनट तक मान्य है और एक बार इस्तेमाल हो सकता है। इसे किसी से साझा न करें।",
		codeNotYou:                "अगर आपने यह नहीं माँगा, तो इस ईमेल को अनदेखा करें; आपका खाता नहीं हटेगा।",
		completedSubject:          "आपका Mobil Arıcı खाता हटा दिया गया",
		completedText:             "आपके अनुरोध पर आपका Mobil Arıcı खाता स्थायी रूप से हटा दिया गया है। Mobil Arıcı इस्तेमाल करने के लिए धन्यवाद।",
	},
}

// MailLocale is mail.ts's mailLocale (pickLocale): the user's language, or
// English when it is empty or unknown.
func MailLocale(locale string) string { return auth.PickLocale(locale) }

func textFor(locale string) mailText {
	if t, ok := mailTexts[locale]; ok {
		return t
	}
	return mailTexts["en"]
}

// months are the month names of Intl.DateTimeFormat with dateStyle "long"
// (formatToParts "month") in the locales mail.ts uses; Russian and
// Ukrainian are genitive. Taken from Deno's ICU, the Edge Function's
// runtime.
var months = map[string][12]string{
	"tr": {"Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"},
	"en": {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"},
	"de": {"Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"},
	"es": {"enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"},
	"pt": {"janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"},
	"ru": {"января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"},
	"uk": {"січня", "лютого", "березня", "квітня", "травня", "червня", "липня", "серпня", "вересня", "жовтня", "листопада", "грудня"},
	"fa": {"ژانویهٔ", "فوریهٔ", "مارس", "آوریل", "مهٔ", "ژوئن", "ژوئیهٔ", "اوت", "سپتامبر", "اکتبر", "نوامبر", "دسامبر"},
	"hi": {"जनवरी", "फ़रवरी", "मार्च", "अप्रैल", "मई", "जून", "जुलाई", "अगस्त", "सितंबर", "अक्टूबर", "नवंबर", "दिसंबर"},
}

// istanbul is Türkiye's time (TSİ); UTC if the zone cannot be loaded.
var istanbul = func() *time.Location {
	if loc, err := time.LoadLocation("Europe/Istanbul"); err == nil {
		return loc
	}
	return time.UTC
}()

// FormatDeletionDate is mail.ts's formatDeletionDate: Intl.DateTimeFormat
// with dateStyle "long" and timeStyle "short", in Türkiye's time with
// "(TSİ)" for Turkish and in UTC with "UTC" for every other language. The
// patterns are Deno's ICU output (Spanish ", " where Node's newer ICU writes
// " a las "); testdata/mails.json holds it.
func FormatDeletionDate(t time.Time, locale string) string {
	m, ok := months[locale]
	if !ok {
		locale, m = "en", months["en"]
	}
	if locale == "tr" {
		t = t.In(istanbul)
	} else {
		t = t.UTC()
	}
	d, month, y, h, mi := t.Day(), m[t.Month()-1], t.Year(), t.Hour(), t.Minute()
	switch locale {
	case "tr":
		return fmt.Sprintf("%d %s %d %02d:%02d (TSİ)", d, month, y, h, mi)
	case "de":
		return fmt.Sprintf("%d. %s %d um %02d:%02d UTC", d, month, y, h, mi)
	case "es":
		return fmt.Sprintf("%d de %s de %d, %d:%02d UTC", d, month, y, h, mi)
	case "pt":
		return fmt.Sprintf("%d de %s de %d às %02d:%02d UTC", d, month, y, h, mi)
	case "ru":
		return fmt.Sprintf("%d %s %d г. в %02d:%02d UTC", d, month, y, h, mi)
	case "uk":
		return fmt.Sprintf("%d %s %d р. о %02d:%02d UTC", d, month, y, h, mi)
	case "fa":
		return fmt.Sprintf("%d %s %d ساعت %d:%02d UTC", d, month, y, h, mi)
	case "hi":
		h12, half := h%12, "am"
		if h12 == 0 {
			h12 = 12
		}
		if h >= 12 {
			half = "pm"
		}
		return fmt.Sprintf("%d %s %d को %d:%02d %s बजे UTC", d, month, y, h12, mi, half)
	default:
		return fmt.Sprintf("%d %s %d at %02d:%02d UTC", d, month, y, h, mi)
	}
}

// RequestedMail is mail.ts's requestedMail: "deleted on <date>; to change
// your mind, sign in and confirm".
func RequestedMail(scheduledFor time.Time, withOrganization bool, locale string) Mail {
	t := textFor(locale)
	when := FormatDeletionDate(scheduledFor, locale)
	line := t.requestedAccountOnly
	if withOrganization {
		line = t.requestedWithOrganization
	}
	return Mail{
		Subject: t.requestedSubject,
		Text: strings.Join([]string{
			t.requestedIntro,
			"",
			strings.ReplaceAll(line, "{when}", when),
			"",
			t.requestedChangedMind,
			t.requestedNotYou,
		}, "\n"),
	}
}

// CodeMail is mail.ts's codeMail: the code that confirms the deletion (not
// a sign-in code).
func CodeMail(code, locale string) Mail {
	t := textFor(locale)
	return Mail{
		Subject: t.codeSubject,
		Text: strings.Join([]string{
			t.codeIntro,
			"",
			strings.ReplaceAll(t.codeEnter, "{code}", code),
			"",
			t.codeValidity,
			t.codeNotYou,
		}, "\n"),
	}
}

// CompletedMail is mail.ts's completedMail: the short confirmation after the
// permanent deletion (sent by P5.9).
func CompletedMail(locale string) Mail {
	t := textFor(locale)
	return Mail{Subject: t.completedSubject, Text: t.completedText}
}
