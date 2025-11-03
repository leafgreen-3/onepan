# OnePan — README (v1.1)
_A minimalist one‑pan recipe app with optional AI personalization._

---

## Overview
- OnePan focuses on quick, one‑pan meals with a calm, token‑driven UI.
- Two modes:
  - Simple Mode: static seed recipes (no LLM)
  - AI Mode: two LLM calls — ingredient Finalizer, then Recipe Generation
- No free‑text inputs; UI collects structured params only.
- Both modes use the same Schema v1 data model.

---

## Screens & Flow
- Onboarding → Homepage → Recipe Page (Mode Choice)
- Simple path: Homepage → Recipe Page → Recipe (static)
- AI path: Homepage → Recipe Page → Customization → Ingredient Picker → Ingredient Finalizer (Call 1) → Recipe Generation (Call 2) → Recipe (customized)

---

## Data Contracts (Schema v1)
- Recipe
  - keys: `schemaVersion`, `id`, `title`, `timeTotalMin`, `diet`, `imageAsset`, `imageUrl?`, `ingredients[]`, `steps[]`
- Ingredient
  - keys: `id`, `name`, `qty` (number), `unit` in {`g`,`ml`,`tbsp`,`tsp`,`cup`,`piece`}, `category` in {`core`,`protein`,`vegetable`,`spice`,`other`}, `thumbAsset?`, `thumbUrl?`
- Step
  - keys: `num` (>0), `text` (non‑empty), optional `timerSec`, `temperatureC`

Grounded in code
- Models: `lib/data/models/{recipe.dart, ingredient.dart, step.dart}`
- Seeds: `assets/recipes.json`
- Seed loader: `lib/data/sources/local/seed_loader.dart`

---

## Params (UI → Repository)
- `params.servings: int`
- `params.timeMode: "fast" | "regular"`
- `params.spice: "mild" | "medium" | "hot"`

---

## LLM Integration (AI Mode)
- Call 1 — Ingredient Finalizer
  - Input: `recipeId`, `params`, `availableIds[]`, `missingIds[]`
  - Output: `finalIngredients: Ingredient[]`, `substitutions: { from, to, note }[]`
  - Behavior: validate schema; timeout with one retry; fallback to base on failure
  - Cache key: `recipeId + params + availableIds + missingIds` (order‑independent lists)
- Call 2 — Recipe Generation/Adaptation
  - Input: `recipeId`, `params`, `finalIngredients[]`
  - Output: `steps[]`, `timeTotalMin`
  - Behavior: validate schema; timeout with one retry; fallback to base steps/time on failure

---

## Repo Layout (grounded)
- App: `lib/main.dart`, `lib/app/app.dart`, `lib/app/providers.dart`
- Routing: `lib/router/app_router.dart`
- Theme/tokens: `lib/theme/{app_theme.dart, tokens.dart}`
- Data models: `lib/data/models/*`
- Seed loader: `lib/data/sources/local/seed_loader.dart`
- Repos: `lib/data/repositories/{recipe_repository.dart, seed_recipe_repository.dart}`
- Features: `lib/features/{onboarding,home,customize,ingredients,finalizer,instructions,saved,settings}`
- Legacy (to be deprecated): `lib/repository/*`, `lib/models/*`

---

## Setup
- Prereqs: Flutter SDK installed
- Install: `flutter pub get`
- Analyze: `flutter analyze`
- Run: `flutter run`

---

## Quick Pointers
- Schema v1 enforcement happens in `lib/data/models/*` and is applied by `SeedLoader`.
- Fast/regular filtering is handled by repository time thresholds (see `seed_recipe_repository.dart`).
- Use tokens from `lib/theme/tokens.dart` for all spacing, color, and type — no magic numbers.
