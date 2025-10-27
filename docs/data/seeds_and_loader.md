### Overview
- Purpose: provide 3–10 curated seeds (veg & non-veg, varied time) for early UI.
- Acceptance criteria recap: can list and open a recipe from the seeds; all items validate against Schema v1.

### File Locations
- `assets/recipes.json`
- `lib/models/recipe.dart` (Schema v1)
- `lib/models/errors.dart` (`RecipeValidationError`, `AggregateValidationError`)
- `lib/data/recipe_loader.dart` (`loadRecipesFromAsset`)
- `test/data/recipe_loader_test.dart` (if present)

### Seed Format (Schema v1)
- Serialization uses `json_serializable` and parsing goes through `Recipe.fromJson`, which normalizes tags and enforces invariants.

| field       | type          | required | constraints (summary)                     |
|-------------|---------------|----------|-------------------------------------------|
| id          | string        | yes      | `[a-z0-9-_.]`, 1–60                       |
| title       | string        | yes      | 1–120                                     |
| subtitle    | string?       | no       | ≤140                                      |
| tags        | string[]      | no       | deduped, lowercased, each 1–20, ≤12 total |
| minutes     | int           | yes      | 1–240                                     |
| servings    | int           | yes      | 1–12                                      |
| spice       | enum          | yes      | `mild|medium|hot|inferno`                 |
| image       | string?       | no       | http URL or asset path                    |
| ingredients | string[]      | yes      | non-empty; trimmed                        |
| steps       | string[]      | yes      | non-empty; trimmed                        |
| version     | string        | yes      | "1.0"                                     |
| updatedAt   | ISO datetime? | no       | optional                                  |

### Loader Usage
```dart
final recipes = await loadRecipesFromAsset('assets/recipes.json');
// returns List<Recipe>; throws AggregateValidationError on any invalid item
```
- On error, the thrown `AggregateValidationError` includes item index and field names for fast fixes.

### Current Seed Set (curated)

| id                   | title                | veg | minutes | spice  |
|----------------------|----------------------|-----|---------|--------|
| spicy-tomato-pasta   | Spicy Tomato Pasta   | yes | 20      | medium |
| lemon-herb-chicken   | Lemon Herb Chicken   | no  | 28      | mild   |
| veggie-stir-fry      | Veggie Stir-Fry      | yes | 15      | mild   |
| butter-garlic-shrimp | Butter Garlic Shrimp | no  | 12      | medium |
| slow-beef-ragu       | Slow Beef Ragu       | no  | 180     | mild   |
| chana-masala         | Chana Masala         | yes | 35      | hot    |

### Extending Seeds
- Add entries to `assets/recipes.json` following Schema v1.
- Run validation (see Dev Routes / Tests) to ensure all pass.
- Keep the set ≤ 20 during early UI for performance and clarity.

### FAQ
- Why assets not API? Faster iteration, deterministic demos.
- Images required? Optional; use asset placeholders until final art.

