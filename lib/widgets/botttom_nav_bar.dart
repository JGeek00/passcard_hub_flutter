import 'package:flutter/material.dart';

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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_activity),
          label: "Pases"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Ajustes"
        )
      ]
    );
  }
}