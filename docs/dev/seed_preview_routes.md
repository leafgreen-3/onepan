### Purpose
- Temporary, dev-only routes to verify seeds end-to-end without full UI.

### Routes
- `/dev/recipes` — lists seed titles; tap → detail
- `/dev/recipe/:id` — shows a single recipe’s key fields

### How to Use
- From Home, tap “Dev: View Recipes” (button) to navigate to `/dev/recipes`.
- Alternatively, set the router’s `initialLocation` to `/dev/recipes` during local debugging.
- Verify: list loads; tapping navigates; detail renders typed fields.

### Removal Plan
- Remove or guard behind a debug flag once the main Home Grid and Recipe Detail screens are implemented.

