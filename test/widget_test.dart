import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment/main.dart';

Future<void> fillAndCalculate(
    WidgetTester tester, String weight, String ticketClass, String rate) async {
  await tester.enterText(find.byKey(const Key('weightField')), weight);
  await tester.ensureVisible(find.byKey(Key('radio$ticketClass')));
  await tester.tap(find.byKey(Key('radio$ticketClass')));
  await tester.enterText(find.byKey(const Key('rateField')), rate);
  await tester.ensureVisible(find.byKey(const Key('btnCalculate')));
  await tester.tap(find.byKey(const Key('btnCalculate')));
  await tester.pumpAndSettle();
}

String textOf(WidgetTester tester, String key) =>
    tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  // The 4 sample calculations from the assignment question
  final samples = [
    ['25', 'Economy', '15', '5.00 kg', 'RM 75.00', 'RM 81.00'],
    ['18', 'Economy', '15', '0.00 kg', 'RM 0.00', 'RM 0.00'],
    ['55', 'Business', '12', '15.00 kg', 'RM 180.00', 'RM 194.40'],
    ['42.5', 'Business', '12', '2.50 kg', 'RM 30.00', 'RM 32.40'],
  ];

  for (final s in samples) {
    testWidgets('${s[0]} kg ${s[1]} @ RM${s[2]} -> ${s[5]}', (tester) async {
      await tester.pumpWidget(const MyApp());
      await fillAndCalculate(tester, s[0], s[1], s[2]);

      expect(textOf(tester, 'outExcessWeight'), s[3]);
      expect(textOf(tester, 'outExcessCharge'), s[4]);
      expect(textOf(tester, 'outTotal'), s[5]);
    });
  }

  testWidgets('shows an error when the weight is empty', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.byKey(const Key('btnCalculate')));
    await tester.tap(find.byKey(const Key('btnCalculate')));
    await tester.pumpAndSettle();

    expect(find.text('Please enter the baggage weight.'), findsWidgets);
    expect(find.byKey(const Key('resultCard')), findsNothing);
  });

  testWidgets('shows an error when no ticket class is selected',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byKey(const Key('weightField')), '25');
    await tester.ensureVisible(find.byKey(const Key('btnCalculate')));
    await tester.tap(find.byKey(const Key('btnCalculate')));
    await tester.pumpAndSettle();

    expect(find.text('Please select a ticket class.'), findsWidgets);
  });

  testWidgets('menu opens About page and goes back Home', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('menuAbout')));
    await tester.pumpAndSettle();

    expect(find.text('Author Information'), findsOneWidget);
    expect(find.text('NORSHUAIZAM BIN ABDUL SHUKOR'), findsOneWidget);
    expect(find.byKey(const Key('githubLink')), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('menuHome')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('btnCalculate')), findsOneWidget);
  });
}
