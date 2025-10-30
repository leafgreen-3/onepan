# Contributing to OnePan

Thanks for contributing! This guide outlines how to propose changes and what we expect for pull requests.

## Development

- Follow the architecture and UI rules defined in:
  - `README.md`, `Project_Plan.md`, `Project_Specs.md`, `UI_Principles.md`
- Respect design tokens. Do not introduce raw spacing/sizes/colors.
- Keep scope within the 6 MVP screens.

## Tests

- We use unit and widget tests (Riverpod + go_router). See `docs/testing.md` for patterns and examples.
- Mock data sources with `mocktail` and inject via `get_it` (or provider overrides when applicable).
- Use stable Keys in UI to avoid flaky finders:
  - `home_empty_message`, `home_refresh_button`, `home_error_message`, `home_retry_button`
  - `recipe_card_<id>`, `favorite_<id>`

## Before you open a PR

- [ ] Update or add tests for your changes
- [ ] Run analyzer: `flutter analyze`
- [ ] Run tests: `flutter test` (and optionally `--coverage`)
- [ ] Include screenshots/GIFs for any UI changes (before/after if possible)
- [ ] Ensure no raw values for spacing, sizes, or colors (use tokens)

## CI

PRs are validated by GitHub Actions. Failures appear on the PR checks with links to build logs. See `docs/ci.md` for details.

