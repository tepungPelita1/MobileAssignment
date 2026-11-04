import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

// =====================================================================
// DESIGN SYSTEM RULES - stated once here, never broken below
// ---------------------------------------------------------------------
//  * ONE ACCENT: navy (AppColors.colorPrimary, lightened for dark mode).
//    Red = error, green = success. Those are semantics, not accents.
//  * ONE GREY FAMILY: cool / slate greys. No warm greys anywhere.
//  * SHAPE LOCK: cards 20, nested blocks + inputs 14, chips 10,
//    buttons are pills (StadiumBorder).
//  * ONE ICON FAMILY: Material Symbols "rounded" variants only.
//  * ELEVATION: flat surfaces with a 1px hairline border. Only the
//    bottom action bar is raised, because it floats over content.
//  * SPACING: multiples of 4 only.
//  * NUMBERS: tabular figures everywhere, so digits never jitter.
//  * MOTION: one purposeful animation (the result reveal) under 300ms
//    with a strong ease-out, switched off when the OS asks for less
//    motion. Everything else uses the platform default.
// =====================================================================

// =====================================================================
// [1] APP COLORS (Lab 5) - change the app colours here
// =====================================================================
class AppColors {
  // --- The single accent, one hue, one tone per theme ---
  static const Color colorPrimary = Color(0xFF0D3B66); // navy blue
  static const Color colorOnPrimary = Color(0xFFFFFFFF); // white on navy
  static const Color colorPrimaryDark = Color(0xFF9CC4EE); // navy for dark
  static const Color colorOnPrimaryDark = Color(0xFF002544); // text on it

  // --- Light theme neutrals (cool greys) ---
  static const Color colorBackground = Color(0xFFF4F6FA); // screen
  static const Color colorSurface = Color(0xFFFFFFFF); // cards
  static const Color colorHairline = Color(0xFFE2E8F0); // 1px borders
  static const Color colorMuted = Color(0xFF5B6B7F); // secondary text
  static const Color colorOnSurface = Color(0xFF111A24); // primary text

  // --- Dark theme neutrals (same cool family) ---
  static const Color darkBackground = Color(0xFF0E1318);
  static const Color darkSurface = Color(0xFF171E26);
  static const Color darkField = Color(0xFF1F2832);
  static const Color darkHairline = Color(0xFF2A333E);
  static const Color darkMuted = Color(0xFF98A6B8);
  static const Color darkOnSurface = Color(0xFFE7ECF3);

  // --- Status colours (semantics, never used as decoration) ---
  static const Color colorSuccess = Color(0xFF1B7A55);
  static const Color colorSuccessDark = Color(0xFF6ED3A6);

  // Kept for backward compatibility with Lab 5 naming.
  static const Color colorSecondary = colorPrimary;
  static const Color colorOnSecondary = colorOnPrimary;
}

// =====================================================================
// SHAPE + SPACING + MOTION TOKENS
// =====================================================================
class AppShape {
  static const double card = 20; // cards
  static const double block = 14; // nested blocks + inputs
  static const double chip = 10; // chips + small badges
}

class AppMotion {
  // Strong ease-out. Built-in curves are too weak for UI entrances.
  static const Curve easeOut = Cubic(0.23, 1, 0.32, 1);
  static const Duration reveal = Duration(milliseconds: 260);
  static const Duration scroll = Duration(milliseconds: 320);
}

/// Tabular figures: every number in this app lines up in a column.
const List<FontFeature> kTabular = <FontFeature>[FontFeature.tabularFigures()];

// =====================================================================
// [2] AUTHOR INFORMATION - shown on the About page
// =====================================================================
class AppInfo {
  static const String appTitle = 'Excess Baggage Calculator';
  static const String version = '1.0.0';
  static const String name = 'NORSHUAIZAM BIN ABDUL SHUKOR';
  static const String matricNo = '2025229096';
  static const String course = 'ICT602 - Mobile Technology';
  static const String lecturer = 'Madam Idayati Binti Mazlan';
  static const String githubUrl =
      'https://github.com/tepungPelita1/BaggageCalculator';
}

// =====================================================================
// [3] APP + THEME (Lab 5) - the look of the whole app is set here
// =====================================================================

/// Light or dark, switchable from the title bar on every page.
class AppTheme {
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static void toggle(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    mode.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}

ThemeData buildAppTheme(Brightness brightness) {
  final bool dark = brightness == Brightness.dark;

  final Color accent =
      dark ? AppColors.colorPrimaryDark : AppColors.colorPrimary;
  final Color onAccent =
      dark ? AppColors.colorOnPrimaryDark : AppColors.colorOnPrimary;
  final Color background =
      dark ? AppColors.darkBackground : AppColors.colorBackground;
  final Color surface = dark ? AppColors.darkSurface : AppColors.colorSurface;
  final Color field = dark ? AppColors.darkField : AppColors.colorBackground;
  final Color hairline =
      dark ? AppColors.darkHairline : AppColors.colorHairline;
  final Color muted = dark ? AppColors.darkMuted : AppColors.colorMuted;
  final Color onSurface =
      dark ? AppColors.darkOnSurface : AppColors.colorOnSurface;
  final Color success =
      dark ? AppColors.colorSuccessDark : AppColors.colorSuccess;

  final ColorScheme colors = ColorScheme.fromSeed(
    seedColor: AppColors.colorPrimary,
    brightness: brightness,
  ).copyWith(
    primary: accent,
    onPrimary: onAccent,
    // There is no second accent: "secondary" is the same navy.
    secondary: accent,
    onSecondary: onAccent,
    surface: surface,
    onSurface: onSurface,
    onSurfaceVariant: muted,
    outline: hairline,
    outlineVariant: hairline,
    tertiary: success,
  );

  OutlineInputBorder fieldBorder(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppShape.block),
        borderSide: BorderSide(color: color, width: width),
      );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colors,
    scaffoldBackgroundColor: background,
    splashFactory: InkSparkle.splashFactory,

    // Title bar + status bar (Lab 5)
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? surface : AppColors.colorPrimary,
      foregroundColor: dark ? onSurface : AppColors.colorOnPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: dark ? onSurface : AppColors.colorOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      shape: Border(bottom: BorderSide(color: dark ? hairline : background)),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:
            dark ? AppColors.darkSurface : AppColors.colorPrimary,
        statusBarIconBrightness: Brightness.light, // white icons (Android)
        statusBarBrightness: Brightness.dark, // white icons (iOS)
      ),
    ),

    // Flat cards, hairline border, shape-locked radius
    cardTheme: CardThemeData(
      color: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppShape.card),
        side: BorderSide(color: hairline),
      ),
    ),

    // Filled text fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      prefixIconColor: muted,
      labelStyle: TextStyle(color: muted),
      floatingLabelStyle:
          TextStyle(color: accent, fontWeight: FontWeight.w600),
      hintStyle: TextStyle(color: muted.withValues(alpha: 0.7)),
      prefixStyle: TextStyle(
        color: onSurface,
        fontWeight: FontWeight.w600,
        fontFeatures: kTabular,
      ),
      suffixStyle: TextStyle(color: muted, fontWeight: FontWeight.w600),
      border: fieldBorder(hairline, 1),
      enabledBorder: fieldBorder(hairline, 1),
      focusedBorder: fieldBorder(accent, 1.6),
      errorBorder: fieldBorder(colors.error, 1),
      focusedErrorBorder: fieldBorder(colors.error, 1.6),
    ),

    // Actions are pills, and tall enough to tap
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 54),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 54),
        foregroundColor: onSurface,
        side: BorderSide(color: hairline),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: field,
      side: BorderSide(color: hairline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppShape.chip),
      ),
      labelStyle: TextStyle(
        color: onSurface,
        fontWeight: FontWeight.w600,
        fontFeatures: kTabular,
      ),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: muted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppShape.block),
      ),
    ),

    dividerTheme: DividerThemeData(color: hairline, thickness: 1, space: 1),
    drawerTheme: DrawerThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? accent : muted,
      ),
    ),

    // SnackBar floats above the bottom of the screen
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppShape.block),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (BuildContext context, ThemeMode mode, Widget? _) {
        return MaterialApp(
          title: AppInfo.appTitle,
          debugShowCheckedModeBanner: false, // Lab 2
          theme: buildAppTheme(Brightness.light),
          darkTheme: buildAppTheme(Brightness.dark),
          themeMode: mode, // follows the phone, or the title-bar switch
          home: const HomePage(),
        );
      },
    );
  }
}

/// Light / dark switch, shown in the title bar of every page.
Widget buildThemeButton(BuildContext context) {
  final bool dark = Theme.of(context).brightness == Brightness.dark;
  return IconButton(
    key: const Key('btnTheme'),
    tooltip: dark ? 'Switch to light mode' : 'Switch to dark mode',
    icon: Icon(dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
    onPressed: () => AppTheme.toggle(context),
  );
}

// =====================================================================
// [4] NAVIGATION MENU (Drawer) - used by both Home and About pages
// =====================================================================
Widget buildMenu(BuildContext context, {required bool isHome}) {
  final ColorScheme colors = Theme.of(context).colorScheme;
  final TextTheme fonts = Theme.of(context).textTheme;

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
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: selected,
      selectedColor: colors.primary,
      selectedTileColor: colors.primary.withValues(alpha: 0.09),
      onTap: onTap,
    );
  }

  return Drawer(
    child: SafeArea(
      child: Column(
        children: [
          // Header: app identity, nothing else
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppShape.block),
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
          const Divider(),
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
                      Navigator.pop(context); // go back to Home page
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
                          builder: (BuildContext context) => const AboutPage(),
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
                  fontFeatures: kTabular,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// =====================================================================
// HOME PAGE - the calculator
// =====================================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // -------------------------------------------------------------------
  // [5] VARIABLES (Lab 4)
  // -------------------------------------------------------------------
  final TextEditingController weightController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  String? selectedClass; // 'Economy' or 'Business', null = nothing selected

  // Error messages shown under each input (null = no error)
  String? weightError;
  String? classError;
  String? rateError;

  // Results
  bool showResult = false;
  double weight = 0;
  double rate = 0;
  int allowance = 0; // X = 20 kg (Economy) or 40 kg (Business)
  double excessWeight = 0;
  double excessCharge = 0;
  double serviceTax = 0;
  double totalPayable = 0;

  // The one animation in this app: the result sliding into place.
  late final AnimationController revealController = AnimationController(
    vsync: this,
    duration: AppMotion.reveal,
  );
  final GlobalKey resultAnchor = GlobalKey();

  bool get reduceMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  @override
  void dispose() {
    revealController.dispose();
    weightController.dispose();
    rateController.dispose();
    super.dispose();
  }

  void calculate() {
    FocusScope.of(context).unfocus(); // hide the keyboard

    setState(() {
      weightError = null;
      classError = null;
      rateError = null;
      showResult = false;
    });

    // -----------------------------------------------------------------
    // [6] CHECK THE INPUTS (Lab 4: if + tryParse + message)
    // -----------------------------------------------------------------
    final String weightText = weightController.text.trim();
    final String rateText = rateController.text.trim();
    final double? w = double.tryParse(weightText); // null if not a number
    final double? r = double.tryParse(rateText);

    if (weightText.isEmpty) {
      showError(field: 'weight', text: 'Please enter the baggage weight.');
      return;
    }
    if (w == null) {
      showError(
        field: 'weight',
        text: 'Weight must be a number, e.g. 25 or 42.5.',
      );
      return;
    }
    if (w <= 0) {
      showError(field: 'weight', text: 'Weight must be more than 0 kg.');
      return;
    }
    if (selectedClass == null) {
      showError(field: 'class', text: 'Please select a ticket class.');
      return;
    }
    if (rateText.isEmpty) {
      showError(field: 'rate', text: 'Please enter the rate per kg.');
      return;
    }
    if (r == null) {
      showError(field: 'rate', text: 'Rate must be a number, e.g. 15.');
      return;
    }
    if (r <= 0) {
      showError(field: 'rate', text: 'Rate must be more than RM 0.');
      return;
    }

    // -----------------------------------------------------------------
    // [7] THE FORMULA (from the assignment question)
    // -----------------------------------------------------------------
    int x;
    if (selectedClass == 'Economy') {
      x = 20;
    } else {
      x = 40;
    }

    double excess = w - x;
    if (excess < 0) {
      excess = 0; // never negative
    }
    double charge = excess * r;
    double tax = charge * 0.08; // 8% service tax
    double total = charge + tax;

    setState(() {
      weight = w;
      rate = r;
      allowance = x;
      excessWeight = excess;
      excessCharge = charge;
      serviceTax = tax;
      totalPayable = total;
      showResult = true;
    });

    HapticFeedback.lightImpact(); // one tick, on the same frame as the result
    revealResult();
  }

  /// Fade + 10px rise, then bring the result into view. Both are skipped
  /// when the phone is set to reduce motion.
  void revealResult() {
    if (reduceMotion) {
      revealController.value = 1;
    } else {
      revealController.forward(from: 0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? anchor = resultAnchor.currentContext;
      if (anchor == null) return;
      Scrollable.ensureVisible(
        anchor,
        alignment: 0.06,
        duration: reduceMotion ? Duration.zero : AppMotion.scroll,
        curve: AppMotion.easeOut,
      );
    });
  }

  // -------------------------------------------------------------------
  // [8] MESSAGES + RESET
  // -------------------------------------------------------------------
  void showError({required String field, required String text}) {
    setState(() {
      if (field == 'weight') weightError = text;
      if (field == 'class') classError = text;
      if (field == 'rate') rateError = text;
    });
    HapticFeedback.heavyImpact();
    showMessage(text, Theme.of(context).colorScheme.error);
  }

  void showMessage(String text, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void reset() {
    FocusScope.of(context).unfocus();
    setState(() {
      weightController.clear();
      rateController.clear();
      selectedClass = null;
      weightError = null;
      classError = null;
      rateError = null;
      showResult = false;
    });
    revealController.value = 0;
    showMessage('Form has been reset.', Theme.of(context).colorScheme.primary);
  }

  // When the user types again, hide the old result and error
  void onInputChanged() {
    setState(() {
      showResult = false;
      weightError = null;
      rateError = null;
    });
  }

  void pickRate(String value) {
    rateController.text = value;
    rateController.selection =
        TextSelection.collapsed(offset: rateController.text.length);
    HapticFeedback.selectionClick();
    onInputChanged();
  }

  // e.g. 194.4 -> "RM 194.40"
  String money(double value) => 'RM ${value.toStringAsFixed(2)}';

  // e.g. 42.5 -> "42.50"
  String twoDp(double value) => value.toStringAsFixed(2);

  // Numbers in prose read like a product, not a database: 25, 42.5
  String trim(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme fonts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppInfo.appTitle),
        actions: [buildThemeButton(context)],
      ),
      drawer: buildMenu(context, isHome: true),
      // The primary action stays reachable with one thumb and rides
      // above the keyboard instead of hiding behind it.
      bottomNavigationBar: buildActionBar(colors),
      body: SelectionArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // -----------------------------------------------------
              // [9] HEADER BANNER
              // -----------------------------------------------------
              buildHero(colors, fonts),
              const SizedBox(height: 16),

              // -----------------------------------------------------
              // [10] INSTRUCTIONS
              // -----------------------------------------------------
              buildHowToUse(colors, fonts),
              const SizedBox(height: 16),

              // -----------------------------------------------------
              // [11] INPUTS
              // -----------------------------------------------------
              buildInputs(colors, fonts),
              const SizedBox(height: 16),

              // [13] RESULT - an empty state until a calculation succeeds
              KeyedSubtree(
                key: resultAnchor,
                child: showResult
                    ? AnimatedBuilder(
                        animation: revealController,
                        builder: (BuildContext context, Widget? child) {
                          final double t = AppMotion.easeOut
                              .transform(revealController.value)
                              .clamp(0.0, 1.0);
                          return Opacity(
                            opacity: t,
                            child: Transform.translate(
                              offset: Offset(0, (1 - t) * 10),
                              child: child,
                            ),
                          );
                        },
                        child: buildResultCard(colors, fonts),
                      )
                    : buildEmptyResult(colors, fonts),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // [9] HERO
  // -------------------------------------------------------------------
  Widget buildHero(ColorScheme colors, TextTheme fonts) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(AppShape.card),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.onPrimary.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.flight_takeoff_rounded,
              color: colors.onPrimary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overweight luggage?',
                  style: fonts.titleMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estimate your excess baggage fee before you reach the '
                  'check-in counter.',
                  style: fonts.bodyMedium?.copyWith(
                    color: colors.onPrimary.withValues(alpha: 0.82),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // [10] HOW TO USE
  // -------------------------------------------------------------------
  Widget buildHowToUse(ColorScheme colors, TextTheme fonts) {
    Widget step(int number, String label) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(AppShape.chip),
              ),
              child: Text(
                '$number',
                style: fonts.labelMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                  fontFeatures: kTabular,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(label, style: fonts.bodyMedium),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_rounded,
                  size: 20,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'How to use',
                  style: fonts.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            step(1, 'Enter your checked baggage weight in kg.'),
            step(2, 'Choose your ticket class.'),
            step(3, 'Enter the airline excess rate per kg.'),
            step(4, 'Tap Calculate. The 8% service tax is added for you.'),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // [11] INPUTS
  // -------------------------------------------------------------------
  Widget buildInputs(ColorScheme colors, TextTheme fonts) {
    Widget label(String text) => Text(
          text,
          style: fonts.labelLarge?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        );

    Widget classOption({
      required Key key,
      required String value,
      required String allowanceLabel,
    }) {
      final bool selected = selectedClass == value;
      return RadioListTile<String>(
        key: key,
        value: value,
        selected: selected,
        title: Text(
          value,
          style: fonts.bodyLarge?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          allowanceLabel,
          style: fonts.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontFeatures: kTabular,
          ),
        ),
        activeColor: colors.primary,
        tileColor: selected ? colors.primary.withValues(alpha: 0.06) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppShape.block),
          side: BorderSide(
            color: selected ? colors.primary : colors.outlineVariant,
            width: selected ? 1.6 : 1,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Baggage details',
              style: fonts.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            // Input 1: Baggage weight (TextField)
            TextField(
              key: const Key('weightField'),
              controller: weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFeatures: kTabular,
                color: colors.onSurface,
              ),
              onChanged: (String value) => onInputChanged(),
              decoration: InputDecoration(
                labelText: 'Baggage weight',
                hintText: 'e.g. 25 or 42.5',
                suffixText: 'kg',
                prefixIcon: const Icon(Icons.luggage_rounded),
                errorText: weightError,
              ),
            ),
            const SizedBox(height: 24),

            // Input 2: Ticket class (RadioGroup - Lab 4)
            label('Ticket class'),
            const SizedBox(height: 8),
            RadioGroup<String>(
              groupValue: selectedClass,
              onChanged: (String? v) => setState(() {
                selectedClass = v;
                classError = null;
                showResult = false;
              }),
              child: Column(
                children: [
                  classOption(
                    key: const Key('radioEconomy'),
                    value: 'Economy',
                    allowanceLabel: 'Free allowance: 20 kg',
                  ),
                  const SizedBox(height: 8),
                  classOption(
                    key: const Key('radioBusiness'),
                    value: 'Business',
                    allowanceLabel: 'Free allowance: 40 kg',
                  ),
                ],
              ),
            ),
            if (classError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  classError!,
                  style: fonts.bodySmall?.copyWith(color: colors.error),
                ),
              ),
            const SizedBox(height: 24),

            // Input 3: Rate per kg (TextField)
            TextField(
              key: const Key('rateField'),
              controller: rateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFeatures: kTabular,
                color: colors.onSurface,
              ),
              onChanged: (String value) => onInputChanged(),
              onSubmitted: (String value) => calculate(),
              decoration: InputDecoration(
                labelText: 'Excess rate per kg',
                hintText: 'e.g. 15',
                prefixText: 'RM ',
                suffixText: '/ kg',
                prefixIcon: const Icon(Icons.payments_rounded),
                errorText: rateError,
              ),
            ),
            const SizedBox(height: 12),

            // Common airline rates - saves typing, still editable
            Row(
              children: [
                Text(
                  'Common rates',
                  style: fonts.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <String>['12', '15', '20', '25']
                        .map(
                          (String value) => ActionChip(
                            label: Text('RM $value'),
                            // Visually 32pt, but a 48pt tap target.
                            materialTapTargetSize:
                                MaterialTapTargetSize.padded,
                            onPressed: () => pickRate(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // [12] BUTTONS (Lab 3) - pinned action bar
  // -------------------------------------------------------------------
  Widget buildActionBar(ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('btnReset'),
                  onPressed: reset,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text(
                    'Reset',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  key: const Key('btnCalculate'),
                  onPressed: calculate,
                  icon: const Icon(Icons.calculate_rounded, size: 20),
                  label: const Text(
                    'Calculate',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // [13] RESULT - empty state, then the 3 outputs
  // -------------------------------------------------------------------
  Widget buildEmptyResult(ColorScheme colors, TextTheme fonts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 28,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No estimate yet',
              style: fonts.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Fill in the three details above and tap Calculate. Your excess '
              'weight, charge, service tax and total will appear here.',
              textAlign: TextAlign.center,
              style: fonts.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResultCard(ColorScheme colors, TextTheme fonts) {
    final bool noExcess = excessWeight == 0;
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color noticeColor = noExcess ? colors.tertiary : colors.primary;

    return Card(
      key: const Key('resultCard'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long_rounded, size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  'Result',
                  style: fonts.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${trim(weight)} kg  ·  $selectedClass  ·  RM ${trim(rate)} / kg',
              style: fonts.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontFeatures: kTabular,
              ),
            ),
            const SizedBox(height: 16),

            // Output 1
            resultRow(
              colors,
              fonts,
              'Excess baggage weight',
              '${twoDp(excessWeight)} kg',
              noExcess
                  ? '${twoDp(weight)} - $allowance is not more than 0, so 0 kg'
                  : '${twoDp(weight)} - $allowance = ${twoDp(excessWeight)} kg',
              const Key('outExcessWeight'),
            ),
            const Divider(height: 1),
            // Output 2
            resultRow(
              colors,
              fonts,
              'Excess baggage charge',
              money(excessCharge),
              '${twoDp(excessWeight)} kg x ${money(rate)}',
              const Key('outExcessCharge'),
            ),
            const Divider(height: 1),
            resultRow(
              colors,
              fonts,
              'Service tax (8%)',
              money(serviceTax),
              '8% x ${money(excessCharge)}',
              const Key('outTax'),
            ),
            const SizedBox(height: 20),

            // Output 3: Total amount payable - the one display number
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(AppShape.block),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total amount payable',
                          style: fonts.labelLarge?.copyWith(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Includes 8% service tax',
                          style: fonts.bodySmall?.copyWith(
                            color: colors.onPrimary.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        money(totalPayable),
                        key: const Key('outTotal'),
                        style: fonts.headlineSmall?.copyWith(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          fontFeatures: kTabular,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Helpful notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: noticeColor.withValues(alpha: dark ? 0.14 : 0.07),
                borderRadius: BorderRadius.circular(AppShape.block),
              ),
              child: Row(
                children: [
                  Icon(
                    noExcess
                        ? Icons.check_circle_rounded
                        : Icons.info_rounded,
                    size: 20,
                    color: noticeColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      noExcess
                          ? 'Good news! Your baggage is within the '
                              '$selectedClass allowance of $allowance kg. '
                              'Nothing to pay.'
                          : 'Your baggage is ${trim(excessWeight)} kg over the '
                              '$selectedClass allowance of $allowance kg.',
                      style: fonts.bodyMedium?.copyWith(height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resultRow(
    ColorScheme colors,
    TextTheme fonts,
    String label,
    String value,
    String working,
    Key key,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: fonts.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  working,
                  style: fonts.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontFeatures: kTabular,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            key: key,
            style: fonts.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: kTabular,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// [14] ABOUT PAGE
// =====================================================================
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // [15] Open the GitHub link in the browser (url_launcher package)
  Future<void> openGitHub(BuildContext context) async {
    final bool opened = await launchUrl(
      Uri.parse(AppInfo.githubUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme fonts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        actions: [buildThemeButton(context)],
      ),
      drawer: buildMenu(context, isHome: false),
      body: SelectionArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            children: [
              // Application icon
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppShape.card),
                  border: Border.all(color: colors.outlineVariant),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/icon/icon.png',
                  width: 96,
                  height: 96,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppInfo.appTitle,
                textAlign: TextAlign.center,
                style: fonts.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version ${AppInfo.version}',
                style: fonts.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontFeatures: kTabular,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Estimate the excess baggage fee for your flight based on '
                'baggage weight, ticket class and the airline rate per kg.',
                textAlign: TextAlign.center,
                style: fonts.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),

              // Author information
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    sectionHeader(colors, fonts, 'Author Information'),
                    const Divider(height: 1),
                    infoRow(
                      context,
                      Icons.person_rounded,
                      'Name',
                      AppInfo.name,
                    ),
                    const Divider(height: 1),
                    infoRow(
                      context,
                      Icons.badge_rounded,
                      'Matric No',
                      AppInfo.matricNo,
                    ),
                    const Divider(height: 1),
                    infoRow(
                      context,
                      Icons.school_rounded,
                      'Course',
                      AppInfo.course,
                    ),
                    const Divider(height: 1),
                    infoRow(
                      context,
                      Icons.co_present_rounded,
                      'Lecturer',
                      AppInfo.lecturer,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // How the number is worked out
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    sectionHeader(colors, fonts, 'How the fee is calculated'),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          formulaBlock(colors, fonts, <String>[
                            'Excess weight = baggage weight - free allowance',
                            'Excess charge = excess weight x rate per kg',
                            'Total payable = excess charge + 8% service tax',
                          ]),
                          const SizedBox(height: 12),
                          allowanceRow(colors, fonts, 'Economy', '20 kg'),
                          const SizedBox(height: 6),
                          allowanceRow(colors, fonts, 'Business', '40 kg'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Clickable GitHub URL
              Card(
                child: ListTile(
                  key: const Key('githubLink'),
                  leading: Icon(Icons.code_rounded, color: colors.primary),
                  title: const Text(
                    'Source code on GitHub',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    AppInfo.githubUrl,
                    style: TextStyle(
                      color: colors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: colors.primary,
                    ),
                  ),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  onTap: () => openGitHub(context),
                ),
              ),
              const SizedBox(height: 32),

              // Copyright notice
              Text(
                '© 2026 ${AppInfo.name}. All rights reserved.',
                textAlign: TextAlign.center,
                style: fonts.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionHeader(ColorScheme colors, TextTheme fonts, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Text(
        title,
        style: fonts.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme fonts = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppShape.block),
            ),
            child: Icon(icon, size: 20, color: colors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: fonts.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: fonts.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFeatures: kTabular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formulaBlock(
    ColorScheme colors,
    TextTheme fonts,
    List<String> lines,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppShape.block),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < lines.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
              child: Text(
                lines[i],
                style: fonts.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  fontFeatures: kTabular,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget allowanceRow(
    ColorScheme colors,
    TextTheme fonts,
    String ticketClass,
    String allowance,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$ticketClass free allowance',
            style: fonts.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ),
        Text(
          allowance,
          style: fonts.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontFeatures: kTabular,
          ),
        ),
      ],
    );
  }
}
