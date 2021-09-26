import 'package:flutter/material.dart';

ThemeData get lightTheme => ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal,
  fontFamily: 'ProductSans',
   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(255, 255, 255, 1)
  ),
);

ThemeData get darkTheme => ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  primaryColor: Colors.tealAccent,
  fontFamily: 'ProductSans',
  scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(30, 30, 30, 1)
  ),
  cardColor: const Color.fromRGBO(39, 39, 39, 1),
  dialogBackgroundColor: const Color.fromRGBO(44, 44, 44, 1),
);