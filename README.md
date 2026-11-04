# Excess Baggage Calculator

A Flutter mobile application that estimates the **excess baggage fee** for air travel.

> ICT602 Mobile Technology – Individual Assignment (20%)
> Author: **NORSHUAIZAM BIN ABDUL SHUKOR** · Lecturer: Madam Idayati Binti Mazlan

## Features

| Requirement | Implementation |
|---|---|
| **Inputs** | Baggage weight (kg) – `TextField`; Ticket class – `RadioGroup` (Economy / Business); Rate per kg (RM) – `TextField` |
| **Outputs** | Excess baggage weight, excess baggage charge, service tax (8%) and total amount payable – formatted as `15.00 kg` / `RM 194.40` with the working shown |
| **Customization** | Custom Material 3 theme (navy accent, cool-grey neutrals) in **both light and dark mode** with a title-bar theme switch, custom AppBar / status bar style, custom launcher icon (`flutter_launcher_icons`) |
| **Navigation** | Drawer menu with **Home** and **About** |
| **About page** | App icon, author information (name, matric no, course), copyright notice, clickable GitHub URL (`url_launcher`) |
| **Good design practice** | Inline + SnackBar error messages, helpful notices (free allowance per class, "within allowance" notice), "How to use" instructions card, Reset button, composed empty state before the first calculation, pinned bottom action bar, common-rate shortcut chips, selectable result text, haptic feedback |

## Design system

The whole UI follows one stated set of rules (see the comment block at the top
of `lib/main.dart`), which is what keeps the screens looking like one app:

| Rule | Value |
|---|---|
| **One accent** | Navy `#0D3B66` (lightened to `#9CC4EE` in dark mode). Red = error, green = success — semantics, not decoration |
| **One grey family** | Cool / slate greys only |
| **Shape lock** | Cards 20 · nested blocks + inputs 14 · chips 10 · buttons are pills |
| **One icon family** | Material Symbols *rounded* |
| **Elevation** | Flat surfaces with 1px hairline borders; only the bottom action bar is raised |
| **Spacing** | Multiples of 4 |
| **Numbers** | Tabular figures everywhere, so digits never shift |
| **Motion** | One purposeful animation — the result reveal (fade + 10px rise, 260 ms, strong ease-out) — switched off when the OS asks for reduced motion |
| **Both themes** | Light and dark are designed together, switchable from the title bar |

## Formula

| Ticket class | Free allowance (X) |
|---|---|
| Economy | 20 kg |
| Business | 40 kg |

```
Excess weight   = weight - X          (0 if weight <= X, never negative)
Excess charge   = excess weight * rate per kg
Total payable   = excess charge + (8% * excess charge)
```

### Sample results (verified by unit tests)

| Weight | Class | Rate | Excess weight | Excess charge | Total payable |
|---|---|---|---|---|---|
| 25 | Economy | 15 | 5 kg | RM 75.00 | RM 81.00 |
| 18 | Economy | 15 | 0 kg | RM 0.00 | RM 0.00 |
| 55 | Business | 12 | 15 kg | RM 180.00 | RM 194.40 |
| 42.5 | Business | 12 | 2.5 kg | RM 30.00 | RM 32.40 |

## Project structure

```
lib/main.dart          # Whole app (theme, menu, Home page, About page)
assets/icon/           # App icon source images
test/widget_test.dart  # Tests for the 4 sample calculations, errors and navigation
```

## Run the app

```bash
flutter pub get
flutter run
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
