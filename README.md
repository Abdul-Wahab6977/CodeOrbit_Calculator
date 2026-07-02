# Calculator

A production-ready Flutter calculator with a Material 3 UI and a clean,
layered architecture.

## Architecture

```
lib/
├── main.dart                          # Entry point: Provider + MaterialApp wiring
├── controllers/
│   └── calculator_controller.dart     # Pure business logic (ChangeNotifier)
├── screens/
│   └── calculator_screen.dart         # UI composition, no logic
├── widgets/
│   └── calc_button.dart               # Reusable, themeable button
└── utils/
    ├── theme.dart                     # Color palette + light/dark ThemeData
    └── constants.dart                 # Keypad layout & string constants
```

**Why this split:** `CalculatorController` has zero Flutter UI imports — it
only depends on `ChangeNotifier` — so its arithmetic logic (operator
precedence, division-by-zero handling, decimal validation) can be unit
tested without pumping any widgets. The UI layer (`screens/`, `widgets/`)
only reads state from the controller through `Consumer`/`Provider` and
never contains calculation logic itself.

## Key Features

- **Material 3** UI with a slate-gray / matte-black dark palette and an
  orange/blue accent, adapting automatically to system light/dark mode
- **Two-row display**: a smaller expression line on top, a bold live/final
  result on the bottom, auto-shrinking (`FittedBox`) so large numbers never
  overflow
- **Fully responsive grid**: no hardcoded pixel sizes — button font size
  and radius are derived from the available cell size via `LayoutBuilder`
- **Provider-based state**: UI rebuilds only through `notifyListeners()`,
  no nested `setState`
- **Robust edge-case handling**:
  - Division by zero → shows "Cannot divide by zero" instead of crashing
    or displaying `Infinity`
  - Consecutive operators (`5 + ×`) → the new operator replaces the old
    one instead of corrupting the expression
  - Decimal points → strictly one `.` per number

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Android Studio or VS Code with Flutter/Dart plugins

### Run it
```bash
flutter pub get
flutter run
```

This repo only contains the `lib/` sources and `pubspec.yaml`. If opening
it fresh, generate the platform folders around the existing code with:
```bash
flutter create .
```

### Build a release APK
```bash
flutter build apk --release
```

## Suggested Next Steps for Production
- Add unit tests for `CalculatorController` (precedence, div-by-zero,
  decimal guarding, consecutive-operator replacement)
- Add a `golden` test or widget test for `CalculatorScreen` at a few
  screen sizes to lock in the responsive layout
- Wire up an app icon and splash screen (`flutter_launcher_icons`,
  `flutter_native_splash`)
- Consider `Hero`/subtle animations on button press for extra polish
