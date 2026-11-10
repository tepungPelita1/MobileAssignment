# Excess Baggage Calculator

A Flutter mobile application that estimates the **excess baggage fee** for air travel.

> ICT602 Mobile Technology – Individual Assignment (20%)
> Author: **NORSHUAIZAM BIN ABDUL SHUKOR** · Lecturer: Madam Idayati Binti Mazlan

## Features

| Requirement | Implementation |
|---|---|
| **Inputs** | Baggage weight (kg) – `TextField`; Ticket class – `RadioGroup` (Economy / Business); Rate per kg (RM) – `TextField` |
| **Outputs** | Excess baggage weight, excess baggage charge, service tax (8%) and total amount payable – formatted as `15.00 kg` / `RM 194.40` with the working shown under each line |
| **Customization** | Custom Material 3 theme (navy accent, cool-grey neutrals) in both light and dark mode with a title-bar theme switch, custom AppBar / status bar style, custom launcher icon (`flutter_launcher_icons`) |
| **Navigation** | Drawer menu with **Home** and **About** |
| **About page** | App icon, author information (name, matric no, course, lecturer), copyright notice, clickable GitHub URL (`url_launcher`) |
| **Good design practice** | Inline + SnackBar error messages, free-allowance label on each ticket class, "within allowance" notice, "How to use" instructions card, Reset button, pinned bottom action bar |

## Where the code comes from

All the code is in one file, `lib/main.dart`, split into parts `[1]`–`[15]`.
Each part is matched to the lab it was learned from:

| Part | What it is | Lab |
|---|---|---|
| `[1]` | `AppColors` – every colour in the app | Lab 5 (5.2.2) |
| `[2]` | `AppInfo` – author details and GitHub URL | – |
| `[3]` | `buildAppTheme()` + `MyApp` – theme and status bar | Lab 5 (5.2, 5.3) |
| `[4]` | `buildMenu()` – Drawer | Outside the labs (asked by the question) |
| `[5]` | Variables, `TextEditingController`, `dispose()` | Lab 4 (4.3.1) |
| `[6]` | Input checks – `tryParse` + `if` + `return` | Lab 4 (4.4), Lab 5 |
| `[7]` | The formula | Assignment question |
| `[8]` | `showMessage()` (SnackBar) and `reset()` | Lab 3 (3.1.2), Lab 4 |
| `[9]`–`[10]` | Header banner, "How to use" card | Basic layout |
| `[11]` | 2 × `TextField` + `RadioGroup` | Lab 4 (4.2, 4.3.1) |
| `[12]` | `OutlinedButton` + `FilledButton` | Lab 3 (3.1.3) |
| `[13]` | Result card – the 4 outputs | Assignment question |
| `[14]` | `AboutPage` | Assignment question |
| `[15]` | `openGitHub()` with `url_launcher` | Outside the labs (asked by the question) |

Only `[4]` and `[15]` come from outside Lab 1–5, and both are required by the
assignment question. Everything else maps to a lab.

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
