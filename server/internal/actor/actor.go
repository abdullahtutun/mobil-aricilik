// Package actor carries the signed-in user who causes a write into the
// record hooks, through the save context: Supabase's auth.uid() inside a
// trigger. The sync push saves with [With]; hooks read [From]. A write
// without one (superuser panel, migration, CLI) has no actor.
package actor

import "context"

type key struct{}

// With returns ctx carrying userID as the actor.
func With(ctx context.Context, userID string) context.Context {
	return context.WithValue(ctx, key{}, userID)
}

// From returns the actor in ctx, or "" when there is none.
func From(ctx context.Context) string {
	if ctx == nil {
		return ""
	}
	id, _ := ctx.Value(key{}).(string)
	return id
}
