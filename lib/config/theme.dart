import 'package:flutter/material.dart';


const Color primaryColorLight = Colors.teal;
const Color primaryColorDark = Colors.tealAccent;
const String fontFamily = 'ProductSans';

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
  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(
      fontFamily: fontFamily,
    )
  )
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
  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(
      fontFamily: fontFamily,
    )
  )
);