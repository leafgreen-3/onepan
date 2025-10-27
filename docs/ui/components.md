# OnePan Component Library (Atoms)

Purpose
- Provide small, composable building blocks that enforce the tokens-only rule and UI principles across the MVP screens.
- All atoms read spacing, radii, elevation, colors, and type from tokens and the current Theme.

Tokens-only rule
- Widgets must use the following tokens and never hardcode values:
  - Spacing: `AppSpacing.*`
  - Radii: `AppRadii.*`
  - Colors: `Theme.of(context).colorScheme` and `AppColors.*`
  - Typography: `Theme.of(context).textTheme` mapped from `AppTextStyles.*`
  - Elevation: `AppElevation.*`
  - Durations/Opacity/Sizes/Thickness: `AppDurations.*`, `AppOpacity.*`, `AppSizes.*`, `AppThickness.*`

Where to import
- Barrel file: `lib/ui/atoms/atoms.dart`

Light/Dark
- All components derive colors from `ThemeData.colorScheme` and container roles (e.g., `surface`, `surfaceContainer*`, `primaryContainer`).
- No explicit brightness checks should be needed; tokens and Theme handle it.

Demo Screen
- Run the app and open `/dev/components` to preview all atoms and their states.

Extending components
- Add new variants/sizes only by introducing new tokens if needed; never hardcode.
- Prefer `Theme.colorScheme` roles to raw `AppColors` for surfaces/containers.
- Ensure: a11y semantics, min touch target `AppSizes.minTouchTarget`, and focus/hover visuals via `AppOpacity`.

---

## AppButton

API
- `label: String` — required
- `onPressed: VoidCallback?`
- `variant: AppButtonVariant` — `filled | tonal | text`
- `size: AppButtonSize` — `md | lg`
- `icon: Widget?`
- `loading: bool` — shows spinner, disables tap
- `expand: bool` — expands to full width

States
- Enabled, disabled, loading. Loading replaces label content with a circular progress indicator using token stroke width and duration.

Usage
```dart
AppButton(
  label: 'Continue',
  variant: AppButtonVariant.filled,
  size: AppButtonSize.lg,
  onPressed: () {},
  expand: true,
)
```

A11y
- Meets `AppSizes.minTouchTarget`.
- `Semantics(button: true, enabled, label, liveRegion: loading)`.

---

## AppCard

API
- `header: Widget?`
- `media: Widget?` — top media slot
- `child: Widget?` — main content
- `footer: Widget?`
- `padding: EdgeInsetsGeometry` — defaults to `EdgeInsets.all(AppSpacing.lg)`
- `elevation: double` — `AppElevation.*`
- `onTap: VoidCallback?`

Usage
```dart
AppCard(
  header: Text('Recipe Card'),
  child: Padding(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Text('Body'),
  ),
  footer: AppButton(label: 'Open', variant: AppButtonVariant.text, onPressed: () {}),
)
```

A11y
- `Semantics(container: true, button: onTap != null)`.

---

## AppChip

API
- `label: String`
- `selected: bool`
- `enabled: bool`
- `onSelected: ValueChanged<bool>?`
- `leading: Widget?`
- `variant: AppChipVariant` — `selectable | filter`

States
- Selected, unselected, disabled.

Usage
```dart
AppChip(
  label: 'Fast',
  selected: true,
  onSelected: (v) {},
)
```

A11y
- `Semantics(button: true, selected, enabled, label)`.

---

## ChecklistTile

API
- `title: String`
- `subtitle: String?`
- `checked: bool`
- `onChanged: ValueChanged<bool>`
- `leading: Widget?`

Usage
```dart
ChecklistTile(
  title: 'Olive Oil',
  subtitle: 'Pantry staple',
  checked: true,
  onChanged: (v) {},
)
```

A11y
- `Semantics(checked: checked, button: true, label: title)`.
- Checkbox uses tokenized size/spacing and theme colors.

---

## AppSegmentedControl

API
- `segments: List<AppSegment<T>>` with `value` and `label`
- `value: T` — selected value
- `onChanged: ValueChanged<T>`

Behavior
- 2–4 segments with an animated thumb; responds to theme roles.

Usage
```dart
AppSegmentedControl<String>(
  segments: const [
    AppSegment(value: 'fast', label: 'Fast'),
    AppSegment(value: 'regular', label: 'Regular'),
  ],
  value: 'fast',
  onChanged: (v) {},
)
```

A11y
- `Semantics(toggled: true, selected on each button, labels)`.

---

## AppTabs

API
- Thin wrapper over `TabBar` with tokenized indicator weight and padding.
- Use with `DefaultTabController` or a provided `TabController`.

Usage
```dart
const AppTabs(tabs: [
  Tab(text: 'One'),
  Tab(text: 'Two'),
])
```

A11y
- Leverages `TabBar` semantics; indicator and colors from tokens/theme.

---

## AppSkeleton

API
- Rect: `AppSkeleton.rect(width?, height?, radius = AppRadii.md)`
- Circle: `AppSkeleton.circle(size)`

Behavior
- Shimmer effect with tokenized duration (`AppDurations.shimmerPeriod`), opacity (`AppOpacity.shimmerHighlight`), and gradient stops (`AppEffects.shimmerStops`).

Usage
```dart
const AppSkeleton.rect(height: AppSizes.minTouchTarget)
```

A11y
- Decorative only; do not announce content until loaded. Place skeletons where content would be.

