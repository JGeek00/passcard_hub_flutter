import 'package:flutter/material.dart';

ThemeData get lightTheme => ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal,
  fontFamily: 'ProductSans',
);

ThemeData get darkTheme => ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  primaryColor: Colors.tealAccent,
  fontFamily: 'ProductSans',
);