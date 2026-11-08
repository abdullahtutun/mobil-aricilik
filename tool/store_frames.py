#!/usr/bin/env python3
"""Ham simülatör görüntülerinden Play mağaza görselleri.

- 1080x1920 (9:16) telefon ekran görüntüleri: başlık + telefon çerçevesi
- 1024x500 öne çıkan görsel (feature graphic)

Ham görüntüler `tool/store_screenshots.py` ile alınır. Pillow gerekir.

    python3 tool/store_frames.py --raw /tmp/raw --lang tr --out docs/store/play/tr

Farsça ve Hintçe harf birleştirme ister: Pillow libraqm ile çalışmalı
(`brew install libraqm`, sonra `DYLD_LIBRARY_PATH=/opt/homebrew/lib`).
"""

import argparse
import math
import os
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont, features

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FONTS = os.path.join(ROOT, "assets", "fonts")
# Dile göre yazı tipi (uygulamadakiyle aynı); Inter'de bu yazılar yok.
FAMILY = {"fa": ("vazirmatn", "Vazirmatn"), "hi": ("noto_sans_devanagari", "NotoSansDevanagari")}
RTL = {"fa"}
LANG = "tr"
LOGO = os.path.join(ROOT, "assets", "branding", "app_logo.png")

HONEY = (242, 181, 68)
HONEY_DARK = (226, 160, 44)
BROWN = (35, 26, 21)
BROWN_TEXT = (74, 48, 10)
CREAM = (255, 246, 228)
BEZEL = (28, 22, 18)

# Sıra mağazadaki sıradır; ilk üçü en çok görülenler.
CAPTIONS = {
    "tr": {
        "today": ("Bugün ne yapacağını tek bakışta gör",
                  "Hava, dikkat isteyen kovanlar ve görevler"),
        "apiary": ("Kovanların bir bakışta",
                   "Güç, ana arı ve varroa durumu her kovanda"),
        "inspect": ("Eldivenle, birkaç dokunuşta muayene",
                    "Büyük düğmeler; önceki muayene hazır gelir"),
        "hive": ("Her kovanın geçmişi cebinde",
                 "Ana arı, varroa ve ilaçlama takibi"),
        "weather": ("Bugün kovan açılır mı?",
                    "Her arılık için 7 günlük hava"),
        "map": ("Dağda internetsiz çalışır",
                "Arılıkların haritada, kayıtların telefonunda"),
        "finance": ("Hangi arılık kazandırıyor?",
                    "Gelir, gider ve konaklama kârlılığı"),
        "team": ("Ekibinle birlikte çalış",
                 "Ortak, işçi ve danışman; herkes kendi rolünde"),
    },
    "en": {
        "today": ("See your day at a glance",
                  "Weather, hives that need attention and tasks"),
        "apiary": ("All your hives at a glance",
                   "Strength, queen and varroa for every hive"),
        "inspect": ("Inspect in a few taps, gloves on",
                    "Big buttons; the last inspection is filled in"),
        "hive": ("Every hive's history in your pocket",
                 "Track queens, varroa and treatments"),
        "weather": ("Good day to open the hives?",
                    "7-day weather for each apiary"),
        "map": ("Works offline in the field",
                "Apiaries on the map, records on your phone"),
        "finance": ("Which apiary pays off?",
                    "Income, expenses and profit per apiary"),
        "team": ("Work together as a team",
                 "Partners, workers and advisors, each by role"),
    },
    "ru": {
        "today": ("Весь день с одного взгляда",
                  "Погода, ульи, требующие внимания, и задачи"),
        "apiary": ("Все ульи перед глазами",
                   "Сила, матка и варроа для каждого улья"),
        "inspect": ("Осмотр в пару касаний, в перчатках",
                    "Крупные кнопки и данные прошлого осмотра"),
        "hive": ("История каждого улья в кармане",
                 "Матки, варроа и обработки"),
        "weather": ("Можно ли сегодня открывать ульи?",
                    "Погода на 7 дней для каждой пасеки"),
        "map": ("Работает без интернета на точке",
                "Пасеки на карте, записи в телефоне"),
        "finance": ("Какая пасека приносит доход?",
                    "Доходы, расходы и прибыль по пасекам"),
        "team": ("Работайте командой",
                 "Партнёры, работники и консультанты"),
    },
    "es": {
        "today": ("Tu día de un vistazo",
                  "Clima, colmenas que piden atención y tareas"),
        "apiary": ("Tus colmenas a la vista",
                   "Fuerza, reina y varroa de cada colmena"),
        "inspect": ("Revisa en pocos toques, con guantes",
                    "Botones grandes y la última revisión a mano"),
        "hive": ("La historia de cada colmena",
                 "Reinas, varroa y tratamientos"),
        "weather": ("¿Buen día para abrir colmenas?",
                    "Clima de 7 días para cada colmenar"),
        "map": ("Funciona sin conexión en el campo",
                "Colmenares en el mapa, registros contigo"),
        "finance": ("¿Qué colmenar deja ganancia?",
                    "Ingresos, gastos y ganancia por colmenar"),
        "team": ("Trabaja en equipo",
                 "Socios, trabajadores y asesores"),
    },
    "pt": {
        "today": ("Seu dia num relance",
                  "Clima, colmeias que pedem atenção e tarefas"),
        "apiary": ("Suas colmeias à vista",
                   "Força, rainha e varroa de cada colmeia"),
        "inspect": ("Revise em poucos toques, de luvas",
                    "Botões grandes e a última revisão à mão"),
        "hive": ("A história de cada colmeia",
                 "Rainhas, varroa e tratamentos"),
        "weather": ("Dá para abrir as colmeias hoje?",
                    "Previsão de 7 dias para cada apiário"),
        "map": ("Funciona sem internet no campo",
                "Apiários no mapa, registros com você"),
        "finance": ("Qual apiário dá lucro?",
                    "Receitas, despesas e lucro por apiário"),
        "team": ("Trabalhe em equipe",
                 "Sócios, funcionários e consultores"),
    },
    "uk": {
        "today": ("Увесь день одним поглядом",
                  "Погода, проблемні вулики й завдання"),
        "apiary": ("Усі вулики перед очима",
                   "Сила, матка й варроа для кожного вулика"),
        "inspect": ("Огляд навіть у рукавичках",
                    "Великі кнопки й дані минулого огляду"),
        "hive": ("Історія кожного вулика в кишені",
                 "Матки, варроа й обробки"),
        "weather": ("Чи можна сьогодні відкривати вулики?",
                    "Погода на 7 днів для кожної пасіки"),
        "map": ("Працює без інтернету на точці",
                "Пасіки на мапі, записи в телефоні"),
        "finance": ("Яка пасіка приносить дохід?",
                    "Доходи, витрати й прибуток за пасіками"),
        "team": ("Працюйте командою",
                 "Партнери, працівники й консультанти"),
    },
    "fa": {
        "today": ("کار امروز در یک نگاه",
                  "هوا، کندوهای نیازمند توجه و کارها"),
        "apiary": ("همهٔ کندوها جلوی چشم",
                   "قدرت، ملکه و واروآی هر کندو"),
        "inspect": ("بازدید حتی با دستکش",
                    "دکمه‌های بزرگ و داده‌های بازدید قبلی"),
        "hive": ("تاریخچهٔ هر کندو در جیب شما",
                 "ملکه، واروآ و درمان‌ها"),
        "weather": ("امروز کندو را باز کنم؟",
                    "پیش‌بینی ۷ روزه برای هر زنبورستان"),
        "map": ("بدون اینترنت در کوه و دشت",
                "زنبورستان‌ها روی نقشه، داده‌ها در گوشی"),
        "finance": ("کدام زنبورستان سود می‌دهد؟",
                    "درآمد، هزینه و سود هر زنبورستان"),
        "team": ("با تیم خود کار کنید",
                 "شریک، کارگر و مشاور"),
    },
}

FEATURE = {
    "tr": ("Mobil Arıcı", "Arıcılık defterin cepte",
           "Dağda internetsiz, eldivenle bile"),
    "en": ("Mobil Arıcı", "Your beekeeping logbook",
           "Works offline in the field, even with gloves"),
    "ru": ("Mobil Arıcı", "Пасечный журнал в кармане",
           "Без интернета на точке, даже в перчатках"),
    "es": ("Mobil Arıcı", "Tu cuaderno apícola",
           "Sin conexión en el campo, incluso con guantes"),
    "pt": ("Mobil Arıcı", "Seu caderno apícola",
           "Sem internet no campo, até de luvas"),
    "uk": ("Mobil Arıcı", "Пасічний журнал у кишені",
           "Без інтернету на точці, навіть у рукавичках"),
    "fa": ("Mobil Arıcı", "دفتر زنبورداری در جیب شما",
           "بدون اینترنت در کوه، حتی با دستکش"),
}


def font(weight, size):
    folder, name = FAMILY.get(LANG, ("inter", "Inter"))
    return ImageFont.truetype(os.path.join(FONTS, folder, f"{name}-{weight}.ttf"), size)


def fit(draw, text, weight, size, width):
    """Tek satırda [width]'e sığan en büyük yazı (en çok [size])."""
    while size > 12:
        fnt = font(weight, size)
        if draw.textlength(text, font=fnt) <= width:
            return fnt
        size -= 1
    return font(weight, size)


def wrap(draw, text, fnt, width):
    words, lines, line = text.split(), [], ""
    for word in words:
        trial = f"{line} {word}".strip()
        if draw.textlength(trial, font=fnt) <= width:
            line = trial
        else:
            lines.append(line)
            line = word
    lines.append(line)
    return lines


def hexagon(draw, cx, cy, r, color, width):
    pts = [(cx + r * math.cos(math.radians(60 * i + 30)),
            cy + r * math.sin(math.radians(60 * i + 30))) for i in range(7)]
    draw.line(pts, fill=color, width=width, joint="curve")


def honeycomb(size, color, r, width, origin=(0, 0)):
    layer = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    w, h = size
    dx, dy = r * math.sqrt(3), r * 1.5
    row = 0
    y = origin[1]
    while y < h + r:
        x = origin[0] + (dx / 2 if row % 2 else 0)
        while x < w + r:
            hexagon(draw, x, y, r, color, width)
            x += dx
        y += dy
        row += 1
    return layer


def phone(shot, width):
    """Ekran görüntüsünü yuvarlak köşeli, ince çerçeveli telefona koyar."""
    bezel = max(10, width // 40)
    screen_w = width - 2 * bezel
    screen_h = round(shot.height * screen_w / shot.width)
    screen = shot.convert("RGB").resize((screen_w, screen_h), Image.LANCZOS)
    radius = round(screen_w * 0.13)
    mask = Image.new("L", screen.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, *screen.size), radius, fill=255)
    body = Image.new("RGBA", (width, screen_h + 2 * bezel), (0, 0, 0, 0))
    ImageDraw.Draw(body).rounded_rectangle(
        (0, 0, body.width - 1, body.height - 1), radius + bezel, fill=BEZEL)
    body.paste(screen, (bezel, bezel), mask)
    return body


def with_shadow(img, blur=28, offset=(0, 18), alpha=90):
    pad = blur * 3
    out = Image.new("RGBA", (img.width + 2 * pad, img.height + 2 * pad), (0, 0, 0, 0))
    shadow = Image.new("RGBA", img.size, (0, 0, 0, alpha))
    out.paste(shadow, (pad + offset[0], pad + offset[1]), img.split()[3])
    out = out.filter(ImageFilter.GaussianBlur(blur))
    out.alpha_composite(img, (pad, pad))
    return out, pad


def screenshot_frame(shot, title, subtitle):
    W, H = 1080, 1920
    canvas = Image.new("RGBA", (W, H), HONEY + (255,))
    canvas.alpha_composite(honeycomb((W, H), HONEY_DARK + (255,), 120, 6, (-40, 980)))
    draw = ImageDraw.Draw(canvas)

    title_font, sub_font = font("Bold", 74), font("Medium", 40)
    y = 96
    for line in wrap(draw, title, title_font, W - 140):
        draw.text((W / 2, y), line, font=title_font, fill=BROWN, anchor="ma")
        y += 88
    y += 18
    for line in wrap(draw, subtitle, sub_font, W - 160):
        draw.text((W / 2, y), line, font=sub_font, fill=BROWN_TEXT, anchor="ma")
        y += 54

    top = max(y + 46, 430)
    body = phone(shot, 10_000)  # oranı bulmak için
    height = H - top - 40
    width = round(height * body.width / body.height)
    body = phone(shot, width)
    framed, pad = with_shadow(body)
    canvas.alpha_composite(framed, ((W - body.width) // 2 - pad, top - pad))
    return canvas.convert("RGB")


def feature_graphic(shots, name, tagline, line):
    W, H = 1024, 500
    canvas = Image.new("RGBA", (W, H), BROWN + (255,))
    comb = honeycomb((W, H), (52, 40, 32, 255), 70, 4, (520, -20))
    if LANG in RTL:
        comb = comb.transpose(Image.FLIP_LEFT_RIGHT)
    canvas.alpha_composite(comb)
    draw = ImageDraw.Draw(canvas)

    rtl = LANG in RTL
    # Sağdan sola dillerde düzen aynalanır: yazı sağda, telefonlar solda.
    def mirror(x, w=0):
        return W - x - w if rtl else x

    logo = Image.open(LOGO).convert("RGBA").resize((150, 150), Image.LANCZOS)
    canvas.alpha_composite(logo, (mirror(64, 150), 92))
    # Metin sağdaki telefonlara girmesin: sığmazsa küçülür.
    max_width = 470
    for text, weight, size, y, color in (
        (name, "Bold", 60, 270, CREAM),
        (tagline, "SemiBold", 32, 348, HONEY),
        (line, "Medium", 24, 396, (214, 196, 168)),
    ):
        fnt = fit(draw, text, weight, size, max_width)
        if rtl:
            draw.text((W - 66, y), text, font=fnt, fill=color, anchor="ra")
        else:
            draw.text((66, y), text, font=fnt, fill=color)

    # İki telefon sağda, alttan taşarak.
    for i, (shot, x, y) in enumerate(((shots[1], 560, 120), (shots[0], 760, 60))):
        body = phone(shot, 230)
        framed, pad = with_shadow(body, blur=18, offset=(0, 10), alpha=140)
        canvas.alpha_composite(framed, (mirror(x, body.width) - pad, y - pad))
    return canvas.convert("RGB")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw", required=True)
    parser.add_argument("--lang", default="tr")
    parser.add_argument("--out", required=True)
    args = parser.parse_args()
    os.makedirs(args.out, exist_ok=True)
    global LANG
    LANG = args.lang
    if LANG in FAMILY and not features.check("raqm"):
        sys.exit("Bu dil için Pillow libraqm ile çalışmalı (docstring'e bak).")

    captions = CAPTIONS[args.lang]
    for index, (shot_name, (title, subtitle)) in enumerate(captions.items(), 1):
        shot = Image.open(os.path.join(args.raw, f"{shot_name}.png"))
        path = os.path.join(args.out, f"{index:02d}_{shot_name}.png")
        screenshot_frame(shot, title, subtitle).save(path, optimize=True)
        print(path)

    shots = [Image.open(os.path.join(args.raw, f"{n}.png")) for n in ("today", "apiary")]
    path = os.path.join(args.out, "feature_graphic.png")
    feature_graphic(shots, *FEATURE[args.lang]).save(path, optimize=True)
    print(path)


if __name__ == "__main__":
    main()
