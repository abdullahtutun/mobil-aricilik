// lot-page: Yayımlanan lotun herkese açık sayfası; oturum gerekmez.
//
//  - GET /lot-page/<lot_id>         Sade, mobil uyumlu HTML sayfa. Lot
//                                   yayımda değilse (ya da yoksa) 404.
//  - GET /lot-page/<lot_id>/report  Son analizin raporu (PDF ya da JPEG).
//                                   Rapor alanı seçilmemişse 404.
//
// Veri yalnız `public.lot_public_page`'ten gelir: owner'ın seçtiği alanlar,
// kişisel veri yok. Rapor özel `documents` bucket'ından özel `public-lots`
// bucket'ına `<lot_id>/<document_id>.pdf|jpg` olarak ilk istekte kopyalanır
// ve oradan sunulur. Lot yayımdan kalkınca ya da rapor alanı kapanınca
// kopyalar bir sonraki istekte silinir; o ana kadar da sunulmaz, çünkü her
// istek yayım durumunu yeniden okur.
//
// Supabase varsayılan *.supabase.co alanında text/html yanıtı düz metne
// çevirir; sayfa ancak özel alan adıyla HTML olarak açılır.

import { createClient, type SupabaseClient } from "npm:@supabase/supabase-js@2";
import {
  type LotPageData,
  pickLang,
  renderLotPage,
  renderNotFound,
} from "./page.ts";

const bucket = "public-lots";
const route =
  /\/([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})(\/report)?\/?$/i;

type Report = { document_id: string; file_kind: "pdf" | "photo"; storage_path: string };

function html(body: string, status: number): Response {
  return new Response(body, {
    status,
    headers: {
      "Content-Type": "text/html; charset=utf-8",
      // Yayımdan kaldırma kısa sürede yansısın.
      "Cache-Control": "public, max-age=60",
      "X-Content-Type-Options": "nosniff",
      "Referrer-Policy": "no-referrer",
      "Content-Security-Policy":
        "default-src 'none'; style-src 'unsafe-inline'; img-src data:; base-uri 'none'; form-action 'none'",
    },
  });
}

/// public-lots'taki `<lot_id>/` altında [keep] dışındaki kopyaları siler.
async function removeCopies(admin: SupabaseClient, lotId: string, keep?: string) {
  const { data } = await admin.storage.from(bucket).list(lotId);
  const stale = (data ?? [])
    .map((file) => `${lotId}/${file.name}`)
    .filter((path) => path !== keep);
  if (stale.length) await admin.storage.from(bucket).remove(stale);
}

/// Raporun public-lots'taki kopyası; yoksa documents'tan kopyalar.
async function reportCopy(
  admin: SupabaseClient,
  lotId: string,
  report: Report,
): Promise<{ body: Blob; type: string } | null> {
  const type = report.file_kind === "pdf" ? "application/pdf" : "image/jpeg";
  const path = `${lotId}/${report.document_id}.${report.file_kind === "pdf" ? "pdf" : "jpg"}`;
  const copy = await admin.storage.from(bucket).download(path);
  if (copy.data) return { body: copy.data, type };

  const source = await admin.storage.from("documents").download(report.storage_path);
  if (!source.data) return null;
  await admin.storage.from(bucket).upload(path, source.data, {
    contentType: type,
    upsert: true,
  });
  await removeCopies(admin, lotId, path);
  return { body: source.data, type };
}

Deno.serve(async (request) => {
  const lang = pickLang(request.headers.get("Accept-Language"));
  if (request.method !== "GET" && request.method !== "HEAD") {
    return new Response(null, { status: 405, headers: { Allow: "GET, HEAD" } });
  }
  const match = route.exec(new URL(request.url).pathname);
  if (!match) return html(renderNotFound(lang), 404);
  const lotId = match[1].toLowerCase();
  const wantsReport = match[2] !== undefined;

  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { auth: { persistSession: false } },
  );
  const { data, error } = await admin.rpc("lot_public_page", { lot_id: lotId });
  if (error) {
    console.error("lot_public_page", error);
    return new Response("error", { status: 500 });
  }
  const page = data as (LotPageData & { report?: Report }) | null;

  if (!page || !page.report) {
    // Yayımdan kalkan ya da raporu kapanan lotun kopyaları.
    await removeCopies(admin, lotId).catch((e) => console.error("remove", e));
    if (!page || wantsReport) return html(renderNotFound(lang), 404);
  }

  if (wantsReport) {
    const copy = await reportCopy(admin, lotId, page.report!);
    if (!copy) return html(renderNotFound(lang), 404);
    return new Response(copy.body, {
      headers: {
        "Content-Type": copy.type,
        "Cache-Control": "public, max-age=60",
        "X-Content-Type-Options": "nosniff",
      },
    });
  }

  return html(renderLotPage(page, lang, `${lotId}/report`), 200);
});
