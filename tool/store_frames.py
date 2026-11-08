#!/usr/bin/env python3
"""Ham simülatör görüntülerinden Play mağaza görselleri.

- 1080x1920 (9:16) telefon ekran görüntüleri: başlık + telefon çerçevesi
- 1024x500 öne çıkan görsel (feature graphic)

Ham görüntüler `tool/store_screenshots.py` ile alınır. Pillow gerekir.

    python3 tool/store_frames.py --raw /tmp/raw --lang tr --out docs/store/play/tr
"""

import argparse
import math
import os

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FONTS = os.path.join(ROOT, "assets", "fonts", "inter")
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
}

FEATURE = {
    "tr": ("Mobil Arıcı", "Arıcılık defterin cepte",
           "Dağda internetsiz, eldivenle bile"),
}


def font(weight, size):
    return ImageFont.truetype(os.path.join(FONTS, f"Inter-{weight}.ttf"), size)


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
    canvas.alpha_composite(honeycomb((W, H), (52, 40, 32, 255), 70, 4, (520, -20)))
    draw = ImageDraw.Draw(canvas)

    logo = Image.open(LOGO).convert("RGBA").resize((150, 150), Image.LANCZOS)
    canvas.alpha_composite(logo, (64, 92))
    draw.text((64, 270), name, font=font("Bold", 60), fill=CREAM)
    draw.text((66, 348), tagline, font=font("SemiBold", 32), fill=HONEY)
    draw.text((66, 396), line, font=font("Medium", 24), fill=(214, 196, 168))

    # İki telefon sağda, alttan taşarak.
    for i, (shot, x, y) in enumerate(((shots[1], 560, 120), (shots[0], 760, 60))):
        body = phone(shot, 230)
        framed, pad = with_shadow(body, blur=18, offset=(0, 10), alpha=140)
        canvas.alpha_composite(framed, (x - pad, y - pad))
    return canvas.convert("RGB")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw", required=True)
    parser.add_argument("--lang", default="tr")
    parser.add_argument("--out", required=True)
    args = parser.parse_args()
    os.makedirs(args.out, exist_ok=True)

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
