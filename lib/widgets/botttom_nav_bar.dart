import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:passcard_hub/models/app_screen.dart';

class BottomNavBar extends StatelessWidget {
  final List<AppScreen> navBarScreens;
  final void Function(int) onTap;
  final int selectedScreen;

  const BottomNavBar({
    Key? key,
    required this.navBarScreens,
    required this.onTap,
    required this.selectedScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTap,
      currentIndex: selectedScreen,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.local_activity),
          label: AppLocalizations.of(context)!.passes
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label:  AppLocalizations.of(context)!.settings
        )
      ]
    );
  }
}