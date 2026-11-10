package migrations

import (
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

// The ref_drugs rows of Supabase, with the same ids and values:
// 20261025200000_treatments (8 GLOBAL + 2 sample TR rows),
// 20261031200000_tr_ref_drugs (the 2 sample TR rows soft-deleted, 7 TR
// strips) and 20261101120000_tr_ref_drugs_amitraz (4 TR amitraz products).
// The times are the live project's (jcddnelaboueazhordfz, read 2026-11-10);
// the SQL wrote now(). The client links treatments and assets/drugs/
// ilaclar.json to these ids.
func init() {
	m.Register(upRefDrugsSeed, downRefDrugsSeed)
}

// Times the three Supabase migrations ran (K-5 text).
const (
	refDrugsTime1 = "2026-10-25T19:16:45.608263Z" // 20261025200000
	refDrugsTime2 = "2026-10-31T20:32:34.866517Z" // 20261031200000
	refDrugsTime3 = "2026-10-31T20:55:59.844589Z" // 20261101120000
)

// refDrug is one ref_drugs row. withdrawalDays nil is SQL null; license_no is
// null in every row.
type refDrug struct {
	id, countryCode, nameTR, nameEN, activeIngredient, doseUnit string
	withdrawalDays                                              *int
	createdAt, updatedAt, deletedAt                             string
}

func days(n int) *int { return &n }

// refDrugRows are the Supabase rows, in id order.
var refDrugRows = []refDrug{
	// 20261025200000.
	{"01900000-0000-7000-8000-000000000001", "GLOBAL", "Amitraz", "Amitraz", "amitraz", "strip", nil, refDrugsTime1, refDrugsTime1, ""},
	{"01900000-0000-7000-8000-000000000002", "GLOBAL", "Oksalik asit", "Oxalic acid", "oxalic_acid", "ml", nil, refDrugsTime1, refDrugsTime1, ""},
	{"01900000-0000-7000-8000-000000000003", "GLOBAL", "Formik asit", "Formic acid", "formic_acid", "ml", nil, refDrugsTime1, refDrugsTime1, ""},
	{"01900000-0000-7000-8000-000000000004", "GLOBAL", "Timol", "Thymol", "thymol", "g", nil, refDrugsTime1, refDrugsTime1, ""},
	{"01900000-0000-7000-8000-000000000005", "GLOBAL", "Flumetrin", "Flumethrin", "flumethrin", "strip", nil, refDrugsTime1, refDrugsTime1, ""},
	{"01900000-0000-7000-8000-000000000006", "GLOBAL", "Tau-fluvalinat", "Tau-fluvalinate", "tau_fluvalinate", "strip", nil, refDrugsTime1, refDrugsTime1, ""},
	{"01900000-0000-7000-8000-000000000007", "GLOBAL", "Kumafos", "Coumaphos", "coumaphos", "strip", nil, refDrugsTime1, refDrugsTime1, ""},
	{"01900000-0000-7000-8000-000000000008", "GLOBAL", "Laktik asit", "Lactic acid", "lactic_acid", "ml", nil, refDrugsTime1, refDrugsTime1, ""},
	// 20261025200000, soft-deleted by 20261031200000.
	{"01900000-0000-7000-8000-000000000101", "TR", "Amitraz şerit", "Amitraz strip", "amitraz", "strip", nil, refDrugsTime1, refDrugsTime2, refDrugsTime2},
	{"01900000-0000-7000-8000-000000000102", "TR", "Oksalik asit damlatma", "Oxalic acid trickling", "oxalic_acid", "ml", nil, refDrugsTime1, refDrugsTime2, refDrugsTime2},
	// 20261031200000.
	{"01900000-0000-7000-8000-000000000201", "TR", "Bayvarol Kovan İçi Şerit", "Bayvarol in-hive strip", "flumethrin", "strip", days(0), refDrugsTime2, refDrugsTime2, ""},
	{"01900000-0000-7000-8000-000000000202", "TR", "BEERAZ Arı Kovanı Şeridi", "BEERAZ hive strip", "amitraz", "strip", nil, refDrugsTime2, refDrugsTime2, ""},
	{"01900000-0000-7000-8000-000000000203", "TR", "BEEVARFLU Arı Kovanı Şeridi", "BEEVARFLU hive strip", "flumethrin", "strip", days(0), refDrugsTime2, refDrugsTime2, ""},
	{"01900000-0000-7000-8000-000000000204", "TR", "CheckMite Kovan İçi Şerit", "CheckMite in-hive strip", "coumaphos", "strip", days(0), refDrugsTime2, refDrugsTime2, ""},
	{"01900000-0000-7000-8000-000000000205", "TR", "FUMBEE Kovan İçi Şerit", "FUMBEE in-hive strip", "flumethrin", "strip", nil, refDrugsTime2, refDrugsTime2, ""},
	{"01900000-0000-7000-8000-000000000206", "TR", "PolyVar Yellow Kovan Şeridi", "PolyVar Yellow hive strip", "flumethrin", "strip", days(0), refDrugsTime2, refDrugsTime2, ""},
	{"01900000-0000-7000-8000-000000000207", "TR", "VARODUR Arı Kovanı Şeridi", "VARODUR hive strip", "flumethrin", "strip", days(0), refDrugsTime2, refDrugsTime2, ""},
	// 20261101120000.
	{"01900000-0000-7000-8000-000000000208", "TR", "Rulamit", "Rulamit", "amitraz", "strip", nil, refDrugsTime3, refDrugsTime3, ""},
	{"01900000-0000-7000-8000-000000000209", "TR", "Rulamit-Va", "Rulamit-Va", "amitraz", "strip", nil, refDrugsTime3, refDrugsTime3, ""},
	{"01900000-0000-7000-8000-000000000210", "TR", "Vamitrat-Va", "Vamitrat-Va", "amitraz", "strip", nil, refDrugsTime3, refDrugsTime3, ""},
	{"01900000-0000-7000-8000-000000000211", "TR", "Varroset", "Varroset", "amitraz", "dose", nil, refDrugsTime3, refDrugsTime3, ""},
}

func upRefDrugsSeed(app core.App) error {
	c, err := app.FindCollectionByNameOrId("ref_drugs")
	if err != nil {
		return err
	}
	return app.RunInTransaction(func(txApp core.App) error {
		for _, d := range refDrugRows {
			r := core.NewRecord(c)
			r.Id = d.id
			r.Set("country_code", d.countryCode)
			r.Set("name_tr", d.nameTR)
			r.Set("name_en", d.nameEN)
			r.Set("active_ingredient", d.activeIngredient)
			r.Set("dose_unit", d.doseUnit)
			if d.withdrawalDays != nil {
				r.Set("withdrawal_days", *d.withdrawalDays)
			} else {
				r.Set("withdrawal_days", nil)
			}
			r.Set("created_at", d.createdAt)
			r.Set("updated_at", d.updatedAt)
			r.Set("deleted_at", d.deletedAt)
			// The seq hook (when bound) replaces this number with another
			// one; taking it here keeps the migration valid without hooks.
			seq, err := appsync.NextSeq(txApp)
			if err != nil {
				return err
			}
			r.Set("server_seq", seq)
			if err := txApp.Save(r); err != nil {
				return err
			}
		}
		return nil
	})
}

func downRefDrugsSeed(app core.App) error {
	return app.RunInTransaction(func(txApp core.App) error {
		for _, d := range refDrugRows {
			r, err := txApp.FindRecordById("ref_drugs", d.id)
			if err != nil {
				return err
			}
			if err := txApp.Delete(r); err != nil {
				return err
			}
		}
		return nil
	})
}
