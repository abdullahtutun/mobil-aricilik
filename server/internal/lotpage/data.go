package lotpage

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/types"
)

// Page is the data of a published lot: public.lot_public_page
// (20261102180000). The lot number and honey kind always; the rest only
// when the owner chose it. Nothing else is read: no telephone, address,
// location, registration or AKS number, e-mail or user.
type Page struct {
	// Number is "<year>-<seq, two digits>" (lot_rules.dart lotNumber).
	Number    string
	HoneyKind string
	// Producer: public_producer.
	Producer *Producer
	// Origin and HarvestMonth (YYYY-MM, the first harvest): public_origin;
	// either may be empty.
	Origin       string
	HarvestMonth string
	// Lab: public_lab, the latest analysis.
	Lab *Lab
	// Report: public_report, the latest analysis with a live document.
	Report *Report

	// orgID is the lot's organization: the report copy's org_id.
	orgID string
}

// Producer is the organization's name and its active hive count.
type Producer struct {
	Name      string
	HiveCount int
}

// Lab is one analysis; nil values were not measured.
type Lab struct {
	TestedOn                         string
	HMF, Diastase, Proline, Moisture *float64
	// Residue is "none", "detected" or empty.
	Residue string
}

// Report is the analysis report's document. StoragePath is its
// document_files path, the source of the copy; it is never shown.
type Report struct {
	DocumentID  string `db:"document_id"`
	FileKind    string `db:"file_kind"`
	StoragePath string `db:"storage_path"`
}

// Load returns the page of lotID, or nil when the lot does not exist, is
// deleted, is not published or its organization is deleted.
//
// Every read is tied to the lot's organization. Supabase's composite
// foreign keys did that; here push validation does, and the page repeats it
// so that a row pointing at another organization never shows.
func Load(app core.App, lotID string) (*Page, error) {
	lot, err := app.FindRecordById("lots", lotID)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	if lot.GetString("deleted_at") != "" || !lot.GetBool("published") {
		return nil, nil
	}
	orgID := lot.GetString("org_id")
	org, err := app.FindRecordById("organizations", orgID)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	if org.GetString("deleted_at") != "" {
		return nil, nil
	}

	p := &Page{
		Number:    fmt.Sprintf("%d-%02d", lot.GetInt("year"), lot.GetInt("seq")),
		HoneyKind: lot.GetString("honey_kind"),
		orgID:     orgID,
	}
	params := dbx.Params{"lot": lot.Id, "org": orgID}

	if lot.GetBool("public_producer") {
		n, err := app.CountRecords("hives", dbx.HashExp{"org_id": orgID, "status": "active", "deleted_at": ""})
		if err != nil {
			return nil, err
		}
		p.Producer = &Producer{Name: org.GetString("name"), HiveCount: int(n)}
	}

	if lot.GetBool("public_origin") {
		p.Origin = lot.GetString("origin")
		var first struct {
			At string `db:"at"`
		}
		err := app.DB().NewQuery(`
			SELECT COALESCE(MIN(h.harvested_at), '') AS at
			FROM lot_harvests lh
			JOIN harvests h ON h.id = lh.harvest_id AND h.org_id = lh.org_id AND h.deleted_at = ''
			WHERE lh.lot_id = {:lot} AND lh.org_id = {:org} AND lh.deleted_at = ''`).
			Bind(params).One(&first)
		if err != nil {
			return nil, err
		}
		// Sync times are UTC (K-5): the month is the first seven characters.
		if len(first.At) >= 7 {
			p.HarvestMonth = first.At[:7]
		}
	}

	if lot.GetBool("public_lab") {
		results, err := app.FindRecordsByFilter("lab_results",
			"lot_id = {:lot} && org_id = {:org} && deleted_at = ''",
			"-tested_on,-created_at", 1, 0, params)
		if err != nil {
			return nil, err
		}
		if len(results) == 1 {
			r := results[0]
			p.Lab = &Lab{
				TestedOn: r.GetString("tested_on"),
				HMF:      number(r, "hmf"),
				Diastase: number(r, "diastase"),
				Proline:  number(r, "proline"),
				Moisture: number(r, "moisture"),
				Residue:  r.GetString("residue"),
			}
		}
	}

	if lot.GetBool("public_report") {
		var rep Report
		err := app.DB().NewQuery(`
			SELECT d.id AS document_id, d.file_kind, d.storage_path
			FROM lab_results r
			JOIN documents d ON d.id = r.document_id AND d.org_id = r.org_id AND d.deleted_at = ''
			WHERE r.lot_id = {:lot} AND r.org_id = {:org} AND r.deleted_at = ''
			ORDER BY r.tested_on DESC, r.created_at DESC
			LIMIT 1`).
			Bind(params).One(&rep)
		switch {
		case errors.Is(err, sql.ErrNoRows):
		case err != nil:
			return nil, err
		default:
			p.Report = &rep
		}
	}
	return p, nil
}

// number reads a JSON number field (numeric columns are JSON, P2.5); nil
// when it is empty or null.
func number(r *core.Record, field string) *float64 {
	raw, ok := r.Get(field).(types.JSONRaw)
	if !ok || len(raw) == 0 {
		return nil
	}
	var v *float64
	if json.Unmarshal(raw, &v) != nil {
		return nil
	}
	return v
}
