// =====================================================================
// Baggage Calculator - main.dart
// ICT602 Mobile Technology - Individual Assignment
// NORSHUAIZAM BIN ABDUL SHUKOR (2025229096)
//
// Starts the app. The code is split into 4 files in lib/:
//   main.dart       -> main() and MyApp
//   app_theme.dart  -> colours, author info, theme, app bar, card, menu
//   home_page.dart  -> the calculator page
//   about_page.dart -> the About page
// The parts are numbered [1] to [15], with the lab each one comes from.
// =====================================================================

import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

// =====================================================================
// [3] APP ROOT (Lab 2 and Lab 5) - the theme itself is in app_theme.dart
// =====================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.appTitle,
      debugShowCheckedModeBanner: false, // Lab 2
      theme: buildAppTheme(), // Lab 5
      home: const HomePage(),
    );
  }
}
