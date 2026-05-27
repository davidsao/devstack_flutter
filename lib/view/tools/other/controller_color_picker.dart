import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ColorPickerState extends ViewState {
  final currentColor = const Color(0xFF16E5CC).obs;
  final copyType = 'SwiftUI RGB Color'.obs;
}

class ColorPickerController extends BaseController<ColorPickerState> {
  @override
  ColorPickerState initState() => ColorPickerState();

  final List<String> copyTypes = [
    'Components',
    'iOS UIColor',
    'mac NSColor',
    'SwiftUI HSB Color',
    'SwiftUI RGB Color',
    'Android RGB',
    'Android HEX',
    'Android XML',
    'Web HEX',
    'Web RGB',
    'Web HSL',
  ];

  void updateColor(Color color) {
    state.currentColor.value = color;
  }

  void updateCopyType(String type) {
    state.copyType.value = type;
  }

  // --- HEX GENERATORS ---
  String get hexShort {
    final c = state.currentColor.value;
    return '#${c.red.toRadixString(16).padLeft(2, '0')[0]}'
            '${c.green.toRadixString(16).padLeft(2, '0')[0]}'
            '${c.blue.toRadixString(16).padLeft(2, '0')[0]}'
        .toUpperCase();
  }

  String get hexStandard {
    final c = state.currentColor.value;
    return '${c.red.toRadixString(16).padLeft(2, '0')}'
            '${c.green.toRadixString(16).padLeft(2, '0')}'
            '${c.blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  String get hexAlpha {
    final c = state.currentColor.value;
    return '${c.red.toRadixString(16).padLeft(2, '0')}'
            '${c.green.toRadixString(16).padLeft(2, '0')}'
            '${c.blue.toRadixString(16).padLeft(2, '0')}'
            '${c.alpha.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  // --- CMYK CALCULATOR ---
  List<int> get cmyk {
    final c = state.currentColor.value;
    double r = c.red / 255.0;
    double g = c.green / 255.0;
    double b = c.blue / 255.0;

    double k = 1.0 - [r, g, b].reduce((max, val) => max > val ? max : val);
    if (k == 1.0) return [0, 0, 0, 100]; // Black

    double cmykC = (1.0 - r - k) / (1.0 - k);
    double cmykM = (1.0 - g - k) / (1.0 - k);
    double cmykY = (1.0 - b - k) / (1.0 - k);

    return [
      (cmykC * 100).round(),
      (cmykM * 100).round(),
      (cmykY * 100).round(),
      (k * 100).round()
    ];
  }

  // --- CODE GENERATOR ---
  String getFormattedCopy() {
    final c = state.currentColor.value;
    final r = c.red;
    final g = c.green;
    final b = c.blue;
    final a = c.alpha;
    final rF = (r / 255.0).toStringAsFixed(2);
    final gF = (g / 255.0).toStringAsFixed(2);
    final bF = (b / 255.0).toStringAsFixed(2);
    final aF = (a / 255.0).toStringAsFixed(2);

    final hsv = HSVColor.fromColor(c);
    final h = hsv.hue.toStringAsFixed(1);
    final s = hsv.saturation.toStringAsFixed(2);
    final v = hsv.value.toStringAsFixed(2);

    switch (state.copyType.value) {
      case 'iOS UIColor':
        return '[UIColor colorWithRed:$rF green:$gF blue:$bF alpha:$aF]';
      case 'mac NSColor':
        return '[NSColor colorWithCalibratedRed:$rF green:$gF blue:$bF alpha:$aF]';
      case 'SwiftUI HSB Color':
        return 'Color(hue: $h, saturation: $s, brightness: $v, opacity: $aF)';
      case 'SwiftUI RGB Color':
        return 'Color(red: $rF, green: $gF, blue: $bF, opacity: $aF)';
      case 'Android RGB':
        return 'Color.argb($a, $r, $g, $b)';
      case 'Android HEX':
        return '0x${a.toRadixString(16).padLeft(2, '0')}$hexStandard'
            .toUpperCase();
      case 'Android XML':
        return '<color name="color_name">#${a.toRadixString(16).padLeft(2, '0')}$hexStandard</color>'
            .toUpperCase();
      case 'Web HEX':
        return '#$hexStandard';
      case 'Web RGB':
        return 'rgba($r, $g, $b, $aF)';
      case 'Web HSL':
        final hsl = HSLColor.fromColor(c);
        return 'hsla(${hsl.hue.round()}, ${(hsl.saturation * 100).round()}%, ${(hsl.lightness * 100).round()}%, $aF)';
      case 'Components':
      default:
        return 'R:$r G:$g B:$b A:$a';
    }
  }

  void copyFormatted() {
    Clipboard.setData(ClipboardData(text: getFormattedCopy()));
  }
}

class ColorPickerBinding extends AppBindings<ColorPickerController> {
  ColorPickerBinding({required super.tag});
  @override
  get controller => ColorPickerController();
}
