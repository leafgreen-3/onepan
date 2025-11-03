# OnePan — UI Principles (v1.1)
_Last updated: 2025-11-03_

---

## Purpose
Define the visual, interaction, and motion principles for OnePan so every screen feels calm, warm, and easy to use.

---

## Design Identity
Warm Minimalism = Apple Health clarity + Pinterest food warmth.

Traits
- Simple: one clear action per screen
- Warm: soft neutrals, rounded corners, natural imagery
- Readable: large type, generous spacing, clean hierarchy
- Tactile: subtle feedback on taps and transitions
- Consistent: same rhythm and spacing across features

---

## Color System
Palette
- Background: #FAF6F3
- Surface/Card: #F7EDE2
- Primary (CTA Terracotta): #E27D60
- Secondary (Forest Green): #3E7C59
- Text Primary: #2F2F2F
- Text Secondary: #5A5A5A
- Divider/Border: #E8DCC9
- Success: #B5C99A
- Alert: #D97C6A

Usage Rules
- Prefer color hierarchy over heavy lines or borders
- One accent focus per screen (primary or secondary)
- Keep contrast sufficient for readability on light surfaces

---

## Typography
- Fonts: system sans for MVP (Poppins/Manrope optional later)
- Sizes
  - Headlines: 24–28sp, semi‑bold
  - Title: 20sp, semi‑bold
  - Body: 16sp minimum, regular
  - Label/Caption: 14sp
- Guidelines
  - Use weight for emphasis, not color
  - Sentence case for friendliness
  - Line height ≥ 1.3 for all styles

---

## Layout & Spacing
- Grid: 4‑based scale (4, 8, 12, 16, 24)
- Section padding: 24dp top/bottom
- Corners: 16dp on cards, fields, and buttons
- Elevation: 1–2dp soft shadows; avoid harsh depth
- Touch targets: 48dp minimum for all interactive elements

---

## Components
Buttons
- Primary (CTA): terracotta fill (#E27D60), white text, 16dp radius
- Secondary: forest green fill (#3E7C59) or outline; white or green text
- Disabled: reduce opacity and remove elevation; preserve text contrast

Checklist / Ingredient Row
- Left: circular ring checkbox; unchecked ring in neutral, checked fill + tick in green
- Middle: ingredient thumbnail (circular dish or flat icon) + name; quantity as secondary text
- Right: check icon or toggle state
- Groups: CORE pinned first, then Protein, Vegetable, Spice, Other; group headers in small caps with extra top spacing

Cards & Sections
- Rounded containers on surface beige
- Light elevation; internal dividers use #E8DCC9

Segmented Control (Spice)
- 3 options (Mild/Medium/Hot) with pepper icons
- Selected state uses terracotta background or indicator

Search Field
- Filled beige background, subtle outline, 16dp radius, left search icon

Tabs
- Primary tabs with clear indicator; use minimal elevation and strong text contrast

Tooltips/Badges
- Small rounded chips for time badges and substitution notes; keep colors subdued

---

## Iconography & Imagery
- Icons: rounded line icons with consistent stroke; prefer literal ingredient visuals
- Imagery: real, top‑down food photos with natural light; avoid heavy filters; consistent aspect ratio (4:3 or square)

---

## Motion & Interaction
- Durations: 200–250ms ease‑out for taps and transitions
- Page transitions: forward slide‑in from right; back slide‑in from left
- Micro‑interactions: slight scale on press (~1.02x), subtle shadow deepen; checkbox fill animates smoothly

---

## Accessibility
- Minimum touch target: 48dp
- Body size: 16sp minimum; maintain color contrast for text and icons
- One primary CTA per screen; secondary actions visually de‑emphasized

---

## Screen Guidance (MVP)
Onboarding
- Three steps (Country → Level → Diet); one primary CTA per step

Homepage
- Warm card list; recipe card shows image, title, and time badge

Recipe Page (Mode Choice)
- Primary: “Simple View” (green); Secondary: “Personalize with AI” (terracotta)
- Large rounded buttons; calm spacing around hero image

Customization
- Three cards: Servings, Time Mode (Fast/Regular), Spice (Mild/Medium/Hot)
- Sticky primary CTA at bottom

Ingredient Picker
- Search at top; grouped checklist with thumbnails
- Checked state is clearly visible and consistent

Ingredient Finalizer
- Revised list with substitutions marked (from → to) and concise notes
- Primary CTA: confirm ingredients to continue

Recipe (View)
- Tabs: Ingredients | Steps
- Inline time badges; tap ingredient reveals quantity tooltip
- Save button as primary when not in flow; “Customize Again” as secondary

---

## Do / Don’t
Do
- Use tokens for all spacing, colors, radii, durations
- Keep screens calm with a single focal action
- Use real imagery and clear ingredient visuals

Don’t
- Add heavy borders, harsh shadows, or saturated backgrounds
- Present more than one primary CTA per screen
- Shrink tap targets or body text below accessibility minimums

