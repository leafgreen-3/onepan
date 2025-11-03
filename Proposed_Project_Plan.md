
---

## 🧩 `/docs/project/plan_v1.1.md`

```markdown
# OnePan — Project Plan (v1.1)
_Last updated: 2025-11-03_

---

## 1. Objective
Build the **OnePan MVP** — a Flutter app for one-pan recipes with dual flow:
- **Simple Mode:** Static seeded recipes.
- **AI Mode:** Customizable path using LLM.

Deliverable: stable Android build, validated schema, documented code.

---

## 2. Milestones

| Milestone | Goal | Outcome |
|------------|------|----------|
| M0 | Setup & Docs | Repo + specs ready |
| M1 | Static UI | All screens scaffolded |
| M2 | Simple Mode | Fully working local recipes |
| M3 | AI Mode | LLM integration live |
| M4 | QA & Polish | Stable release |

---

## 3. Task Breakdown

### 🧱 Core Tasks
1. **Docs v1.1 (this step)**  
   - Update spec, plan, README.  
2. **UI Scaffolding**  
   - All six screens static; navigation functional.  
3. **Data Model**  
   - Local JSON recipes; structure validated.  
4. **Simple Mode Functionality**  
   - Render static recipe flow.  
5. **AI Mode Flow**  
   - Customization → Ingredient Picker → LLM → Customized Recipe.  
6. **LLM Contract & Caching**  
   - Implement schema, fallback, caching key.  
7. **Final Polish & QA**  
   - UI consistency, load states, testing.

---

## 4. Branch Strategy
- `main` → stable
- `feature/ui-recipe-hub`
- `feature/ai-customization`
- `feature/llm-integration`
- `feature/qa-polish`

Each branch merges via PR referencing this plan and product spec sections.

---

## 5. Codex Workflow Rules
- Codex must reference `/docs/specs/product_spec_v1.1.md` before coding.  
- Use data contracts from `/docs/api/llm_contracts_v1.1.md`.  
- UI changes require screenshot + acceptance criteria in PR.  
- No prompt-engine changes without spec update.

---

## 6. Timeline (Approx.)
| Week | Focus |
|------|-------|
| 1 | Docs & Setup |
| 2 | Static UI (all screens) |
| 3 | Simple Mode flow |
| 4 | AI Mode integration |
| 5 | QA, caching, polish |

---

## 7. Deliverables
- APK build (debug).  
- Screenshots of all screens.  
- LLM schema validation tests.  
- Updated `/docs/qa/test_plan_v1.1.md`.

---

## 8. Acceptance Criteria Summary
- ✅ 6 screens navigable and visually consistent.  
- ✅ Simple recipes display instantly.  
- ✅ AI flow functional with loading + fallback.  
- ✅ JSON schema validated.  
- ✅ All UI strings match `/docs/specs/ui_copy.md`.  
- ✅ App stable on emulator.

---
