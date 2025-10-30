# CI Overview

We use GitHub Actions to run static analysis and tests on every push and pull request. The workflow is defined at:

- `.github/workflows/flutter-ci.yml`

Steps:

- Checkout the repository
- Setup Flutter (stable channel)
- `flutter pub get`
- `flutter analyze`
- `flutter test --coverage`

If coverage is enabled, the report is stored at `coverage/lcov.info`. You can view it locally with:

```
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

PRs display pass/fail status in the Checks tab; click through for full logs.

