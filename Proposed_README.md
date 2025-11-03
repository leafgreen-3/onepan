# OnePan
_A minimalist one-pan recipe app with optional AI personalization._

---

## 🔥 Overview
**OnePan** helps you cook easy, one-pan meals without the clutter.  
Browse beautiful recipes instantly in **Simple Mode**, or switch to **AI Mode** to personalize ingredients, spice, and cooking time — powered by LLMs.

---

## ✨ Features
- Curated one-pan recipes (local JSON)
- **Simple Mode**: instant recipe display
- **AI Mode (beta)**: custom ingredient swaps + step adaptation
- Ingredient checklist with icons
- Local save of favorite recipes

---

## 🧭 User Flow
Onboarding → Homepage → Recipe Page
├─ Simple View → Static Recipe
└─ AI Mode → Customization → Ingredient Picker → AI → Customized Recipe

---

## 🧰 Tech Stack
- Flutter / Dart  
- Local JSON data  
- Optional LLM API (OpenAI-compatible)  
- Material 3 design principles  

---

## 📂 Folder Structure
/lib
/features
onboarding/
home/
recipe/
customization/
ingredients/
final_recipe/
/assets
/images
/recipes
/docs
/specs
/project
/api

---

## 🚀 Setup
1. Clone the repo  
   ```bash
   git clone https://github.com/leafgreen-3/onepan.git
   cd onepan
2. Install dependencies
    flutter pub get
3. Run the app
    flutter run