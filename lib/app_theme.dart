// =====================================================================
// Baggage Calculator - app_theme.dart
// ICT602 Mobile Technology - Individual Assignment
// NORSHUAIZAM BIN ABDUL SHUKOR (2025229096)
//
// Parts [1] to [4]: colours, author info, theme, and the widgets shared
// by both pages (app bar, card, line and the navigation menu).
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'about_page.dart';

// =====================================================================
// [1] APP COLORS (Lab 5, 5.2.2) - change the app colours here
// =====================================================================
class AppColors {
  // Colour idea: airport signs - a dark graphite panel with a teal
  // accent, on top of a light grey screen.

  // --- Main colours (Lab 5: colorPrimary + colorOnPrimary) ---
  static const Color colorPrimary = Color(0xFF012E5E); // navy, same as the app icon
  static const Color colorOnPrimary = Color(0xFFFFFFFF); // white on graphite

  // --- Accent colour (Lab 5 exercise 2: secondary + onSecondary) ---
  static const Color colorSecondary = Color(0xFF0F6E6C); // teal
  static const Color colorOnSecondary = Color(0xFFFFFFFF); // white on teal
  static const Color colorOnSecondarySoft = Color(0xFFD2ECEB); // faded text
  static const Color colorSecondaryLight = Color(0xFF7FD6D2); // icon on banner
  static const Color colorSecondarySoft = Color(0xFFE3F2EF); // light teal banner fill
  static const Color colorSecondaryBorder = Color(0xFFB7DDD7); // banner border
  static const Color colorAmber = Color(0xFFE39B1B); // lightbulb icon (How to use)

  // --- Screen, cards and text ---
  static const Color colorBackground = Color.fromARGB(255, 242, 241, 238); // warm light grey
  static const Color colorSurface = Color(0xFFFFFFFF); // cards
  static const Color colorHairline = Color(0xFFD5DCDF); // card borders
  static const Color colorMuted = Color(0xFF5B6B75); // small grey text
  static const Color colorOnSurface = Color(0xFF14222B); // main text
  static const Color colorSuccess = Color(0xFF1D7A57); // "nothing to pay"

  // --- Light background versions of the colours above ---
  // Used for small boxes and circles behind icons.
  static const Color colorPrimarySoft = Color(0xFFE3E9EC);
  static const Color colorSuccessSoft = Color(0xFFE5F1EB);
  static const Color colorWarning = Color(0xFFD97A1E); // orange icon "over the allowance"
  static const Color colorWarningSoft = Color.fromARGB(255, 248, 232, 216); // light orange box

  // --- Colours used on top of the graphite banner ---
  static const Color colorOnPrimarySoft = Color.fromARGB(255, 255, 255, 255); // faded text
  static const Color colorPrimaryCircle = Color(0xFF012E5E); // icon circle (lighter navy)
}

// Corner radius, so every box in the app has the same shape.
class AppShape {
  static const double card = 20; // cards
  static const double block = 14; // small boxes and text fields
  static const double chip = 10; // number badges
}

// =====================================================================
// [2] AUTHOR INFORMATION - shown on the About page
// =====================================================================
class AppInfo {
  static const String appTitle = 'Baggage Calculator';
  static const String version = '1.0.0';
  static const String name = 'NORSHUAIZAM BIN ABDUL SHUKOR';
  static const String matricNo = '2025229096';
  static const String course = 'ICT602 - Mobile Technology';
  static const String lecturer = 'Madam Idayati Binti Mazlan';
  static const String githubUrl =
      'https://github.com/tepungPelita1/MobileAssignment';
}

// =====================================================================
// [3] APP + THEME (Lab 5, 5.2 and 5.3)
// =====================================================================

/// Builds the app theme.
/// Lab 5: fromSeed() makes a full colour scheme, copyWith() forces the
/// colours we chose in AppColors.
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.colorBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.colorPrimary,
    ).copyWith(
      primary: const Color.fromARGB(255, 3, 3, 3),
      onPrimary: AppColors.colorOnPrimary,
      secondary: AppColors.colorSecondary,
      onSecondary: AppColors.colorOnSecondary,
      surface: AppColors.colorSurface,
      onSurface: AppColors.colorOnSurface,
      onSurfaceVariant: AppColors.colorMuted, // small grey text
      outline: AppColors.colorHairline, // card and text field borders
      outlineVariant: AppColors.colorHairline,
      tertiary: AppColors.colorSuccess, // green "nothing to pay"
    ),
  );
}

/// The title bar, used by the Home page and the About page.
/// Lab 5 (5.2.2 step 3 and 5.3): the AppBar colours and the status bar
/// style are set here, inside the widget.
AppBar buildAppBar(BuildContext context, String title) {
  const Color barColor = AppColors.colorPrimary;
  const Color textColor = AppColors.colorOnPrimary;

  return AppBar(
    title: Text(title),
    backgroundColor: barColor,
    foregroundColor: textColor,
    elevation: 0,
    scrolledUnderElevation: 0, // do not change colour when scrolling
    titleTextStyle: TextStyle(
      color: textColor,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
    // Lab 5 (5.3): status bar colour and icon colour
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: barColor,
      statusBarIconBrightness: Brightness.light, // white icons (Android)
      statusBarBrightness: Brightness.dark, // white icons (iOS)
    ),
  );
}

/// A white card with rounded corners and a thin border.
/// Card is not in the labs, so the colour, border and corner are set here.
Widget buildCard(BuildContext context, Widget child) {
  final ColorScheme colors = Theme.of(context).colorScheme;
  return Card(
    color: colors.surface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppShape.card),
      side: BorderSide(color: colors.outline),
    ),
    child: child,
  );
}

/// A thin line between two rows.
Widget buildLine(BuildContext context) => Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outline,
    );

// =====================================================================
// [4] NAVIGATION MENU (Drawer) - NOT from the labs.
// The assignment question asks for a navigation menu, so this part was
// learned outside the lab:
//   * drawer: in Scaffold adds the hamburger button automatically
//   * Navigator.pop(context)  = close the menu / close the page
//   * Navigator.push(...)     = open the About page on top of Home
// =====================================================================
Widget buildMenu(
  BuildContext context, {
  required bool isHome,
}) {
  final ColorScheme colors = Theme.of(context).colorScheme;
  final TextTheme fonts = Theme.of(context).textTheme;

  // One row of the menu.
  Widget item({
    required Key key,
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      key: key,
      leading: Icon(icon),
      iconColor: colors.onSurfaceVariant,
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: selected,
      selectedColor: colors.primary,
      selectedTileColor: AppColors.colorPrimarySoft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppShape.block),
      ),
      onTap: onTap,
    );
  }

  return Drawer(
    backgroundColor: colors.surface,
    child: SafeArea(
      child: Column(
        children: [
          // Header: the app icon and name
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppShape.block),
                  // Lab 2 (step 6): showing an image from assets
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 48,
                    height: 48,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppInfo.appTitle,
                        style: fonts.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppInfo.course,
                        style: fonts.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          buildLine(context),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                item(
                  key: const Key('menuHome'),
                  icon: Icons.home_rounded,
                  label: 'Home',
                  selected: isHome,
                  onTap: () {
                    Navigator.pop(context); // close the menu
                    if (!isHome) {
                      Navigator.pop(context); // close the About page
                    }
                  },
                ),
                const SizedBox(height: 4),
                item(
                  key: const Key('menuAbout'),
                  icon: Icons.info_rounded,
                  label: 'About',
                  selected: !isHome,
                  onTap: () {
                    Navigator.pop(context); // close the menu
                    if (isHome) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const AboutPage(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Version ${AppInfo.version}',
                style: fonts.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
