OnePan — Product Specification (MVP)
1. Vision & Value Proposition

Goal: Build a mobile app that acts as a UI layer between humans and LLMs for cooking, focused entirely on OnePan recipes — simple, fast dishes that use only one pan or pot.

Why OnePan:

Narrow scope ensures consistency, speed, and low cognitive load.

Perfect entry point for testing structured recipe generation and customization.

Simplifies LLM prompt logic and reduces risk of inconsistent steps or equipment.

MVP Focus:

Crisp UI for selecting, customizing, and finalizing OnePan recipes.

Ingredient-based personalization without free-text input.

Clear, minimal LLM interaction — one-cycle substitutions and optional step adaptation.

2. Core Pages (MVP Flow)
Page 1: Onboarding

Purpose: Collect minimal context for tailoring recipes.

Inputs:

Country → searchable dropdown with flags OR grid of continents → then country list with flags.

Cooking Level (Beginner / Intermediate / Confident; icons).

Diet (Veg / Non-Veg).

Notes:

Only three required fields to minimize friction.

No equipment questions needed (all recipes are OnePan by default).

Page 2: Homepage

Purpose: Display starting set of OnePan recipes.

UI Elements:

Recipe Cards: image + recipe name + cooking time.

Tabs: Home | Saved Recipes | Settings.

Data Source:

3–10 pre-curated OnePan recipes (static JSON or local data).

Each card leads to the customization step.

Page 3: Customization

Purpose: Collect user constraints before generating or adapting the recipe.

Inputs:

Servings (– / +).

Time toggle (⚡ Fast / ⏳ Regular).

Spice level slider (🌶 Mild, Medium, Spicy).

Notes:

Only these three parameters are supported in MVP.

These are passed as structured parameters to the LLM.

Page 4: Ingredient Picker

Purpose: Let users confirm which ingredients they have.

UI Elements:

Organized checklist with icons (fallback icon for generic items like spices).

Core ingredients fixed at the start, followed by grouped categories:

Protein / Vegetables / Spices / Others.

User checks/unchecks items to mark what’s available.

Optional search bar for adding from a pre-approved ingredient list.

Notes:

No substitutions displayed here.

This screen collects availability data for the next step.

Page 5: Ingredient Finalizer

Purpose: Generate and present substitution options for missing items.

LLM Touchpoint #1:

Input: Base recipe + customization parameters + user’s available/unavailable ingredients.

Output: Updated list with suggested swaps or omissions.

UI Elements:

Display revised ingredient list with substitutions clearly marked.

User can review and confirm before moving to the recipe.

Notes:

One-cycle processing — no real-time substitution.

All substitutions must maintain OnePan compatibility.

Page 6: Recipe

Purpose: Present the customized OnePan recipe for cooking.

LLM Touchpoint #2 (Optional for MVP):

Input: Final ingredient list + customization parameters.

Output: Adapted cooking steps (scaled servings, adjusted times, spice levels).

UI Elements:

Tabs: Ingredients | Steps.

Continuous scroll view (no step-by-step cook mode yet).

Inline time indicators (⏱).

Tapping or holding an ingredient reveals its quantity instantly, avoiding tab switching.

Buttons: “Save Recipe” and “Customize.”

Notes:

Recipe steps should assume a single pan or pot for all actions.

No timers, notifications, or multimedia at this stage.

3. LLM Integration (MVP Contracts)

When Used:

Ingredient Finalizer (substitution suggestions).

(Optional) Recipe adaptation (step adjustment).

Format:

Strict structured schema (RecipeMeta, Ingredients[], Steps[]).

Schema validation required before rendering UI.

Constraints:

No user free-text input.

All parameters are generated from UI elements (toggles, sliders, checkboxes).

Model must adhere to OnePan constraint — no multiple equipment references.

4. Key UX Decisions

Scope Limitation: All recipes are OnePan by default; no equipment filtering or variation needed.

Ingredient Picker: Organized by category; core items fixed at top.

Substitution Flow: One-cycle (Page 4 → Page 5).

Recipe View: Continuous scroll layout.

Ingredient Quantities: Tapping an ingredient shows its quantity inline.

Customization Options: Servings, time, and spice only.

LLM Usage: Minimal and controlled; structured prompts only.