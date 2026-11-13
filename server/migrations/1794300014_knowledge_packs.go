package migrations

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/files"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// knowledge_packs (P6.2): the counterpart of the Supabase `knowledge`
// bucket. One record per object: `manifest.json` and the versioned packages
// `knowledge-v<N>.json`. tool/publish_knowledge.dart --backend pocketbase
// writes them as a superuser: the package first, then the manifest; a name
// that exists already gets its file replaced.
//
// Fields: id (K-4; internal/ids gives a UUIDv7), name (the Supabase object
// name, unique) and file (one JSON file, 10 MB, as the bucket). The file is
// not protected, so the app downloads it without a file token; the list and
// view rules still need a signed-in user (Supabase: "knowledge girişli
// herkes okur"). Create, update and delete are nil: only the superuser
// writes.
func init() {
	m.Register(upKnowledgePacks, downKnowledgePacks)
}

const (
	knowledgePacksName = "knowledge_packs"
	// knowledgePackPattern: the manifest, or a package of version >= 1.
	knowledgePackPattern = `^(manifest|knowledge-v[1-9][0-9]{0,8})\.json$`
)

func upKnowledgePacks(app core.App) error {
	c := core.NewBaseCollection(knowledgePacksName)
	useUUIDPrimaryKey(c)
	c.Fields.Add(
		&core.TextField{Name: "name", Required: true, Max: 32, Pattern: knowledgePackPattern},
		&core.FileField{
			Name:      "file",
			Required:  true,
			MaxSelect: 1,
			MaxSize:   10 * files.MiB,
			MimeTypes: []string{"application/json"},
		},
	)
	c.AddIndex("idx_"+knowledgePacksName+"_name", true, "`name`", "")
	apiRules{list: types.Pointer(ruleSignedIn), view: types.Pointer(ruleSignedIn)}.apply(c)
	return app.Save(c)
}

func downKnowledgePacks(app core.App) error {
	c, err := app.FindCollectionByNameOrId(knowledgePacksName)
	if err != nil {
		return err
	}
	return app.Delete(c)
}
