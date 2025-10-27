# OnePan — Flutter MVP Project Plan (LLM-Assisted)

## 0) North Star & Constraints

* **Goal:** Ship a stable Android MVP of OnePan with a crisp UI, OnePan-only recipe flow, and minimal, structured LLM integration.
* **Time/Scope:** UI-first, 6 screens, static curated recipes + one-cycle substitution; optional step adaptation.
* **LLM Collaboration:** Code is largely LLM-generated; humans provide specs, reviews, and acceptance criteria.
* **Compatibility Principle:** Design contracts (data + UI) first; code against contracts; keep adapters replaceable.

---

## 1) Architecture & Folder Layout (future-friendly)

**Pattern:** Presentation–Domain–Data with clear boundaries, minimal ceremony.

```
lib/
  app/
    app.dart             // MaterialApp + GoRouter + theme
    di.dart              // Providers for dependencies (Riverpod)
    theme/
      colors.dart        // design tokens (hex palette)
      typography.dart    // text styles
      spacing.dart       // paddings, radii, elevations
      theme.dart         // ThemeData factory
  core/
    error.dart           // failure types
    result.dart          // Result<T>
    utils.dart           // formatters, extensions
    constants.dart
  features/
    onboarding/
      ui/                // screens, widgets
      state/
      domain/
    home/
    customize/
    ingredients/
    finalizer/
    recipe/
  data/
    models/              // DTOs (RecipeDto, IngredientDto, StepDto)
    repositories/        // RecipeRepository, SubstitutionRepository
    sources/
      local/             // Hive/SharedPrefs
      remote/            // LLM API client, mock client
  router/
    routes.dart          // typed routes, names, deep links (optional)
```

**Why this works:**

* Contracts (models, repos) sit in `/data` and are injected into features.
* Feature isolation prevents cross-coupling; screens can evolve independently.
* Repositories abstract local vs remote; swapping LLM or storage doesn’t touch UI.

**Tech choices (pragmatic):**

* **State:** Riverpod (simple, testable, well-documented).
* **Navigation:** go_router (declarative, URL-friendly).
* **Local storage:** SharedPreferences (settings) + Hive (saved recipes, cached adaptations).
* **HTTP:** `dio` with interceptors for logging + timeouts.
* **Linting:** `flutter_lints` + `very_good_analysis` (optional).

---

## 2) Design System (tokens-first)

Define tokens once; never hardcode magic numbers/colors in widgets. LLMs will reference tokens.

* **Colors:** map the agreed palette to semantic roles.

  * background = #FAF6F3
  * surface = #F7EDE2
  * primary = #E27D60
  * secondary = #8D8741
  * textPrimary = #2F2F2F
  * textSecondary = #5A5A5A
  * divider = #E8DCC9
  * success = #B5C99A
  * alert = #D97C6A
* **Typography:** heading, title, body, label; min body 16sp; tap targets ≥48dp.
* **Spacing:** 4-based scale (4, 8, 12, 16, 20, 24, 32).
* **Components:** primary/secondary buttons, chips, cards, checklist tile, segmented control, slider, tabs.
* **Motion:** 200–250ms ease-out for taps; subtle page transitions.

Deliverables:

1. `theme/theme.dart` exposes `ThemeData` using tokens.
2. Reusable widgets in each feature rely only on tokens.

---

## 3) Data Contracts (versioned)

Design first; freeze v1; validate at runtime. All LLM outputs must conform.

### 3.1 Recipe Schema (v1)

```
Recipe {
  id: string,
  title: string,
  time_total_min: int,
  diet: "veg" | "nonveg",
  image_url: string,
  ingredients: Ingredient[],
  steps: Step[],
}

Ingredient {
  id: string,
  name: string,
  qty: number,
  unit: string,          // "g", "ml", "tbsp", "tsp", "cup", "piece"
  category: "core" | "protein" | "vegetable" | "spice" | "other",
}

Step {
  num: int,
  text: string,
  timer_sec?: int,
  temperature_c?: int,
}
```

### 3.2 Substitution API Contract (v1)

**Request**

```
{
  recipe_id: string,
  params: { servings: int, time: "fast"|"regular", spice: "mild"|"medium"|"spicy" },
  available_ids: string[],
  missing_ids: string[]
}
```

**Response**

```
{
  substitutions: [
    { substitute_id: string, substitute_name: string, for_id: string }
  ],
  final_ingredients: Ingredient[]  // same schema; merged and scaled
}
```

### 3.3 Optional Step Adaptation Contract (v1)

**Request**: `{ recipe_id, final_ingredients, params }`
**Response**: `{ steps: Step[], time_total_min: int }`

**Rules:**

* Must remain OnePan-compatible (no extra equipment).
* Units normalized; ids stable; categories preserved.
* Include `schema_version: 1` in every payload for migration safety.

---

## 4) Feature Milestones (compatible sequencing)

### M1 — Shell & Theme (compat baseline)

* Create app shell, routing, and theme tokens.
* Build primitive components: Button, Card, Chip, ChecklistTile, SegmentedControl, Tabs.
* Acceptance: All 6 placeholder screens render with design system; no business logic.

### M2 — Static Content & Navigation

* Load 3–10 recipes from `/assets/recipes.json` (schema v1).
* Homepage grid → details flow to Customization.
* Acceptance: Card tap navigates through entire flow using static data.

### M3 — Customization & State

* Hook servings/time/spice controls; keep state via Riverpod providers.
* Acceptance: Values persist across navigation; deep link back preserves state.

### M4 — Ingredient Picker (groups + search)

* Render grouped ingredients; core pinned on top.
* Search add from pre-approved list; prevent duplicates.
* Acceptance: Check/uncheck updates a canonical list in state; unit tests for grouping/sorting.

### M5 — Finalizer (Mock Adapter)

* Implement `SubstitutionRepository` with a **mock** source (local rules file) that returns deterministic substitutions matching contract v1.
* Acceptance: User sees revised list; confirm proceeds to Recipe.

### M6 — Recipe Screen Polishing

* Tabs (Ingredients | Steps), inline ⏱ badges, **tap-to-reveal quantity** tooltip.
* Save Recipe locally (Hive). Saved tab lists items.
* Acceptance: Saved recipe reloads exactly with substitutions and params.

### M7 — Real LLM Adapter (behind the repository)

* Add RemoteSubstitutionSource → validates JSON (schema v1), times out, retries once, falls back to mock.
* Cache responses by hash(recipe_id+params+availability).
* Acceptance: Toggle between mock and live via env flag; bad responses don’t crash UI.

### M8 — Hardening & Beta

* Accessibility pass (contrast, sizes, talkback labels).
* Performance: list virtualization, image caching.
* Error states: offline, timeout, parse failure banners.
* Beta build signed; distribute to pilot users.

---

## 5) LLM Collaboration Protocol (for coding tasks)

**Why:** Ensure consistent, high-quality code from LLMs by giving precise prompts and acceptance criteria.

### 5.1 Task Template (prompt to LLM)

* **Context:** Summarize feature + file paths to touch.
* **Contracts:** Paste relevant schema/types and design tokens.
* **Acceptance Criteria:** Bullet list (UI behavior, state persistence, error handling, tests).
* **Non-Goals:** Explicitly list what NOT to change.
* **Output Style:** Ask for minimal diff or specific files; include docstrings.

### 5.2 Guardrails

* Never hardcode colors/spacing — use tokens.
* Keep widget build methods small; extract stateless components.
* All state via Riverpod; no global singletons.
* Repository interfaces must not import UI packages.
* Add unit tests for pure functions (grouping, scaling, substitution merge).

---

## 6) Testing Strategy

* **Unit:** ingredient grouping/sorting; quantity scaling; repository merge logic.
* **Widget:** Ingredient checklist interactions; tap-to-quantity; navigation.
* **Golden tests:** Core screens at common breakpoints (small/medium devices).
* **Manual scenarios:**

  1. Beginner Veg user completes a recipe with two substitutions.
  2. Confident Non-Veg user scales to 5 servings, Fast mode.
  3. Offline mode during Finalizer → fallback to mock.

---

## 7) Telemetry (minimal)

* Anonymous events: screen views, completion of Finalizer, Save Recipe.
* Latency: substitution round-trip time, parse failures count.
* Store locally during MVP if network is out-of-scope.

---

## 8) Release & Versioning

* **App versions:** semantic (`0.1.0` MVP beta).
* **Schema versions:** `schema_version` in every recipe/response; migration function if incremented.
* **Feature flags:** `useLiveLLM` on/off; `enableStepAdaptation` on/off.

---

## 9) Risks & Mitigations

* **Schema drift:** Lock v1; validate + log; strict fallbacks.
* **UI inconsistency (LLM code):** Tokens + component library; PR checklist.
* **Latency:** Cache + graceful loading on Finalizer; optimistic UI.
* **Scope creep:** Six screens only; no cook mode/voice.

---

## 10) Definition of Done (MVP)

* Users can: onboard → pick recipe → customize → check ingredients → finalize → view recipe → save.
* All data flows adhere to schema v1; LLM adapter is optional and swappable.
* App stable on 2–3 Android devices; no crashes in happy path.
* Known issues documented; next iteration scoped.
