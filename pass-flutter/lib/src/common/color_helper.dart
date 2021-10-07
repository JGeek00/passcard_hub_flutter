import 'package:flutter/material.dart';

// ignore: public_member_api_docs
class ColorHelper {
  // ignore: public_member_api_docs
  static Color convertToColor(String rgbCssColor) {
    if (rgbCssColor.isEmpty) {
      return const Color.fromRGBO(255, 255, 255, 1);
    }
    
    final rgbaRegex = RegExp(r'rgb\((\d{1,3}),(\d{1,3}),(\d{1,3})\)');
    final hexRegex = RegExp(r'#.+');

    final isRgba = rgbaRegex.firstMatch(rgbCssColor);
    final isHex = hexRegex.firstMatch(rgbCssColor);

    if (isRgba != null) {
      final red = int.parse(isRgba.group(1)!);
      final green = int.parse(isRgba.group(2)!);
      final blue = int.parse(isRgba.group(3)!);

      return Color.fromRGBO(red, green, blue, 1);
    }
    else if (isHex != null) {
      Color hexToColor(String code) {
        return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
      }

      return hexToColor(rgbCssColor);
    }
    else {
      return const Color.fromRGBO(255, 255, 255, 1);
    }
  }

  // ignore: public_member_api_docs
  static String convertFromColor(Color? color) {
    if (color == null) return 'rgb(255,255,255)';
    return 'rgb(${color.red}, ${color.green}, ${color.blue})';
  }
}
