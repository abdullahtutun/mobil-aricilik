#!/usr/bin/env python3
"""Mağaza için ham ekran görüntüleri.

`integration_test/store_screenshots_test.dart`'ı iOS simülatöründe yerel
Supabase'deki demo hesapla çalıştırır; test `SHOT:<ad>` bastıkça
simülatörden durum çubuğu dahil görüntü alır.

Önce: `supabase start`, yerelde `demo@tutunsoft.com` kullanıcısı (parola
--password) ve `supabase/admin/demo_account.sql` yüklü.

    python3 tool/store_screenshots.py --password 123456 --out /tmp/raw --lang tr
"""

import argparse
import os
import subprocess
import sys
import time

DEVICE = "iPhone 15 Pro Max"
APIARY = "Yayla Arılığı"
HIVE_NUMBER = "1"


def sh(*args, **kw):
    return subprocess.run(args, check=True, text=True, capture_output=True, **kw).stdout


def device_id(name):
    for line in sh("xcrun", "simctl", "list", "devices", "available").splitlines():
        line = line.strip()
        if line.startswith(name + " ("):
            return line.split("(")[1].split(")")[0]
    sys.exit(f"Simülatör yok: {name}")


def demo_ids():
    env = dict(os.environ, DOCKER_HOST=f"unix://{os.environ['HOME']}/.colima/default/docker.sock")
    sql = (
        "select a.id, h.id from apiaries a join hives h on h.apiary_id = a.id "
        f"where a.name = '{APIARY}' and h.number = '{HIVE_NUMBER}'"
    )
    out = sh("docker", "exec", "supabase_db_mobil_arici", "psql", "-U", "postgres", "-At", "-c", sql, env=env)
    apiary, hive = out.strip().split("|")
    return apiary, hive


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--password", required=True)
    parser.add_argument("--out", required=True)
    parser.add_argument("--lang", default="tr")
    args = parser.parse_args()
    os.makedirs(args.out, exist_ok=True)

    udid = device_id(DEVICE)
    subprocess.run(["xcrun", "simctl", "boot", udid], capture_output=True)
    sh("xcrun", "simctl", "bootstatus", udid, "-b")
    sh("xcrun", "simctl", "ui", udid, "appearance", "light")
    # Saat gerçek saatle aynı; Bugün ekranındaki selamlama buna göre.
    sh("xcrun", "simctl", "status_bar", udid, "override",
       "--time", time.strftime("%H:%M"),
       "--dataNetwork", "wifi", "--wifiMode", "active", "--wifiBars", "3",
       "--cellularMode", "active", "--cellularBars", "4",
       "--batteryState", "charged", "--batteryLevel", "100")

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
