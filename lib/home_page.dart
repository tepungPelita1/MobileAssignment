// =====================================================================
// Baggage Calculator - home_page.dart
// ICT602 Mobile Technology - Individual Assignment
// NORSHUAIZAM BIN ABDUL SHUKOR (2025229096)
//
// Parts [5] to [13]: the calculator page (inputs, formula, result).
// =====================================================================

import 'package:flutter/material.dart';

import 'app_theme.dart';

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

  // A name tag on the result card, so we can scroll to it after it appears.
  final GlobalKey resultAnchor = GlobalKey();

  @override
  void dispose() {
    // Lab 4: always dispose the controllers
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
    // [6] CHECK THE INPUTS (Lab 4, 4.4 + Lab 5: tryParse)
    // tryParse() returns null instead of throwing a FormatException,
    // so we check it with if and show a message.
    // -----------------------------------------------------------------
    final String weightText = weightController.text.trim();
    final String rateText = rateController.text.trim();
    final double? w = double.tryParse(weightText);
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
    //   X             = 20 kg (Economy) or 40 kg (Business)
    //   excess weight = weight - X        (0 if it would be negative)
    //   excess charge = excess weight * rate per kg
    //   total payable = excess charge + 8% service tax
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
      showResult = true; // show the result card
    });

    scrollToResult();
  }

  /// Scrolls down so the result card is visible.
  /// addPostFrameCallback waits until Flutter has finished drawing the
  /// new card, because before that the card does not exist yet and
  /// there is nothing to scroll to.
  void scrollToResult() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? anchor = resultAnchor.currentContext;
      if (anchor == null) return;
      Scrollable.ensureVisible(
        anchor,
        alignment: 0.06, // leave a little space above the card
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    });
  }

  // -------------------------------------------------------------------
  // [8] MESSAGES + RESET (Lab 3 and Lab 4)
  // -------------------------------------------------------------------
  void showError({required String field, required String text}) {
    setState(() {
      if (field == 'weight') weightError = text;
      if (field == 'class') classError = text;
      if (field == 'rate') rateError = text;
    });
    showMessage(text, Theme.of(context).colorScheme.error);
  }

  // SnackBar = the Flutter version of a Toast message (Lab 3, Lab 4)
  void showMessage(String text, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppShape.block),
          ),
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
    showMessage('Form has been reset.', Theme.of(context).colorScheme.primary);
  }

  // When the user types again, hide the old result and the old error
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

  // Removes the extra zeros, e.g. 25.00 -> "25" and 42.50 -> "42.5"
  String trim(double value) {
    String text = value.toStringAsFixed(2);
    while (text.endsWith('0')) {
      text = text.substring(0, text.length - 1);
    }
    if (text.endsWith('.')) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  /// The look of the two text fields.
  /// Lab 4 uses InputDecoration(labelText: ...) only. Here the fill
  /// colour and the rounded border are added so the field matches the
  /// cards.
  InputDecoration fieldStyle({
    required String label,
    required String hint,
    required IconData icon,
    String? prefix,
    String? suffix,
    String? error,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    OutlineInputBorder line(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppShape.block),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefix,
      suffixText: suffix,
      prefixIcon: Icon(icon),
      errorText: error,
      filled: true,
      fillColor: AppColors.colorBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      prefixIconColor: colors.onSurfaceVariant,
      labelStyle: TextStyle(color: colors.onSurfaceVariant),
      floatingLabelStyle: TextStyle(
        color: colors.primary,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: TextStyle(color: colors.onSurfaceVariant),
      prefixStyle: TextStyle(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      suffixStyle: TextStyle(
        color: colors.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
      border: line(colors.outline, 1),
      enabledBorder: line(colors.outline, 1),
      focusedBorder: line(colors.primary, 1.6),
      errorBorder: line(colors.error, 1),
      focusedErrorBorder: line(colors.error, 1.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme fonts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: buildAppBar(context, AppInfo.appTitle),
      drawer: buildMenu(
        context,
        isHome: true,
      ),
      // The Calculate button stays at the bottom so it is always visible.
      bottomNavigationBar: buildActionBar(colors),
      // Lab 4: SingleChildScrollView so the screen can scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // [9] HEADER BANNER
            buildHero(colors, fonts),
            const SizedBox(height: 16),

            // [10] INSTRUCTIONS
            buildHowToUse(colors, fonts),
            const SizedBox(height: 16),

            // [11] INPUTS
            buildInputs(colors, fonts),
            const SizedBox(height: 16),

            // [13] RESULT - shown only after a correct calculation.
            // Same ternary as Lab 4 (hobbies.isEmpty ? ... : ...)
            // KeyedSubtree just attaches resultAnchor so scrollToResult()
            // knows where to scroll.
            KeyedSubtree(
              key: resultAnchor,
              child:
                  showResult ? buildResultCard(colors, fonts) : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // [9] HEADER BANNER
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
              color: AppColors.colorPrimaryCircle,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.flight_takeoff_rounded,
              color: AppColors.colorSecondaryLight,
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
                    color: AppColors.colorOnPrimarySoft,
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
  // [10] HOW TO USE - instructions for the user
  // -------------------------------------------------------------------
  Widget buildHowToUse(ColorScheme colors, TextTheme fonts) {
    // One numbered step.
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
                color: AppColors.colorPrimarySoft,
                borderRadius: BorderRadius.circular(AppShape.chip),
              ),
              child: Text(
                '$number',
                style: fonts.labelMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
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

    return buildCard(
      context,
      Padding(
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
  // [11] INPUTS - 2 TextField + 1 RadioGroup (Lab 4, 4.2)
  // -------------------------------------------------------------------
  Widget buildInputs(ColorScheme colors, TextTheme fonts) {
    // One radio choice (Economy or Business).
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
          style: fonts.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        activeColor: colors.primary,
        tileColor: selected ? AppColors.colorPrimarySoft : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppShape.block),
          side: BorderSide(
            color: selected ? colors.primary : colors.outline,
            width: selected ? 1.6 : 1,
          ),
        ),
      );
    }

    return buildCard(
      context,
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Baggage details',
              style: fonts.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            // Input 1: Baggage weight
            TextField(
              key: const Key('weightField'),
              controller: weightController,
              // decimal: true so the keyboard has a "." for 42.5
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
              onChanged: (String value) => onInputChanged(),
              decoration: fieldStyle(
                label: 'Baggage weight',
                hint: 'e.g. 25 or 42.5',
                icon: Icons.luggage_rounded,
                suffix: 'kg',
                error: weightError,
              ),
            ),
            const SizedBox(height: 24),

            // Input 2: Ticket class (RadioGroup - Lab 4, 4.3.1)
            Text(
              'Ticket class',
              style: fonts.labelLarge?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
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
            // Error message under the radio buttons
            if (classError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  classError!,
                  style: fonts.bodySmall?.copyWith(color: colors.error),
                ),
              ),
            const SizedBox(height: 24),

            // Input 3: Rate per kg
            TextField(
              key: const Key('rateField'),
              controller: rateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
              onChanged: (String value) => onInputChanged(),
              decoration: fieldStyle(
                label: 'Excess rate per kg',
                hint: 'e.g. 15',
                icon: Icons.payments_rounded,
                prefix: 'RM ',
                suffix: '/ kg',
                error: rateError,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // [12] BUTTONS (Lab 3, 3.1.3) - the bar at the bottom
  // -------------------------------------------------------------------
  Widget buildActionBar(ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outline)),
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
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 54),
                    foregroundColor: colors.onSurface,
                    side: BorderSide(color: colors.outline),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.secondary, // teal accent
                    foregroundColor: colors.onSecondary,
                    minimumSize: const Size(0, 54),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
  // [13] RESULT CARD - the 4 outputs asked by the question
  // -------------------------------------------------------------------
  Widget buildResultCard(ColorScheme colors, TextTheme fonts) {
    final bool noExcess = excessWeight == 0;
    // Green when there is nothing to pay, orange when there is.
    final Color noticeColor = noExcess ? colors.tertiary : colors.primary;
    final Color noticeBackground =
        noExcess ? AppColors.colorSuccessSoft : const Color.fromARGB(255, 238, 163, 98);

    return buildCard(
      context,
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 20,
                  color: colors.primary,
                ),
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
            // A reminder of what the user typed in
            Text(
              '${trim(weight)} kg  ·  $selectedClass  ·  RM ${trim(rate)} / kg',
              style: fonts.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Output 1: excess baggage weight
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
            buildLine(context),
            // Output 2: excess baggage charge
            resultRow(
              colors,
              fonts,
              'Excess baggage charge',
              money(excessCharge),
              '${twoDp(excessWeight)} kg x ${money(rate)}',
              const Key('outExcessCharge'),
            ),
            buildLine(context),
            // Output 3: service tax
            resultRow(
              colors,
              fonts,
              'Service tax (8%)',
              money(serviceTax),
              '8% x ${money(excessCharge)}',
              const Key('outTax'),
            ),
            const SizedBox(height: 20),

            // Output 4: total amount payable (teal accent box)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: colors.secondary,
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
                            color: colors.onSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Includes 8% service tax',
                          style: fonts.bodySmall?.copyWith(
                            color: AppColors.colorOnSecondarySoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // FittedBox makes a very long number shrink instead of
                  // overflowing off the screen.
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        money(totalPayable),
                        key: const Key('outTotal'),
                        style: fonts.headlineSmall?.copyWith(
                          color: colors.onSecondary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // A helpful notice under the total
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: noticeBackground,
                borderRadius: BorderRadius.circular(AppShape.block),
              ),
              child: Row(
                children: [
                  Icon(
                    noExcess ? Icons.check_circle_rounded : Icons.info_rounded,
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

  /// One result line: the name on the left, the answer on the right, and
  /// the working under the name.
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
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            key: key,
            style: fonts.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
