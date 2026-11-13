#!/usr/bin/env python3
"""Mağaza için ham ekran görüntüleri.

`integration_test/store_screenshots_test.dart`'ı iOS simülatöründe yerel
PocketBase'deki demo hesapla çalıştırır; test `SHOT:<ad>` bastıkça
simülatörden durum çubuğu dahil görüntü alır.

Önce yerel sunucu açık olmalı (simülatörde 127.0.0.1 Mac'in kendisi):

    cd server && go run . serve --http 127.0.0.1:8090 --dir /tmp/pb-shots

Betik her çekimde aynı klasörde `migrate up`, `seed demo-user` (parola
stdin'den) ve `seed demo --force-reset` çalıştırır; demo hesabı ve işletmesi
Türkçe asıldan yeniden kurulur. Türkçe dışında `tool/store_demo/<dil>.sql`
çevirisi `sqlite3` ile `<pb-dir>/data.db`'ye uygulanır. Yalnız yerel sunucu;
prod'daki inceleme hesabı Türkçe kalır.

    python3 tool/store_screenshots.py --password 123456 --pb-dir /tmp/pb-shots --out /tmp/raw --lang tr
"""

import argparse
import os
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SERVER = os.path.join(ROOT, "server")

DEVICE = "iPhone 15 Pro Max"
BUNDLE = "com.tutunsoft.mobilarici.dev"
# Görüntülenen arılık ve kovan: 1 numaralı kovan ve arılığı (dilden bağımsız).
HIVE_NUMBER = "1"
DEMO_EMAIL = "demo@tutunsoft.com"
DEMO_ORG = "01900000-0000-7000-8000-00000000de00"


def sh(*args, **kw):
    return subprocess.run(args, check=True, text=True, capture_output=True, **kw).stdout


def device_id(name):
    for line in sh("xcrun", "simctl", "list", "devices", "available").splitlines():
        line = line.strip()
        if line.startswith(name + " ("):
            return line.split("(")[1].split(")")[0]
    sys.exit(f"Simülatör yok: {name}")


def arici(pb_dir, *args, stdin=None):
    """Sunucu ikilisinin bir komutunu yerel veri klasöründe çalıştırır."""
    subprocess.run(["go", "run", ".", *args, "--dir", pb_dir], cwd=SERVER,
                   input=stdin, check=True, text=True, capture_output=True)


def reset_demo(pb_dir, password, lang):
    """Yerel demo işletmeyi Türkçe asıldan yeniden kurar, dil çevirisini uygular."""
    arici(pb_dir, "migrate", "up")
    arici(pb_dir, "seed", "demo-user", "--email", DEMO_EMAIL, stdin=password + "\n")
    arici(pb_dir, "seed", "demo", "--force-reset")
    if lang != "tr":
        with open(os.path.join(ROOT, "tool", "store_demo", f"{lang}.sql")) as f:
            subprocess.run(["sqlite3", "-bail", os.path.join(pb_dir, "data.db")],
                           stdin=f, check=True, capture_output=True)


def demo_ids(pb_dir):
    sql = (
        "select apiary_id, id from hives "
        f"where org_id = '{DEMO_ORG}' and number = '{HIVE_NUMBER}' and deleted_at = ''"
    )
    out = sh("sqlite3", os.path.join(pb_dir, "data.db"), sql)
    apiary, hive = out.strip().split("|")
    return apiary, hive


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--password", required=True, help="demo hesabın parolası (en az 6 karakter)")
    parser.add_argument("--pb-dir", required=True, help="yerel sunucunun --dir klasörü")
    parser.add_argument("--pb-url", default="http://127.0.0.1:8090")
    parser.add_argument("--out", required=True)
    parser.add_argument("--lang", default="tr")
    args = parser.parse_args()
    os.makedirs(args.out, exist_ok=True)
    pb_dir = os.path.abspath(args.pb_dir)

    if time.strftime("%H") == "00":
        # simctl status_bar 00:xx saatini kabul etmiyor.
        sys.exit("Gece 00:00-01:00 arasında çekilemez (simctl saat 00'ı reddeder).")
    udid = device_id(DEVICE)
    subprocess.run(["xcrun", "simctl", "boot", udid], capture_output=True)
    sh("xcrun", "simctl", "bootstatus", udid, "-b")
    sh("xcrun", "simctl", "ui", udid, "appearance", "light")
    # Önceki çekimin yerel DB'si (başka dildeki demo verisi) kalmasın.
    subprocess.run(["xcrun", "simctl", "uninstall", udid, BUNDLE], capture_output=True)
    # Saat gerçek saatle aynı; Bugün ekranındaki selamlama buna göre.
    sh("xcrun", "simctl", "status_bar", udid, "override",
       "--time", time.strftime("%H:%M"),
       "--dataNetwork", "wifi", "--wifiMode", "active", "--wifiBars", "3",
       "--cellularMode", "active", "--cellularBars", "4",
       "--batteryState", "charged", "--batteryLevel", "100")

    reset_demo(pb_dir, args.password, args.lang)
    apiary, hive = demo_ids(pb_dir)
    cmd = [
        "flutter", "test", "integration_test/store_screenshots_test.dart",
        "-d", udid, "--flavor", "dev",
        f"--dart-define=PB_URL={args.pb_url}",
        f"--dart-define=DEMO_EMAIL={DEMO_EMAIL}",
        f"--dart-define=DEMO_PASSWORD={args.password}",
        f"--dart-define=LANGUAGE={args.lang}",
        f"--dart-define=APIARY_ID={apiary}",
        f"--dart-define=HIVE_ID={hive}",
    ]
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    for line in proc.stdout:
        sys.stdout.write(line)
        if "SHOT:" in line:
            name = line.split("SHOT:")[1].strip()
            time.sleep(0.5)
            path = os.path.join(args.out, f"{name}.png")
            sh("xcrun", "simctl", "io", udid, "screenshot", path)
            print(f"  -> {path}", flush=True)
    sys.exit(proc.wait())


if __name__ == "__main__":
    main()
