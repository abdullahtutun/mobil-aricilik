package authz_test

import (
	"path/filepath"
	"slices"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/pocketbase/pocketbase/core"
)

// The authorization scenarios of supabase/tests/database/*_rls.test.sql,
// one subtest per pgTAP assertion, named `<pgTAP file>/<its description>`.
// "Başka işletme" is outsider (owner of orgE) acting on orgA.
//
// Not carried here, because they are not authorization: cross-organization
// links (the composite FKs, 23503 → push missing_reference, P5.3), CHECKs
// (internal/validate, P5.3), sync_push behaviour (P5.2–P5.3), storage
// buckets (P6.1), triggers (task assignment, P5.6) and the invite code's
// shape and expiry (P5.4).

// check is one expectation: may user do action on a row of table in org?
// Read goes through CanSeeRow (rowUser is the row's user_id), the writes
// through Can.
type check struct {
	user    string
	action  authz.Action
	table   string
	org     string
	rowUser string
	want    bool
}

func sees(user, table, org string) check   { return check{user, authz.Read, table, org, "", true} }
func hidden(user, table, org string) check { return check{user, authz.Read, table, org, "", false} }
func may(user string, a authz.Action, table, org string) check {
	return check{user, a, table, org, "", true}
}
func mayNot(user string, a authz.Action, table, org string) check {
	return check{user, a, table, org, "", false}
}
func seesRow(user, table, org, rowUser string) check {
	return check{user, authz.Read, table, org, rowUser, true}
}
func hiddenRow(user, table, org, rowUser string) check {
	return check{user, authz.Read, table, org, rowUser, false}
}

// remove is the delete a client might try; authz has no such action.
const remove authz.Action = "delete"

// otherOrgSees is the usual first assertion: outsider does not see orgA's
// row, and sees its own organization's.
func otherOrgSees(table string) []check {
	return []check{hidden(outsider, table, orgA), sees(outsider, table, orgE)}
}

type scenario struct {
	desc   string
	checks []check
}

var rlsScenarios = map[string][]scenario{
	"customers_rls.test.sql": {
		{"başka işletmenin müşterisini göremez, yalnız kendisininkini görür", otherOrgSees("customers")},
		{"başka işletmenin tahsilatını göremez", []check{hidden(outsider, "customer_payments", orgA)}},
		{"başka işletmeye müşteri ekleyemez", []check{mayNot(outsider, authz.Insert, "customers", orgA)}},
		{"başka işletmenin müşterisini güncelleyemez", []check{mayNot(outsider, authz.Update, "customers", orgA)}},
		{"partner işletmenin müşterilerini görür", []check{sees(partner, "customers", orgA)}},
		{"partner müşterili satışa tahsilat ekler", []check{
			may(partner, authz.Insert, "customer_payments", orgA),
			may(partner, authz.Insert, "transactions", orgA),
		}},
		{"worker müşterileri göremez", []check{hidden(worker, "customers", orgA)}},
		{"worker tahsilatları göremez", []check{hidden(worker, "customer_payments", orgA)}},
		{"worker senkronla da müşteri yazamaz", []check{
			mayNot(worker, authz.Insert, "customers", orgA),
			mayNot(worker, authz.Update, "customers", orgA),
		}},
		{"viewer müşterileri göremez", []check{hidden(viewer, "customers", orgA)}},
	},
	"device_tokens_rls.test.sql": {
		{"kullanıcı yalnız kendi token'ını görür", []check{
			seesRow(worker, "device_tokens", "", worker),
			hiddenRow(worker, "device_tokens", "", owner),
		}},
		{"istemci token yazamaz", []check{mayNot(worker, authz.Insert, "device_tokens", "")}},
		{"istemci token güncelleyemez", []check{mayNot(worker, authz.Update, "device_tokens", "")}},
		{"istemci token silemez", []check{mayNot(worker, remove, "device_tokens", "")}},
	},
	"documents_rls.test.sql": {
		{"başka işletmenin belgesini göremez, yalnız kendisininkini görür", otherOrgSees("documents")},
		{"başka işletmeye belge ekleyemez", []check{mayNot(outsider, authz.Insert, "documents", orgA)}},
		{"başka işletmenin belgesini güncelleyemez", []check{mayNot(outsider, authz.Update, "documents", orgA)}},
		{"worker belge ekler", []check{may(worker, authz.Insert, "documents", orgA)}},
		{"worker belgenin geçerlilik tarihini günceller", []check{may(worker, authz.Update, "documents", orgA)}},
		{"viewer belge ekleyemez", []check{mayNot(viewer, authz.Insert, "documents", orgA)}},
	},
	"feedings_rls.test.sql": {
		{"başka işletmenin beslemesini göremez, yalnız kendisininkini görür", otherOrgSees("feedings")},
		{"başka işletmeye besleme ekleyemez", []check{mayNot(outsider, authz.Insert, "feedings", orgA)}},
		{"başka işletmenin beslemesini silemez", []check{
			mayNot(outsider, authz.Update, "feedings", orgA),
			mayNot(outsider, remove, "feedings", orgA),
		}},
		{"worker polen ikamesi ekler", []check{may(worker, authz.Insert, "feedings", orgA)}},
		{"viewer besleme ekleyemez, ama işletmenin beslemelerini görür", []check{
			mayNot(viewer, authz.Insert, "feedings", orgA),
			sees(viewer, "feedings", orgA),
		}},
	},
	"harvests_rls.test.sql": {
		{"başka işletmenin hasadını göremez, yalnız kendisininkini görür", otherOrgSees("harvests")},
		{"başka işletmenin hasat kovanlarını göremez", []check{hidden(outsider, "harvest_hives", orgA)}},
		{"başka işletmeye hasat ekleyemez", []check{mayNot(outsider, authz.Insert, "harvests", orgA)}},
		{"başka işletmenin hasadını silemez", []check{
			mayNot(outsider, authz.Update, "harvests", orgA),
			mayNot(outsider, remove, "harvests", orgA),
		}},
		{"worker hasat ekler", []check{may(worker, authz.Insert, "harvests", orgA)}},
		{"worker bekleme süresindeki kovanı gerekçesiyle hasada ekler", []check{may(worker, authz.Insert, "harvest_hives", orgA)}},
		{"viewer hasat ekleyemez", []check{mayNot(viewer, authz.Insert, "harvests", orgA)}},
		{"viewer hasada kovan ekleyemez, ama işletmenin hasatlarını görür", []check{
			mayNot(viewer, authz.Insert, "harvest_hives", orgA),
			sees(viewer, "harvests", orgA),
			sees(viewer, "harvest_hives", orgA),
		}},
	},
	"hive_status_events_rls.test.sql": {
		{"başka işletmenin olayını göremez, yalnız kendisininkini görür", otherOrgSees("hive_status_events")},
		{"başka işletmeye olay ekleyemez", []check{mayNot(outsider, authz.Insert, "hive_status_events", orgA)}},
		{"başka işletmenin olayını silemez", []check{
			mayNot(outsider, authz.Update, "hive_status_events", orgA),
			mayNot(outsider, remove, "hive_status_events", orgA),
		}},
		{"worker kayıp nedeniyle olay ekler", []check{may(worker, authz.Insert, "hive_status_events", orgA)}},
		{"viewer olay ekleyemez, ama işletmenin olaylarını görür", []check{
			mayNot(viewer, authz.Insert, "hive_status_events", orgA),
			sees(viewer, "hive_status_events", orgA),
		}},
	},
	"hives_rls.test.sql": {
		{"başka işletmenin kovanını göremez, yalnız kendi kovanını görür", otherOrgSees("hives")},
		{"başka işletmenin arılığını göremez", []check{hidden(outsider, "apiaries", orgA)}},
		{"başka işletmenin anasını göremez", []check{hidden(outsider, "queens", orgA)}},
		{"başka işletmenin kovan geçmişini göremez", []check{hidden(outsider, "hive_location_history", orgA)}},
		{"başka işletmenin kovanını güncelleyemez", []check{mayNot(outsider, authz.Update, "hives", orgA)}},
		{"başka işletmeye kovan ekleyemez", []check{mayNot(outsider, authz.Insert, "hives", orgA)}},
		{"worker yalnız kendi işletmesinin kovanını görür", []check{
			sees(worker, "hives", orgA),
			hidden(worker, "hives", orgE),
		}},
		{"worker kovan ekler", []check{may(worker, authz.Insert, "hives", orgA)}},
		{"worker kovanı günceller", []check{may(worker, authz.Update, "hives", orgA)}},
		{"viewer işletmesinin kovanlarını görür", []check{sees(viewer, "hives", orgA)}},
		{"viewer arılık ekleyemez", []check{mayNot(viewer, authz.Insert, "apiaries", orgA)}},
		{"viewer ana arı ekleyemez", []check{mayNot(viewer, authz.Insert, "queens", orgA)}},
		{"viewer kovan ekleyemez", []check{mayNot(viewer, authz.Insert, "hives", orgA)}},
		{"viewer kovan geçmişi ekleyemez", []check{mayNot(viewer, authz.Insert, "hive_location_history", orgA)}},
		{"viewer arılığı güncelleyemez", []check{mayNot(viewer, authz.Update, "apiaries", orgA)}},
		{"viewer anayı güncelleyemez", []check{mayNot(viewer, authz.Update, "queens", orgA)}},
		{"viewer kovanı güncelleyemez ve silinmiş olarak işaretleyemez", []check{mayNot(viewer, authz.Update, "hives", orgA)}},
		{"viewer kovan geçmişini güncelleyemez", []check{mayNot(viewer, authz.Update, "hive_location_history", orgA)}},
		{"owner da kovan satırını silemez; silme deleted_at ile yapılır", []check{
			mayNot(owner, remove, "hives", orgA),
			may(owner, authz.Update, "hives", orgA),
		}},
		{"viewer'ın güncelleme ve silme denemeleri kovanlara dokunmadı", []check{
			mayNot(viewer, authz.Update, "hives", orgA),
			mayNot(viewer, remove, "hives", orgA),
		}},
		{"anon hiçbir kovanı göremez", []check{hidden(anon, "hives", orgA), hidden(anon, "hives", orgE)}},
	},
	"inspections_rls.test.sql": {
		{"başka işletmenin muayenesini göremez, yalnız kendi muayenesini görür", otherOrgSees("inspections")},
		{"başka işletmenin muayenesini güncelleyemez", []check{mayNot(outsider, authz.Update, "inspections", orgA)}},
		{"başka işletmeye muayene ekleyemez", []check{mayNot(outsider, authz.Insert, "inspections", orgA)}},
		{"worker bütün alanlarıyla muayene ekler", []check{may(worker, authz.Insert, "inspections", orgA)}},
		{"viewer işletmesinin muayenelerini görür", []check{sees(viewer, "inspections", orgA)}},
		{"viewer muayene ekleyemez", []check{mayNot(viewer, authz.Insert, "inspections", orgA)}},
		{"viewer muayeneyi güncelleyemez ve silinmiş olarak işaretleyemez", []check{mayNot(viewer, authz.Update, "inspections", orgA)}},
	},
	"inventory_rls.test.sql": {
		{"başka işletmenin kalemini göremez, yalnız kendisininkini görür", otherOrgSees("inventory_items")},
		{"başka işletmenin hareketini göremez", []check{hidden(outsider, "inventory_moves", orgA)}},
		{"başka işletmeye kalem ekleyemez", []check{mayNot(outsider, authz.Insert, "inventory_items", orgA)}},
		{"başka işletmenin kalemini güncelleyemez", []check{mayNot(outsider, authz.Update, "inventory_items", orgA)}},
		{"worker eşiksiz ve yeri yazılmamış kalem ekler", []check{may(worker, authz.Insert, "inventory_items", orgA)}},
		{"worker bağlı kayıtlı çıkış ekler", []check{may(worker, authz.Insert, "inventory_moves", orgA)}},
		{"viewer hareket ekleyemez, ama işletmenin hareketlerini görür", []check{
			mayNot(viewer, authz.Insert, "inventory_moves", orgA),
			sees(viewer, "inventory_moves", orgA),
		}},
	},
	"invites_rls.test.sql": {
		{"owner davet üretir", []check{may(owner, authz.Insert, "invites", orgA)}},
		{"partner davet üretir", []check{may(partner, authz.Insert, "invites", orgA)}},
		{"worker davet üretemez", []check{mayNot(worker, authz.Insert, "invites", orgA)}},
		{"viewer davet üretemez", []check{mayNot(viewer, authz.Insert, "invites", orgA)}},
		{"başka işletmeye davet üretilemez", []check{mayNot(owner, authz.Insert, "invites", orgE)}},
	},
	"lots_rls.test.sql": {
		{"başka işletmenin lotunu göremez, yalnız kendisininkini görür", otherOrgSees("lots")},
		{"başka işletmenin lot hasadını göremez", []check{hidden(outsider, "lot_harvests", orgA)}},
		{"başka işletmeye lot ekleyemez", []check{mayNot(outsider, authz.Insert, "lots", orgA)}},
		{"başka işletmenin lotunu güncelleyemez", []check{mayNot(outsider, authz.Update, "lots", orgA)}},
		{"worker lota kovanın son ilaçlamasını bağlar", []check{may(worker, authz.Insert, "lot_treatments", orgA)}},
		{"worker raporlu analiz ekler", []check{may(worker, authz.Insert, "lab_results", orgA)}},
		{"worker lottan satış düşer", []check{may(worker, authz.Insert, "lot_sales", orgA)}},
		{"viewer işletmenin analizlerini görür", []check{sees(viewer, "lab_results", orgA)}},
		{"viewer satış düşemez", []check{mayNot(viewer, authz.Insert, "lot_sales", orgA)}},
	},
	"media_rls.test.sql": {
		{"başka işletmenin medyasını göremez, yalnız kendisininkini görür", otherOrgSees("media")},
		{"başka işletmeye medya ekleyemez", []check{mayNot(outsider, authz.Insert, "media", orgA)}},
		{"worker muayeneye bağlı foto ekler", []check{may(worker, authz.Insert, "media", orgA)}},
		{"worker kovana sesli not ekler", []check{may(worker, authz.Insert, "media", orgA)}},
		{"viewer medya ekleyemez", []check{mayNot(viewer, authz.Insert, "media", orgA)}},
	},
	"memberships_rls.test.sql": {
		{"üye olmayan işletmenin üyeliklerini göremez", []check{
			hiddenRow(outsider, "memberships", orgA, owner),
			hiddenRow(outsider, "memberships", orgA, worker),
		}},
		{"worker işletmedeki tüm üyelikleri görür", []check{
			seesRow(worker, "memberships", orgA, owner),
			seesRow(worker, "memberships", orgA, worker),
			hiddenRow(worker, "memberships", orgE, outsider),
		}},
		{"worker üye ekleyemez", []check{mayNot(worker, authz.Insert, "memberships", orgA)}},
		{"worker kendi rolünü yükseltemez", []check{mayNot(worker, authz.Update, "memberships", orgA)}},
		{"owner üye ekler", []check{may(owner, authz.Insert, "memberships", orgA)}},
		{"owner başka işletmeye üye ekleyemez", []check{mayNot(owner, authz.Insert, "memberships", orgE)}},
		{"owner üyeyi deleted_at ile çıkarır", []check{may(owner, authz.Update, "memberships", orgA)}},
		{"üyelik satırı silinemez", []check{mayNot(owner, remove, "memberships", orgA)}},
		{"çıkarılan üye işletmeyi göremez", []check{hidden(removed, "organizations", orgA)}},
		{"çıkarılan üye yalnız kendi silinmiş üyeliğini görür", []check{
			seesRow(removed, "memberships", orgA, removed),
			hiddenRow(removed, "memberships", orgA, owner),
			hiddenRow(removed, "memberships", orgA, worker),
		}},
	},
	"migrations_rls.test.sql": {
		{"başka işletmenin göç planını göremez, yalnız kendisininkini görür", otherOrgSees("migrations")},
		{"başka işletmenin durağını göremez, yalnız kendisininkini görür", otherOrgSees("migration_stops")},
		{"başka işletmeye göç planı ekleyemez", []check{mayNot(outsider, authz.Insert, "migrations", orgA)}},
		{"başka işletmenin durağını güncelleyemez", []check{mayNot(outsider, authz.Update, "migration_stops", orgA)}},
		{"worker göç planı ekler", []check{may(worker, authz.Insert, "migrations", orgA)}},
		{"worker hedef arılığı olmayan durak ekler; durum varsayılan olarak plan", []check{may(worker, authz.Insert, "migration_stops", orgA)}},
		{"worker durağın durumunu günceller", []check{may(worker, authz.Update, "migration_stops", orgA)}},
		{"viewer göç planı ekleyemez", []check{mayNot(viewer, authz.Insert, "migrations", orgA)}},
		{"viewer durağı güncelleyemez", []check{mayNot(viewer, authz.Update, "migration_stops", orgA)}},
		{"viewer işletmenin duraklarını görür", []check{sees(viewer, "migration_stops", orgA)}},
	},
	"mite_counts_rls.test.sql": {
		{"başka işletmenin ölçümünü göremez, yalnız kendisininkini görür", otherOrgSees("mite_counts")},
		{"başka işletmeye ölçüm ekleyemez", []check{mayNot(outsider, authz.Insert, "mite_counts", orgA)}},
		{"başka işletmenin ölçümünü silemez", []check{
			mayNot(outsider, authz.Update, "mite_counts", orgA),
			mayNot(outsider, remove, "mite_counts", orgA),
		}},
		{"worker alkol yıkaması ekler", []check{may(worker, authz.Insert, "mite_counts", orgA)}},
		{"worker alt tabla sayımı ekler", []check{may(worker, authz.Insert, "mite_counts", orgA)}},
		{"viewer ölçüm ekleyemez, ama işletmenin ölçümlerini görür", []check{
			mayNot(viewer, authz.Insert, "mite_counts", orgA),
			sees(viewer, "mite_counts", orgA),
		}},
	},
	"organizations_rls.test.sql": {
		{"üye olmayan işletmeyi göremez", []check{hidden(outsider, "organizations", orgA)}},
		{"üye olmayan işletmeyi güncelleyemez", []check{mayNot(outsider, authz.Update, "organizations", orgA)}},
		{"worker üyesi olduğu işletmeyi görür", []check{
			sees(worker, "organizations", orgA),
			hidden(worker, "organizations", orgE),
		}},
		{"worker işletmeyi güncelleyemez", []check{mayNot(worker, authz.Update, "organizations", orgA)}},
		{"işletme doğrudan eklenemez, yalnız create_organization ile", []check{
			mayNot(worker, authz.Insert, "organizations", "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"),
			mayNot(owner, authz.Insert, "organizations", orgA),
		}},
		{"partner işletmeyi günceller", []check{may(partner, authz.Update, "organizations", orgA)}},
		{"owner işletmeyi günceller", []check{may(owner, authz.Update, "organizations", orgA)}},
		{"owner da satırı silemez; silme deleted_at ile yapılır", []check{mayNot(owner, remove, "organizations", orgA)}},
		{"anon hiçbir işletmeyi göremez", []check{hidden(anon, "organizations", orgA), hidden(anon, "organizations", orgE)}},
	},
	"queen_rearing_rls.test.sql": {
		{"başka işletmenin serisini göremez, yalnız kendisininkini görür", otherOrgSees("queen_rearing_batches")},
		{"başka işletmenin kutusunu göremez, yalnız kendisininkini görür", otherOrgSees("mating_nucs")},
		{"başka işletmeye seri ekleyemez", []check{mayNot(outsider, authz.Insert, "queen_rearing_batches", orgA)}},
		{"başka işletmenin kutusunu güncelleyemez", []check{mayNot(outsider, authz.Update, "mating_nucs", orgA)}},
		{"viewer seri ekleyemez", []check{mayNot(viewer, authz.Insert, "queen_rearing_batches", orgA)}},
		{"viewer kutuyu güncelleyemez", []check{mayNot(viewer, authz.Update, "mating_nucs", orgA)}},
		{"worker kutudan anayı kovana verir", []check{
			may(worker, authz.Update, "mating_nucs", orgA),
			may(worker, authz.Insert, "queens", orgA),
		}},
		{"worker ana yetiştirme görevi açar", []check{may(worker, authz.Insert, "tasks", orgA)}},
	},
	"tasks_rls.test.sql": {
		{"başka işletmenin görevini göremez, yalnız kendisininkini görür", otherOrgSees("tasks")},
		{"başka işletmeye görev ekleyemez", []check{mayNot(outsider, authz.Insert, "tasks", orgA)}},
		{"başka işletmenin görevini tamamlayamaz", []check{mayNot(outsider, authz.Update, "tasks", orgA)}},
		{"worker kovana bağlı görev ekler ve kendine atar", []check{may(worker, authz.Insert, "tasks", orgA)}},
		{"worker başkasına atanmış görevi tamamlar", []check{may(worker, authz.Update, "tasks", orgA)}},
		{"viewer görev ekleyemez, ama işletmenin görevlerini görür", []check{
			mayNot(viewer, authz.Insert, "tasks", orgA),
			sees(viewer, "tasks", orgA),
		}},
	},
	"transactions_rls.test.sql": {
		{"başka işletmenin hareketini göremez, yalnız kendisininkini görür", otherOrgSees("transactions")},
		{"başka işletmeye hareket ekleyemez", []check{mayNot(outsider, authz.Insert, "transactions", orgA)}},
		{"başka işletmenin hareketini güncelleyemez", []check{mayNot(outsider, authz.Update, "transactions", orgA)}},
		{"partner lot satışına bağlı, fişli gelir ekler", []check{may(partner, authz.Insert, "transactions", orgA)}},
		{"worker finans hareketlerini göremez", []check{hidden(worker, "transactions", orgA)}},
		{"worker gider ekleyemez", []check{mayNot(worker, authz.Insert, "transactions", orgA)}},
		{"worker senkronla da hareket yazamaz", []check{
			mayNot(worker, authz.Insert, "transactions", orgA),
			mayNot(worker, authz.Update, "transactions", orgA),
		}},
		{"viewer finans hareketlerini göremez", []check{hidden(viewer, "transactions", orgA)}},
	},
	"transports_rls.test.sql": {
		{"başka işletmenin taşımasını göremez, yalnız kendisininkini görür", otherOrgSees("transports")},
		{"başka işletmenin taşınan kovanını göremez, yalnız kendisininkini görür", otherOrgSees("transport_items")},
		{"başka işletmeye taşıma ekleyemez", []check{mayNot(outsider, authz.Insert, "transports", orgA)}},
		{"başka işletmenin taşınan kovanını güncelleyemez", []check{mayNot(outsider, authz.Update, "transport_items", orgA)}},
		{"worker kovanı taşımaya yükler", []check{may(worker, authz.Insert, "transport_items", orgA)}},
		{"worker kovanı indirir", []check{may(worker, authz.Update, "transport_items", orgA)}},
		{"viewer taşıma ekleyemez", []check{mayNot(viewer, authz.Insert, "transports", orgA)}},
		{"viewer taşınan kovanı güncelleyemez", []check{mayNot(viewer, authz.Update, "transport_items", orgA)}},
	},
	"treatments_rls.test.sql": {
		{"girişli kullanıcı referans listenin GLOBAL ve TR satırlarını görür", []check{
			sees(outsider, "ref_drugs", ""),
			sees(viewer, "ref_drugs", ""),
			sees(newcomer, "ref_drugs", ""),
			hidden(anon, "ref_drugs", ""),
		}},
		{"referans listeye kimse ekleyemez", []check{
			mayNot(owner, authz.Insert, "ref_drugs", orgA),
			mayNot(owner, authz.Insert, "ref_drugs", ""),
		}},
		{"referans listeyi kimse güncelleyemez", []check{
			mayNot(owner, authz.Update, "ref_drugs", orgA),
			mayNot(owner, authz.Update, "ref_drugs", ""),
		}},
		{"başka işletmenin ilaçlarını göremez, yalnız kendisininkini görür", otherOrgSees("drugs")},
		{"başka işletmenin uygulamalarını göremez, yalnız kendisininkini görür", otherOrgSees("treatments")},
		{"başka işletmeye ilaç ekleyemez", []check{mayNot(outsider, authz.Insert, "drugs", orgA)}},
		{"başka işletmeye uygulama ekleyemez", []check{mayNot(outsider, authz.Insert, "treatments", orgA)}},
		{"başka işletmenin uygulamasını silemez", []check{
			mayNot(outsider, authz.Update, "treatments", orgA),
			mayNot(outsider, remove, "treatments", orgA),
		}},
		{"worker referans listeden ilaçla uygulama ekler", []check{may(worker, authz.Insert, "treatments", orgA)}},
		{"worker ilaç ekler", []check{may(worker, authz.Insert, "drugs", orgA)}},
		{"viewer uygulama ekleyemez, ama işletmenin uygulamalarını görür", []check{
			mayNot(viewer, authz.Insert, "treatments", orgA),
			sees(viewer, "treatments", orgA),
		}},
	},
}

func TestRLSScenarios(t *testing.T) {
	app, _ := fixture(t)
	for _, file := range sortedKeys(rlsScenarios) {
		t.Run(file, func(t *testing.T) {
			for _, s := range rlsScenarios[file] {
				t.Run(s.desc, func(t *testing.T) {
					if len(s.checks) == 0 {
						t.Fatal("no checks")
					}
					for _, c := range s.checks {
						runCheck(t, app, c)
					}
				})
			}
		})
	}
}

func runCheck(t *testing.T, app core.App, c check) {
	t.Helper()
	var got bool
	var err error
	if c.action == authz.Read {
		got, err = authz.CanSeeRow(app, c.table, rowOf(c.table, c.org, c.rowUser), c.user)
	} else {
		got, err = authz.Can(app, c.user, c.table, c.org, c.action)
	}
	if err != nil {
		t.Fatalf("%+v: %v", c, err)
	}
	if got != c.want {
		t.Errorf("%s %s %s in %q (row user %q) = %v, want %v", c.user, c.action, c.table, c.org, c.rowUser, got, c.want)
	}

	// The pull filter must agree with CanSeeRow for org-scoped tables.
	p := authz.Policies[c.table]
	if c.action == authz.Read && c.org != "" && (p.Scope == authz.ScopeOrg || p.Scope == authz.ScopeOrganization) {
		orgs, err := authz.OrgIDsForUser(app, c.user, p.Read...)
		if err != nil {
			t.Fatal(err)
		}
		if in := slices.Contains(orgs, c.org); in != c.want {
			t.Errorf("%s reads %s: OrgIDsForUser(%v) = %v, contains %s = %v, want %v", c.user, c.table, p.Read, orgs, c.org, in, c.want)
		}
	}
}

func sortedKeys[V any](m map[string]V) []string {
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	slices.Sort(keys)
	return keys
}

// Every *_rls.test.sql file has scenarios here: a new pgTAP RLS file
// without a Go counterpart breaks the test.
func TestEveryRLSFileCarried(t *testing.T) {
	files, err := filepath.Glob(filepath.Join("..", "..", "..", "supabase", "tests", "database", "*_rls.test.sql"))
	if err != nil || len(files) == 0 {
		t.Fatalf("no pgTAP RLS tests found: %v", err)
	}
	for _, f := range files {
		if _, ok := rlsScenarios[filepath.Base(f)]; !ok {
			t.Errorf("%s: no Go scenarios", filepath.Base(f))
		}
	}
	for name := range rlsScenarios {
		if !slices.ContainsFunc(files, func(f string) bool { return filepath.Base(f) == name }) {
			t.Errorf("%s: scenarios for a pgTAP file that does not exist", name)
		}
	}
}

// memberships_rls.test.sql, the removal itself: owner sets deleted_at on
// the worker's membership; the worker loses read and write on the
// organization's data, and still sees its own removed membership.
func TestMembershipRemoval(t *testing.T) {
	app, members := fixture(t)

	before := []check{
		sees(worker, "hives", orgA),
		sees(worker, "organizations", orgA),
		may(worker, authz.Insert, "hives", orgA),
		may(worker, authz.Update, "inspections", orgA),
		seesRow(worker, "memberships", orgA, owner),
	}
	for _, c := range before {
		runCheck(t, app, c)
	}
	runCheck(t, app, may(owner, authz.Update, "memberships", orgA))

	m := members[worker]
	m.Set("deleted_at", removedTime)
	m.Set("updated_at", removedTime)
	if err := app.Save(m); err != nil {
		t.Fatal(err)
	}

	after := []check{
		hidden(worker, "hives", orgA),
		hidden(worker, "organizations", orgA),
		mayNot(worker, authz.Insert, "hives", orgA),
		mayNot(worker, authz.Update, "inspections", orgA),
		hiddenRow(worker, "memberships", orgA, owner),
	}
	for _, c := range after {
		runCheck(t, app, c)
	}
	// Its own row, as stored.
	stored, err := app.FindRecordById("memberships", m.Id)
	if err != nil {
		t.Fatal(err)
	}
	if ok, err := authz.CanSeeRow(app, "memberships", stored, worker); err != nil || !ok {
		t.Errorf("removed worker sees its own membership = %v, %v; want true", ok, err)
	}
	if orgs, _ := authz.OrgIDsForUser(app, worker); len(orgs) != 0 {
		t.Errorf("OrgIDsForUser after removal = %v, want none", orgs)
	}
}
