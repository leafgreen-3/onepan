# OnePan — Product Specification (v1.1)
_Last updated: 2025-11-03_

---

## 1. Overview
**OnePan** is a minimalist mobile app for one-pan recipes — quick, simple meals that use a single piece of cookware.
It combines a UI‑first cooking experience with an optional AI Mode. In AI Mode, the app performs two LLM calls: (1) ingredient substitutions and (2) final recipe generation/adaptation.

### MVP Goal
Deliver an Android‑ready Flutter app where users can:
- Browse one‑pan recipes (seeded, local JSON)
- Choose between Simple Mode (instant static recipe) and AI Mode (customized ingredients)
- View ingredients, steps, and save recipes locally

---

## 2. Core User Flow (with Optional AI Mode)
Onboarding
→ Homepage
→ Recipe Page (Mode Choice) → View Recipe (Simple) or Personalize (AI)

- Simple View path: Homepage → Recipe Page → Recipe (static)
- AI Mode path: Homepage → Recipe Page → Customization → Ingredient Picker → Ingredient Finalizer (LLM Call 1) → Recipe Generation (LLM Call 2) → Recipe (customized)

Notes
- AI Mode is opt‑in and clearly labeled.
- Single LLM call occurs after Ingredient Picker on the Finalizer step.
- No free‑text input anywhere; UI collects structured params only.

---

## 3. Screen Specifications

### 1) Onboarding
Purpose: Collect minimal user context.
Inputs:
- Country → grid of continents → country list with flags
- Cooking Level (Beginner / Intermediate / Confident)
- Diet (Veg / Non‑Veg)
Action: “Continue” → Homepage
UI: 3 steps, friendly microcopy, warm background (#FAF6F3)

### 2) Homepage
Purpose: Browse starter recipes.
UI:
- 2‑column grid of recipe cards: image, name, ⏱ cooking time
- Tabs: Home | Saved | Settings
Data: Local JSON file with 5–10 one‑pan recipes
Action: Tap card → Recipe (Simple) or Personalize (AI)

### 3) Recipe Page (Mode Choice)
Purpose: Let users view the base recipe or opt into AI personalization.
UI:
- Hero image, title, short description
- Primary CTA: “View Recipe” (Simple)
- Secondary CTA: “Personalize with AI” (beta) → Customization
Note: Simple = instant; AI runs background calls (see Integration).

### 4) Customization
Purpose: Gather user preferences before LLM generation.
Inputs:
- Servings (− / +)
- Time mode (Fast / Regular)
- Spice level (Mild / Medium / Spicy)
CTA: “Next → Ingredients”
Design: 3 rounded beige cards (#F7EDE2), one per setting; sticky button bottom
Next: Ingredient Picker

### 5) Ingredient Picker
Purpose: Collect what ingredients user has.
UI:
- Organized checklist with icons
- Groups: Core (fixed top), Protein, Vegetable, Spice, Other
- Search: add from pre‑approved ingredient list
Action: User selects available items → presses “Personalize with AI”
Next: Ingredient Finalizer (LLM Call 1 happens here)

### 6) Ingredient Finalizer (AI Result)
Purpose: Present suggested swaps/omissions for missing items based on user availability.
Input: LLM Call 1 using recipe ID, params, and availability.
UI:
- Revised ingredient list with substitutions clearly marked (from → to, with note)
- User confirms final list
Fallback: On timeout/invalid schema, revert to base ingredients
Next: Recipe Generation (LLM Call 2) → Recipe (customized view)

### 7) Recipe (View)
Purpose: Display the final recipe to cook (static in Simple mode, customized in AI mode).
UI:
- Tabs: Ingredients | Steps
- Inline ⏱ time badges
- Tap ingredient → quantity tooltip
- “Save Recipe” and “Customize Again”
Note: In AI Mode, steps/time reflect results from LLM Call 2.

---

## 4. Mode Logic

| Mode      | Source       | LLM Use                | Flow End             |
|-----------|--------------|------------------------|----------------------|
| Simple    | Local JSON   | None                   | Static recipe view   |
| AI Mode   | Local JSON + LLM | 2 calls (Finalizer + Recipe Gen) | Customized recipe    |

---

## 5. LLM Integration Points

Call 1 — Ingredient Substitution (Finalizer)
- When: After Ingredient Picker, on Finalizer
- Input: `recipeId`, `params`, `availableIds[]`, `missingIds[]`
- Output: `finalIngredients: Ingredient[]`, `substitutions: { from, to, note }[]`
- Validation: Strict schema check before rendering; invalid → fallback to base
- Timeout: 8s with one retry; on failure → fallback to base
- Caching: Keyed by `recipeId + params + availableIds + missingIds` (order‑independent)

Call 2 — Recipe Generation/Adaptation
- When: After Finalizer confirmation, before showing Recipe (customized)
- Input: `recipeId`, `params`, `finalIngredients: Ingredient[]`
- Output: `steps: Step[]`, `timeTotalMin: number`
- Validation: Must conform to Schema v1 field rules
- Timeout: 8s with one retry; on failure → show base steps/time with finalized ingredients

Param Structure (UI → repository)
```jsonc
{
  "recipeId": "lemon-garlic-shrimp-orzo",
  "params": {
    "servings": 2,
    "timeMode": "fast",
    "spice": "medium"
  },
  "availableIds": ["shrimp", "garlic", "orzo"],
  "missingIds": ["broth"]
}
```

Response (Finalizer)
```jsonc
{
  "finalIngredients": [ { "id": "shrimp", "qty": 250, "unit": "g", "category": "protein" } ],
  "substitutions": [
    { "from": "butter", "to": "olive oil", "note": "availability-based" }
  ]
}
```

Response (Recipe Generation)
```jsonc
{
  "steps": [ { "num": 1, "text": "Heat oil.", "timerSec": 30 }, { "num": 2, "text": "Simmer orzo in broth." } ],
  "timeTotalMin": 22
}
```

---

## 6. Data Model (MVP, Schema v1)
The app uses a versioned schema for seed data and AI output. Both Simple and AI modes MUST conform to the same shape.

Recipe (v1)
```jsonc
{
  "schemaVersion": 1,
  "id": "lemon-garlic-shrimp-orzo",
  "title": "Lemon Garlic Shrimp Orzo",
  "timeTotalMin": 24,
  "diet": "nonveg",            // one of: "veg", "nonveg"
  "imageAsset": "assets/images/recipes/lemon-garlic-shrimp-orzo.png",
  "imageUrl": "",               // optional; may be empty string
  "ingredients": [
    {
      "id": "shrimp",
      "qty": 250,
      "unit": "g",             // one of: g, ml, tbsp, tsp, cup, piece
      "category": "protein"     // one of: core, protein, vegetable, spice, other
    }
  ],
  "steps": [
    { "num": 1, "text": "Saute garlic for 30 seconds.", "timerSec": 30 },
    { "num": 2, "text": "Simmer orzo in broth until tender." }
  ]
}
```

Validation Rules (enforced in code)
- `schemaVersion` must be 1
- `diet` in {`veg`, `nonveg`}
- `timeTotalMin` > 0
- Ingredient `unit` in {`g`, `ml`, `tbsp`, `tsp`, `cup`, `piece`}
- Ingredient `category` in {`core`, `protein`, `vegetable`, `spice`, `other`}
- Step fields: `num` > 0, `text` non‑empty, optional `timerSec` and `temperatureC` ≥ 0 when present

---

### Ingredient Catalog (v1)
Display names and thumbnails are provided by a separate catalog asset and not stored on each ingredient item.

- Source file: `assets/ingredient_catalog.json`
- Schema:
  ```jsonc
  {
    "version": 1,
    "items": [
      {
        "id": "spinach",
        "names": { "en": "Spinach" },
        "image": "assets/ingredients/spinach.png", // optional
        "aliases": ["baby spinach"]                 // optional
      }
    ]
  }
  ```
- UI resolution rules:
  - Name: locale.languageCode → `en` → fallback to `id`.
  - Image: explicit `image` from catalog; if absent, UI shows placeholder.
  - Unknown IDs: UI falls back to `id` for name and placeholder for image.
  - Adapters may return names, but UI ignores them in favor of the catalog.

---

## 7. Visual & UX Guidelines

Design style: Apple Health minimalism + Pinterest warmth.

Color palette:
- Base #FAF6F3
- Card #F7EDE2
- Accent #E27D60 (terracotta)
- Text #2F2F2F

Typography: Poppins / Manrope; large, comfortable sizes.
Spacing: Generous; round corners 16dp; large tap targets.
Motion: Gentle ease‑out transitions; calm loading screens.

---

## 8. UX Rules

- One primary action per screen.
- No free‑text user input.
- Must preserve “one‑pan only” logic in all recipes.
- Simple = instant; AI = optional + labeled “beta”.
- Same schema drives both Simple and AI recipes.
- Accessibility: generous tap targets, readable type, calm motion.
- Caching & Fallbacks: cache successful AI results by key; on LLM failure, revert to base recipe.
