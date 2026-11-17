// =====================================================================
// Baggage Calculator - about_page.dart
// ICT602 Mobile Technology - Individual Assignment
// NORSHUAIZAM BIN ABDUL SHUKOR (2025229096)
//
// Parts [14] and [15]: the About page and the GitHub link.
// =====================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_theme.dart';

// =====================================================================
// [14] ABOUT PAGE
// =====================================================================
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // -------------------------------------------------------------------
  // [15] Open the GitHub link in the browser - NOT from the labs.
  // The assignment question asks for a clickable URL, so the
  // url_launcher package was added the same way Lab 5 (5.4) added
  // flutter_launcher_icons.
  //   * async / await : opening the browser takes time, so we wait
  //   * context.mounted: make sure the page still exists after waiting
  // -------------------------------------------------------------------
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
      appBar: buildAppBar(context, 'About'),
      drawer: buildMenu(
        context,
        isHome: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          children: [
            // Application icon (Lab 2 step 6: Image.asset)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppShape.card),
                border: Border.all(color: colors.outline),
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
            buildCard(
              context,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Text(
                      'Author Information',
                      style: fonts.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  buildLine(context),
                  infoRow(context, Icons.person_rounded, 'Name', AppInfo.name),
                  buildLine(context),
                  infoRow(
                    context,
                    Icons.badge_rounded,
                    'Matric No',
                    AppInfo.matricNo,
                  ),
                  buildLine(context),
                  infoRow(
                    context,
                    Icons.school_rounded,
                    'Course',
                    AppInfo.course,
                  ),
                  buildLine(context),
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

            // Clickable GitHub URL
            buildCard(
              context,
              ListTile(
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
                // Lab 3 (3.2): onTap is the event handler
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
    );
  }

  /// One row of the author information: icon, label and value.
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
              color: AppColors.colorPrimarySoft,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
