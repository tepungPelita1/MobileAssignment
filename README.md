# Excess Baggage Calculator

A Flutter mobile application that estimates the **excess baggage fee** for air travel.

> ICT602 Mobile Technology – Individual Assignment (20%)
> Author: **NORSHUAIZAM BIN ABDUL SHUKOR** · Lecturer: Madam Idayati Binti Mazlan

## Features

| Requirement | Implementation |
|---|---|
| **Inputs** | Baggage weight (kg) – `TextField`; Ticket class – `RadioGroup` (Economy / Business); Rate per kg (RM) – `TextField` |
| **Outputs** | Excess baggage weight, excess baggage charge, service tax (8%) and total amount payable – formatted as `15.00 kg` / `RM 194.40` with the working shown under each line |
| **Customization** | Custom Material 3 theme (graphite title bar with a teal accent, `primary` + `secondary` colours), custom AppBar / status bar style, custom launcher icon (`flutter_launcher_icons`) |
| **Navigation** | Drawer menu with **Home** and **About** |
| **About page** | App icon, author information (name, matric no, course, lecturer), copyright notice, clickable GitHub URL (`url_launcher`) |
| **Good design practice** | Inline + SnackBar error messages, free-allowance label on each ticket class, "within allowance" / "over the limit" notice, "How to use" instructions card, Reset button, pinned bottom action bar |

## Formula

| Ticket class | Free allowance (X) |
|---|---|
| Economy | 20 kg |
| Business | 40 kg |

```
Excess weight   = weight - X          (0 if weight <= X, never negative)
Excess charge   = excess weight * rate per kg
Service tax     = 8% * excess charge
Total payable   = excess charge + service tax
```

### Sample results (verified by widget tests)

| Weight | Class | Rate | Excess weight | Excess charge | Total payable |
|---|---|---|---|---|---|
| 25 | Economy | 15 | 5 kg | RM 75.00 | RM 81.00 |
| 18 | Economy | 15 | 0 kg | RM 0.00 | RM 0.00 |
| 55 | Business | 12 | 15 kg | RM 180.00 | RM 194.40 |
| 42.5 | Business | 12 | 2.5 kg | RM 30.00 | RM 32.40 |

## Project structure

```
lib/
  main.dart         # main() and MyApp – starts the app
  app_theme.dart    # [1]-[4] colours, author info, theme, app bar, card, Drawer menu
  home_page.dart    # [5]-[13] the calculator page (inputs, formula, result)
  about_page.dart   # [14]-[15] the About page and the GitHub link
assets/icon/        # App icon source images
test/widget_test.dart  # Tests for the 4 sample calculations, errors and navigation
```

## Run the app

```bash
flutter pub get
flutter run
```

Run in Chrome:

```bash
flutter run -d chrome
```

Run the tests:

```bash
flutter test
```

Regenerate the launcher icon after changing `assets/icon/icon.png`:

```bash
dart run flutter_launcher_icons
```

---

© 2026 NORSHUAIZAM BIN ABDUL SHUKOR. All rights reserved.
