# OnePan — Product Specification (v1.1)
_Last updated: 2025-11-03_

---

## 1. Overview
**OnePan** is a minimalist mobile app for **one-pan recipes** — quick, simple meals that require only one piece of cookware.  
It combines **visual, UI-first cooking** with an optional **AI Mode** for ingredient and recipe customization.

### MVP Goal
Deliver an Android-ready Flutter app where users can:
- Browse one-pan recipes (seeded, local JSON)
- Choose between **Simple Mode** (instant static recipe) and **AI Mode** (customized recipe)
- View ingredients, steps, and save recipes locally

---

## 2. Core User Flow
Onboarding
↓
Homepage
↓
Recipe Page ───────────────▶ Simple View (static recipe)
│
▼
AI Mode
↓
Customization
↓
Ingredient Picker → (LLM call)
↓
Customized Recipe (AI result)

---

## 3. Screen Specifications

### 1️⃣ Onboarding
**Purpose:** Collect minimal user context.  
**Inputs:**  
- Country → grid of continents → country list with flags  
- Cooking Level (Beginner / Intermediate / Confident)  
- Diet (Veg / Non-Veg)  
**Action:** “Continue” → Homepage  
**UI:** 3 steps, friendly microcopy, warm background (`#FAF6F3`).

---

### 2️⃣ Homepage
**Purpose:** Browse starter recipes.  
**UI:**  
- 2-column grid of recipe cards: image, name, ⏱ cooking time.  
- Tabs: Home | Saved | Settings.  
**Data:** Local JSON file with 5–10 one-pan recipes.  
**Action:** Tap card → Recipe Page.

---

### 3️⃣ Recipe Page (Mode Choice)
**Purpose:** Hub for viewing or personalizing a recipe.  
**UI:**  
- Hero image, title, short description.  
- Two buttons:  
  - 🟢 **Simple View** → static recipe (no LLM)  
  - 🧠 **AI Mode (beta)** → launches Customization flow  
**Note:** Simple = instant; AI = 5–10s personalization.

---

### 4️⃣ Customization
**Purpose:** Gather user preferences before LLM generation.  
**Inputs:**  
- Servings (– / +)  
- Time toggle (⚡ Fast / ⏳ Regular)  
- Spice level (🌶 slider Mild–Medium–Spicy)  
**CTA:** “Next → Ingredients”  
**Design:** 3 rounded beige cards (`#F7EDE2`), one per setting; sticky button bottom.  
**Next:** Ingredient Picker.

---

### 5️⃣ Ingredient Picker
**Purpose:** Collect what ingredients user has.  
**UI:**  
- Organized checklist with icons.  
- Groups: Core (fixed top), Protein, Vegetables, Spices, Others.  
- Search: add from pre-approved ingredient list.  
**Action:** User selects available items → presses “Personalize with AI.”  
**Triggers:** LLM call using recipe ID, params, and availability.  
**Loading:** “Simmering your OnePan recipe…” animation.  
**Next:** Customized Recipe.

---

### 6️⃣ Customized Recipe (AI Result)
**Purpose:** Display personalized recipe with substitutions.  
**Input:** LLM response (validated).  
**UI:**  
- Tabs: Ingredients | Steps.  
- Inline ⏱ time markers.  
- Tap ingredient → show quantity tooltip.  
- “Save Recipe” and “Customize Again.”  
**Fallback:** If schema invalid → show base recipe.  

---

## 4. Mode Logic

| Mode | Source | LLM Use | Flow End |
|------|---------|---------|----------|
| **Simple** | Local JSON | None | Static recipe view |
| **AI Mode** | Local JSON → LLM | 1 call after Ingredient Picker | Customized recipe |

---

## 5. LLM Integration Points
- **Call:** After Ingredient Picker.  
- **Input:** `recipe_id`, customization params, available/missing ingredients.  
- **Output:** JSON: `ingredients[]`, `steps[]`, `meta`.  
- **Validation:** Strict schema check before rendering.  
- **Timeout:** 8s; fallback to Simple mode.  
- **Caching:** `recipe_id + params + available/missing`.  

---

## 6. Data Model (MVP)
```json
{
  "id": "lemon_shrimp_pasta",
  "title": "Lemon Shrimp Pasta",
  "time_min": 22,
  "diet": "nonveg",
  "image": "assets/images/lemon_shrimp.jpg",
  "ingredients": [
    {"name": "Shrimp", "qty": 250, "unit": "g", "category": "protein"},
    {"name": "Lemon", "qty": 1, "unit": "pc", "category": "produce"}
  ],
  "steps": [
    {"num": 1, "text": "Sauté shrimp in one pan.", "time_sec": 300},
    {"num": 2, "text": "Add lemon and pasta; cook until coated.", "time_sec": 600}
  ]
}
```

## 7. Visual & UX Guidelines

Design style: Apple Health minimalism + Pinterest warmth.

Color palette:

Base #FAF6F3

Card #F7EDE2

Accent #E27D60 (terracotta)

Text #2F2F2F

Typography: Poppins / Manrope; large comfortable size.

Spacing: Generous; round corners 16dp; large tap targets.

Motion: Gentle ease-out transitions; calm loading screens.

## 8. UX Rules

One primary action per screen.

No free-text user input.

Must preserve “one-pan only” logic in all recipes.

Simple = instant; AI = optional + labeled “beta.”

Same schema drives both Simple and AI recipes.