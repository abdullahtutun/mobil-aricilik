package auth

// otpText is one language of the OTP e-mail. Validity and SentTo carry the
// placeholders {minutes} and {email}; the template escapes the result.
//
// Moved word for word from supabase/templates/otp.html (2026-11-06); the
// subject is that file's <title>, which Supabase's subject line had only in
// TR and EN. The "10" in Validity is now {minutes}, from the users
// collection's OTP duration ([OTPDuration]).
type otpText struct {
	Subject     string
	Preheader   string
	Heading     string
	Instruction string
	Validity    string
	Ignore      string
	SentTo      string
}

var otpTexts = map[string]otpText{
	"tr": {
		Subject:     "Mobil Arıcı giriş kodunuz",
		Preheader:   "Mobil Arıcı'ya giriş için tek kullanımlık kodunuz.",
		Heading:     "Giriş kodunuz",
		Instruction: "Giriş yapmak için bu kodu uygulamaya girin:",
		Validity:    "Kod {minutes} dakika geçerlidir ve bir kez kullanılabilir. Kodu kimseyle paylaşmayın.",
		Ignore:      "Giriş yapmaya çalışmadıysanız bu e-postayı yok sayabilirsiniz.",
		SentTo:      "Bu e-posta {email} adresine gönderildi.",
	},
	"en": {
		Subject:     "Your Mobil Arıcı sign-in code",
		Preheader:   "Your one-time code to sign in to Mobil Arıcı.",
		Heading:     "Your sign-in code",
		Instruction: "Enter this code in the app to sign in:",
		Validity:    "The code is valid for {minutes} minutes and can be used once. Don't share it with anyone.",
		Ignore:      "If you didn't try to sign in, you can ignore this email.",
		SentTo:      "This email was sent to {email}.",
	},
	"de": {
		Subject:     "Dein Anmeldecode für Mobil Arıcı",
		Preheader:   "Dein Einmalcode für die Anmeldung bei Mobil Arıcı.",
		Heading:     "Dein Anmeldecode",
		Instruction: "Gib diesen Code in der App ein, um dich anzumelden:",
		Validity:    "Der Code gilt {minutes} Minuten und kann einmal verwendet werden. Gib ihn an niemanden weiter.",
		Ignore:      "Wenn du dich nicht anmelden wolltest, kannst du diese E-Mail ignorieren.",
		SentTo:      "Diese E-Mail wurde an {email} gesendet.",
	},
	"es": {
		Subject:     "Tu código para iniciar sesión en Mobil Arıcı",
		Preheader:   "Tu código de un solo uso para iniciar sesión en Mobil Arıcı.",
		Heading:     "Tu código de inicio de sesión",
		Instruction: "Introduce este código en la app para iniciar sesión:",
		Validity:    "El código es válido durante {minutes} minutos y se puede usar una vez. No lo compartas con nadie.",
		Ignore:      "Si no intentaste iniciar sesión, puedes ignorar este correo.",
		SentTo:      "Este correo se envió a {email}.",
	},
	"pt": {
		Subject:     "Seu código de acesso ao Mobil Arıcı",
		Preheader:   "Seu código de uso único para entrar no Mobil Arıcı.",
		Heading:     "Seu código de acesso",
		Instruction: "Digite este código no app para entrar:",
		Validity:    "O código vale por {minutes} minutos e pode ser usado uma vez. Não o compartilhe com ninguém.",
		Ignore:      "Se você não tentou entrar, pode ignorar este e-mail.",
		SentTo:      "Este e-mail foi enviado para {email}.",
	},
	"ru": {
		Subject:     "Ваш код для входа в Mobil Arıcı",
		Preheader:   "Ваш одноразовый код для входа в Mobil Arıcı.",
		Heading:     "Ваш код для входа",
		Instruction: "Введите этот код в приложении, чтобы войти:",
		Validity:    "Код действует {minutes} минут и может быть использован один раз. Никому его не сообщайте.",
		Ignore:      "Если вы не пытались войти, просто проигнорируйте это письмо.",
		SentTo:      "Это письмо отправлено на {email}.",
	},
	"uk": {
		Subject:     "Ваш код для входу в Mobil Arıcı",
		Preheader:   "Ваш одноразовий код для входу в Mobil Arıcı.",
		Heading:     "Ваш код для входу",
		Instruction: "Введіть цей код у застосунку, щоб увійти:",
		Validity:    "Код діє {minutes} хвилин і може бути використаний один раз. Нікому його не повідомляйте.",
		Ignore:      "Якщо ви не намагалися увійти, просто проігноруйте цей лист.",
		SentTo:      "Цей лист надіслано на {email}.",
	},
	"fa": {
		Subject:     "کد ورود شما به Mobil Arıcı",
		Preheader:   "کد یک‌بارمصرف شما برای ورود به Mobil Arıcı.",
		Heading:     "کد ورود شما",
		Instruction: "برای ورود این کد را در برنامه وارد کنید:",
		Validity:    "کد {minutes} دقیقه اعتبار دارد و یک بار قابل استفاده است. آن را با کسی در میان نگذارید.",
		Ignore:      "اگر قصد ورود نداشتید، می‌توانید این ایمیل را نادیده بگیرید.",
		SentTo:      "این ایمیل به {email} فرستاده شد.",
	},
	"hi": {
		Subject:     "आपका Mobil Arıcı साइन-इन कोड",
		Preheader:   "Mobil Arıcı में साइन इन के लिए आपका एक बार का कोड।",
		Heading:     "आपका साइन-इन कोड",
		Instruction: "साइन इन के लिए ऐप में यह कोड डालें:",
		Validity:    "कोड {minutes} मिनट तक मान्य है और एक बार इस्तेमाल हो सकता है। इसे किसी से साझा न करें।",
		Ignore:      "अगर आपने साइन इन की कोशिश नहीं की, तो इस ईमेल को अनदेखा कर सकते हैं।",
		SentTo:      "यह ईमेल {email} पर भेजा गया।",
	},
}
