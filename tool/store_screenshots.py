#!/usr/bin/env python3
"""Mağaza için ham ekran görüntüleri.

`integration_test/store_screenshots_test.dart`'ı iOS simülatöründe yerel
Supabase'deki demo hesapla çalıştırır; test `SHOT:<ad>` bastıkça
simülatörden durum çubuğu dahil görüntü alır.

Önce: `supabase start`, yerelde `demo@tutunsoft.com` kullanıcısı (parola
--password). Betik her çekimde yerel demo işletmeyi `supabase/admin/
demo_account.sql` ile yeniden kurar; Türkçe dışında `tool/store_demo/
<dil>.sql` çevirisini uygular (yalnız yerel DB).

    python3 tool/store_screenshots.py --password 123456 --out /tmp/raw --lang tr
"""

import argparse
import os
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

DEVICE = "iPhone 15 Pro Max"
BUNDLE = "com.tutunsoft.mobilarici.dev"
# Görüntülenen arılık ve kovan: 1 numaralı kovan ve arılığı (dilden bağımsız).
HIVE_NUMBER = "1"


def sh(*args, **kw):
    return subprocess.run(args, check=True, text=True, capture_output=True, **kw).stdout


def device_id(name):
    for line in sh("xcrun", "simctl", "list", "devices", "available").splitlines():
        line = line.strip()
        if line.startswith(name + " ("):
            return line.split("(")[1].split(")")[0]
    sys.exit(f"Simülatör yok: {name}")


DOCKER_ENV = dict(os.environ, DOCKER_HOST=f"unix://{os.environ['HOME']}/.colima/default/docker.sock")
DEMO_ORG = "01900000-0000-7000-8000-00000000de00"


def psql_file(path):
    with open(path) as f:
        subprocess.run(
            ["docker", "exec", "-i", "supabase_db_mobil_arici", "psql", "-U", "postgres",
             "-v", "ON_ERROR_STOP=1", "-q"],
            stdin=f, check=True, env=DOCKER_ENV, capture_output=True)


def reset_demo(lang):
    """Yerel demo işletmeyi Türkçe asıldan yeniden kurar, dil çevirisini uygular."""
    sh("docker", "exec", "supabase_db_mobil_arici", "psql", "-U", "postgres", "-q", "-c",
       f"delete from public.organizations where id = '{DEMO_ORG}'", env=DOCKER_ENV)
    psql_file(os.path.join(ROOT, "supabase", "admin", "demo_account.sql"))
    if lang != "tr":
        psql_file(os.path.join(ROOT, "tool", "store_demo", f"{lang}.sql"))


def demo_ids():
    sql = (
        "select h.apiary_id, h.id from hives h "
        f"where h.number = '{HIVE_NUMBER}' and h.deleted_at is null"
    )
    out = sh("docker", "exec", "supabase_db_mobil_arici", "psql", "-U", "postgres", "-At", "-c", sql, env=DOCKER_ENV)
    apiary, hive = out.strip().split("|")
    return apiary, hive


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--password", required=True)
    parser.add_argument("--out", required=True)
    parser.add_argument("--lang", default="tr")
    args = parser.parse_args()
    os.makedirs(args.out, exist_ok=True)

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

    reset_demo(args.lang)
    apiary, hive = demo_ids()
    cmd = [
        "flutter", "test", "integration_test/store_screenshots_test.dart",
        "-d", udid, "--flavor", "dev",
        "--dart-define=DEMO_EMAIL=demo@tutunsoft.com",
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
