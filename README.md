# 🧮 Calculator

A production-ready Material 3 calculator built with Flutter, featuring a clean layered architecture and reactive state management.

---

## 🛠️ Technologies Used

| Category         | Stack                          |
|-------------------|---------------------------------|
| Framework          | Flutter (Dart SDK ≥3.0.0 <4.0.0) |
| UI                 | Material 3                     |
| State Management   | Provider (`^6.1.2`)             |
| Icons              | Cupertino Icons (`^1.0.6`)      |
| Linting            | flutter_lints (`^3.0.0`)        |

---

## 📂 Architecture

```
lib/
├── main.dart                        → App entry point
├── controllers/calculator_controller.dart   → Business logic
├── screens/calculator_screen.dart   → UI composition
├── widgets/calc_button.dart         → Reusable button widget
└── utils/
    ├── theme.dart                   → Colors & ThemeData
    └── constants.dart               → Keypad layout & strings
```

---

## ⚙️ Setup Instructions

**1. Prerequisites**
- ✔ [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- ✔ Android Studio or VS Code with Flutter/Dart plugins

**2. Install dependencies**
```bash
flutter pub get
```

**3. Generate platform folders** *(this repo ships `lib/` + `pubspec.yaml` only)*
```bash
flutter create .
```

**4. Run the app**
```bash
flutter run
```

**5. Build a release APK**
```bash
flutter build apk --release
```

---

## ✨ Key Features
- ⚡ Responsive, layout-driven UI — no hardcoded sizes
- 🌗 Automatic light/dark theme adaptation
- 🧠 Robust logic: operator precedence, div-by-zero handling, decimal guarding
- 🧩 Framework-agnostic controller, fully unit-testable

---

## 📌 License
Not published to pub.dev — for personal/portfolio use.
