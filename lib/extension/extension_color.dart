import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color? fromHex(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) {
        buffer.write('ff');
      }
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } on FormatException catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  String get hexCode => '#${toInt32.toRadixString(16).substring(2, 8)}';

  static int floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  int get toInt32 {
    return floatToInt8(a) << 24 |
        floatToInt8(r) << 16 |
        floatToInt8(g) << 8 |
        floatToInt8(b) << 0;
  }
}
