import 'package:flutter/material.dart';


const Color primaryColorLight = Colors.teal;
const Color primaryColorDark = Colors.tealAccent;
const String fontFamily = 'OpenSans';

ThemeData get lightTheme => ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  primaryColor: primaryColorLight,
  fontFamily: fontFamily,
   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(255, 255, 255, 1)
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: primaryColorLight
      ),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: const TextStyle(
      fontFamily: fontFamily,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5)
    ),
    elevation: 4,
  ),
);

ThemeData get darkTheme => ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  primaryColor: primaryColorDark,
  fontFamily: fontFamily,
  scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(30, 30, 30, 1)
  ),
  cardColor: const Color.fromRGBO(39, 39, 39, 1),
  dialogBackgroundColor: const Color.fromRGBO(44, 44, 44, 1),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: primaryColorDark
      ),
      primary: primaryColorDark,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(primary: primaryColorDark)
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: const TextStyle(
      fontFamily: fontFamily,
      color: Colors.black
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5)
    ),
    elevation: 4,
  )
);