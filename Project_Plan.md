# OnePan — Flutter Project Plan (v1.1)
_Last updated: 2025-11-03_

---

## 0) North Star & Scope

- Goal: Ship a stable Android build with a crisp, token-driven UI and an optional AI Mode that personalizes ingredients and generates final steps.
- Modes:
  - Simple Mode: Static seeded recipes (no LLM).
  - AI Mode: Two LLM calls — Call 1: Ingredient Finalizer; Call 2: Recipe Generation/Adaptation.
- Contracts-first: Freeze Schema v1; validate at runtime; both modes use the same schema.
- No free-text input; UI collects structured params only.
- One-pan constraint across all content.

---

## 1) Architecture & Folder Layout (grounded in repo)

Pattern: Presentation + Data with swappable repositories and DI via Riverpod.

```
lib/
  app/
    app.dart               // MaterialApp + theme
    providers.dart         // top-level providers
    services/
      preferences_service.dart
  core/
    seed_load_exception.dart
  data/
    models/                // v1 DTOs (Recipe, Ingredient, StepItem)
    repositories/          // RecipeRepository, SeedRecipeRepository
    sources/
      local/               // SeedLoader (assets/recipes.json)
  dev/
    components_demo_screen.dart
  features/
    customize/
    finalizer/
    home/
    ingredients/
    instructions/
    onboarding/
    saved/
    settings/
  repository/              // legacy substitution & recipe repos (to be deprecated)
  router/
    app_router.dart
  theme/
    app_theme.dart
    tokens.dart            // design tokens
```

Why this works
- Data models live in `lib/data/models/*` and are injected via repositories.
- UI depends on tokens in `lib/theme/tokens.dart`; no raw hex/magic numbers.
- Repositories make LLM/local sources swappable; caching is internal to data layer.

---

## 2) Design System (tokens-first)

- Colors/Type/Spacing from tokens in `lib/theme/tokens.dart` and `lib/theme/app_theme.dart`.
- Components: AppButton, AppCard, AppChip, ChecklistTile, SegmentedControl, Tabs, Dropdown, Skeleton (see `lib/ui/atoms/*`).
- Accessibility: min body 16sp; tap targets ≥ 48dp; calm motion (200–250ms ease-out).

Deliverables: ThemeData wired by tokens; shared atoms used across all features; no magic numbers.

---

## 3) Data Contracts (Schema v1)

Canonical Recipe (v1) — aligns with `lib/data/models/*.dart`

```
Recipe {
  schemaVersion: 1,
  id: string,
  title: string,
  timeTotalMin: int,
  diet: "veg" | "nonveg",
  imageAsset: string,
  imageUrl?: string,
  ingredients: Ingredient[],
  steps: Step[],
}

Ingredient {
  id: string,
  qty: number,
  unit: "g"|"ml"|"tbsp"|"tsp"|"cup"|"piece",
  category: "core"|"protein"|"vegetable"|"spice"|"other",
}

Step {
  num: int,
  text: string,
  timerSec?: int,
  temperatureC?: int,
}
```

Note: UI display names and thumbnails come from the Ingredient Catalog asset (`assets/ingredient_catalog.json`).
The UI resolves names via locale → `en` → `id` and uses explicit catalog images (placeholder if absent). Recipe
ingredients intentionally omit render-only fields.

Params (UI → Repository)
```
params: {
  servings: int,
  timeMode: "fast" | "regular",
  spice: "mild" | "medium" | "hot"
}
```

---

## 4) Screens & Flows

Primary screens
- Onboarding
- Homepage
- Recipe Page (Mode Choice)
- Customization
- Ingredient Picker
- Ingredient Finalizer (LLM Call 1)
- Recipe (View) — Simple shows base; AI shows generated steps/time (LLM Call 2)
- Saved
- Settings

Flow summary
- Simple: Homepage → Recipe Page → Recipe (static)
- AI: Homepage → Recipe Page → Customization → Ingredient Picker → Finalizer (Call 1) → Recipe Generation (Call 2) → Recipe (customized)

---

## 5) Milestones

| Milestone | Goal | Outcomes |
|-----------|------|----------|
| M0 — Setup & Docs | Repo hygiene + specs | Updated README/specs/plan; tokens checked in; CI basics |
| M1 — Shell & Theme | Scaffolding + tokens | App shell, routing, tabs; shared atoms; placeholder screens |
| M2 — Static Content | Seed + Simple Mode | Load from `assets/recipes.json` (schema v1); Simple flow to Recipe |
| M3 — Customization & State | Params + state | Servings/timeMode/spice wired via Riverpod; persist across nav |
| M4 — Ingredients | Picker UX | Grouped checklist (Core, Protein, Vegetable, Spice, Other); search add |
| M5 — Finalizer (LLM Call 1) | Substitutions | Implement repository call + schema validation + caching + fallback |
| M6 — Recipe Generation (Call 2) | Steps/time | Generate steps/time from finalized ingredients; validate & fallback |
| M7 — Save & Polish | Persistence + UX | Save recipe (Hive), loading/empty/error states, performance & a11y pass |
| M8 — QA & Beta | Stability | Minimal telemetry, beta build, smoke tests |

---

## 6) Repositories & Integration

- RecipeRepository: backed by SeedLoader (sorted, filter by `diet`, `timeMode` via threshold).
- Substitution/Personalization (AI Mode):
  - Call 1 (Finalizer): input (`recipeId`, `params`, `availableIds`, `missingIds`) → output (`finalIngredients`, `substitutions[]`).
  - Call 2 (Recipe Generation): input (`recipeId`, `params`, `finalIngredients[]`) → output (`steps[]`, `timeTotalMin`).
- Validation: strict schema checks before UI render; on failure → fallback to base.
- Caching: key = `recipeId + params + availableIds + missingIds` (order-independent for lists).
- Storage: Hive for saved recipes and cached AI results; SharedPreferences for lightweight prefs.

---

## 7) Release & Versioning

- App versions: semantic (`0.1.0` MVP beta).
- Schema: `schemaVersion: 1` in all recipes/responses; adapters handle migrations if bumped.
- Feature flags: `useLiveLLM`, `enableRecipeGen` (Call 2 on/off).

---

## 8) Definition of Done (v1.1)

- Users can: onboard → pick recipe → choose mode → customize → pick ingredients → finalize → generate → view → save.
- Both LLM calls validated against schema; cache keys stable and documented.
- All data/params use grounded names (`timeTotalMin`, `timeMode`, `diet`, units/categories enums).
- App stable in happy paths; errors show friendly states; no crashes.
