import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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