import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

// =====================================================================
// [1] APP COLORS (Lab 5) - change the app colours here
// =====================================================================
class AppColors {
  static const Color colorPrimary = Color(0xFF0D3B66); // navy blue
  static const Color colorOnPrimary = Color(0xFFFFFFFF); // white text on navy
  static const Color colorSecondary = Color(0xFFF4A261); // orange (total box)
  static const Color colorOnSecondary = Color(0xFF1B1B1B); // dark text on orange
  static const Color colorBackground = Color(0xFFF4F6FA); // light grey screen
}

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
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.appTitle,
      debugShowCheckedModeBanner: false, // Lab 2
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.colorPrimary,
        ).copyWith(
          primary: AppColors.colorPrimary,
          onPrimary: AppColors.colorOnPrimary,
          secondary: AppColors.colorSecondary,
          onSecondary: AppColors.colorOnSecondary,
        ),
        scaffoldBackgroundColor: AppColors.colorBackground,

        // Title bar + status bar (Lab 5)
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.colorPrimary,
          foregroundColor: AppColors.colorOnPrimary,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.colorPrimary,
            statusBarIconBrightness: Brightness.light, // white icons (Android)
            statusBarBrightness: Brightness.dark, // white icons (iOS)
          ),
        ),

        // White cards with rounded corners
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Rounded, filled text fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.colorBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Big, rounded buttons (easy to tap)
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // SnackBar floats above the bottom of the screen
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// =====================================================================
// [4] NAVIGATION MENU (Drawer) - used by both Home and About pages
// =====================================================================
Widget buildMenu(BuildContext context, {required bool isHome}) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: AppColors.colorPrimary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/icon/icon.png', width: 56),
              ),
              const SizedBox(height: 12),
              const Text(
                AppInfo.appTitle,
                style: TextStyle(
                  color: AppColors.colorOnPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          key: const Key('menuHome'),
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          selected: isHome,
          onTap: () {
            Navigator.pop(context); // close the menu
            if (!isHome) {
              Navigator.pop(context); // go back to Home page
            }
          },
        ),
        ListTile(
          key: const Key('menuAbout'),
          leading: const Icon(Icons.info),
          title: const Text('About'),
          selected: !isHome,
          onTap: () {
            Navigator.pop(context); // close the menu
            if (isHome) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            }
          },
        ),
      ],
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

class _HomePageState extends State<HomePage> {
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

  @override
  void dispose() {
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
      showError(field: 'weight', text: 'Weight must be a number, e.g. 25 or 42.5.');
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
    showMessage('Form has been reset.', AppColors.colorPrimary);
  }

  // When the user types again, hide the old result and error
  void onInputChanged() {
    setState(() {
      showResult = false;
      weightError = null;
      rateError = null;
    });
  }

  // e.g. 194.4 -> "RM 194.40"
  String money(double value) => 'RM ${value.toStringAsFixed(2)}';

  // e.g. 42.5 -> "42.50"
  String twoDp(double value) => value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppInfo.appTitle)),
      drawer: buildMenu(context, isHome: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------------------------------------------------------
            // [9] HEADER BANNER
            // ---------------------------------------------------------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.flight_takeoff,
                      color: colors.onSecondary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overweight luggage?',
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Estimate your excess baggage fee before you fly.',
                          style: TextStyle(
                            color: colors.onPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---------------------------------------------------------
            // [10] INSTRUCTIONS
            // ---------------------------------------------------------
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: colors.secondary),
                        const SizedBox(width: 8),
                        const Text(
                          'How to use',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Enter your checked baggage weight (kg).\n'
                      '2. Choose your ticket class.\n'
                      '3. Enter the excess rate per kg (RM).\n'
                      '4. Tap CALCULATE. 8% service tax is included.',
                      style: TextStyle(height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---------------------------------------------------------
            // [11] INPUTS
            // ---------------------------------------------------------
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Baggage details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input 1: Baggage weight (TextField)
                    TextField(
                      key: const Key('weightField'),
                      controller: weightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) => onInputChanged(),
                      decoration: InputDecoration(
                        labelText: 'Baggage weight',
                        hintText: 'e.g. 25 or 42.5',
                        suffixText: 'kg',
                        prefixIcon: const Icon(Icons.luggage),
                        errorText: weightError,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input 2: Ticket class (RadioGroup - Lab 4)
                    const Text(
                      'Ticket class',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    RadioGroup<String>(
                      groupValue: selectedClass,
                      onChanged: (v) => setState(() {
                        selectedClass = v;
                        classError = null;
                        showResult = false;
                      }),
                      child: const Column(
                        children: [
                          RadioListTile<String>(
                            key: Key('radioEconomy'),
                            value: 'Economy',
                            title: Text('Economy'),
                            subtitle: Text('Free allowance: 20 kg'),
                          ),
                          RadioListTile<String>(
                            key: Key('radioBusiness'),
                            value: 'Business',
                            title: Text('Business'),
                            subtitle: Text('Free allowance: 40 kg'),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      classError ?? '',
                      style: TextStyle(color: colors.error, fontSize: 12),
                    ),
                    const SizedBox(height: 8),

                    // Input 3: Rate per kg (TextField)
                    TextField(
                      key: const Key('rateField'),
                      controller: rateController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) => onInputChanged(),
                      decoration: InputDecoration(
                        labelText: 'Excess rate per kg',
                        hintText: 'e.g. 15',
                        prefixText: 'RM ',
                        suffixText: '/ kg',
                        prefixIcon: const Icon(Icons.payments),
                        errorText: rateError,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // -------------------------------------------------
                    // [12] BUTTONS (Lab 3)
                    // -------------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            key: const Key('btnReset'),
                            onPressed: reset,
                            icon: const Icon(Icons.refresh),
                            label: const Text('RESET'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            key: const Key('btnCalculate'),
                            onPressed: calculate,
                            icon: const Icon(Icons.calculate),
                            label: const Text('CALCULATE'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // [13] RESULT - only shown after a successful calculation
            showResult ? buildResultCard(colors) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // [13] RESULT CARD (the 3 outputs)
  // -------------------------------------------------------------------
  Widget buildResultCard(ColorScheme colors) {
    final bool noExcess = excessWeight == 0;

    return Card(
      key: const Key('resultCard'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: colors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Result',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${twoDp(weight)} kg  •  $selectedClass  •  ${money(rate)} / kg',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 24),

            // Output 1
            resultRow(
              'Excess baggage weight',
              '${twoDp(excessWeight)} kg',
              noExcess
                  ? '${twoDp(weight)} - $allowance is not more than 0, so 0 kg'
                  : '${twoDp(weight)} - $allowance = ${twoDp(excessWeight)} kg',
              const Key('outExcessWeight'),
            ),
            // Output 2
            resultRow(
              'Excess baggage charge',
              money(excessCharge),
              '${twoDp(excessWeight)} kg x ${money(rate)}',
              const Key('outExcessCharge'),
            ),
            resultRow(
              'Service tax (8%)',
              money(serviceTax),
              '8% x ${money(excessCharge)}',
              const Key('outTax'),
            ),
            const SizedBox(height: 12),

            // Output 3: Total amount payable (highlighted)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total amount payable',
                      style: TextStyle(
                        color: colors.onSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    money(totalPayable),
                    key: const Key('outTotal'),
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Helpful notice
            Row(
              children: [
                Icon(
                  noExcess ? Icons.check_circle : Icons.info,
                  color: noExcess ? Colors.green : colors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    noExcess
                        ? 'Good news! Your baggage is within the $selectedClass '
                            'allowance of $allowance kg. Nothing to pay.'
                        : 'Your baggage is ${twoDp(excessWeight)} kg over the '
                            '$selectedClass allowance of $allowance kg.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget resultRow(String label, String value, String working, Key key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  working,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            value,
            key: key,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      drawer: buildMenu(context, isHome: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Application icon
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/icon/icon.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppInfo.appTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const Text(
              'Version ${AppInfo.version}',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Estimate the excess baggage fee for your flight based on '
              'baggage weight, ticket class and the airline rate per kg.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Author information
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      'Author Information',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  infoRow(Icons.person, 'Name', AppInfo.name),
                  infoRow(Icons.badge, 'Matric No', AppInfo.matricNo),
                  infoRow(Icons.school, 'Course', AppInfo.course),
                  infoRow(Icons.co_present, 'Lecturer', AppInfo.lecturer),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Clickable GitHub URL
            Card(
              child: ListTile(
                key: const Key('githubLink'),
                leading: const Icon(Icons.code),
                title: const Text('Source code on GitHub'),
                subtitle: Text(
                  AppInfo.githubUrl,
                  style: TextStyle(
                    color: colors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: colors.primary,
                  ),
                ),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => openGitHub(context),
              ),
            ),
            const SizedBox(height: 32),

            // Copyright notice
            const Text(
              '© 2026 ${AppInfo.name}. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.colorPrimary),
      title: Text(label),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
