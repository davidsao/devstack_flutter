import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NumberBaseController extends BaseController<NumberBaseState> {
  final hexController = TextEditingController();
  final decController = TextEditingController();
  final octController = TextEditingController();
  final binController = TextEditingController();

  BigInt? _currentValue;

  @override
  NumberBaseState initState() => NumberBaseState();

  @override
  void onClose() {
    hexController.dispose();
    decController.dispose();
    octController.dispose();
    binController.dispose();
    super.onClose();
  }

  void toggleFormat(bool value) {
    state.formatNumber.value = value;
    _updateAllFieldsFromCurrentValue();
  }

  // --- PROGRAMMATIC FORMATTING LOGIC ---
  String _format(String rawValue, int radix) {
    if (!state.formatNumber.value || rawValue.isEmpty) return rawValue;

    if (radix == 10) {
      return rawValue.replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }

    int groupSize = (radix == 16 || radix == 2) ? 4 : 3;
    String reversed = rawValue.split('').reversed.join();
    Iterable<Match> matches = RegExp('.{1,$groupSize}').allMatches(reversed);
    String groupedReversed = matches.map((m) => m.group(0)).join(' ');

    return groupedReversed.split('').reversed.join().toUpperCase();
  }

  // --- CORE CONVERSION LOGIC ---
  void _processInput(String input, int sourceRadix) {
    String cleanInput = input.replaceAll(RegExp(r'[\s,]'), '');

    if (cleanInput.isEmpty) {
      _currentValue = null;
      _clearOtherFields(sourceRadix);
      return;
    }

    BigInt? parsedValue = BigInt.tryParse(cleanInput, radix: sourceRadix);

    if (parsedValue != null) {
      _currentValue = parsedValue;
      _updateOtherFields(sourceRadix);
    } else {
      _clearOtherFields(sourceRadix);
    }
  }

  void _updateOtherFields(int sourceRadix) {
    if (_currentValue == null) return;
    if (sourceRadix != 16)
      hexController.text = _format(_currentValue!.toRadixString(16), 16);
    if (sourceRadix != 10)
      decController.text = _format(_currentValue!.toRadixString(10), 10);
    if (sourceRadix != 8)
      octController.text = _format(_currentValue!.toRadixString(8), 8);
    if (sourceRadix != 2)
      binController.text = _format(_currentValue!.toRadixString(2), 2);
  }

  void _updateAllFieldsFromCurrentValue() {
    if (_currentValue == null) {
      _clearOtherFields(0);
      return;
    }
    hexController.text = _format(_currentValue!.toRadixString(16), 16);
    decController.text = _format(_currentValue!.toRadixString(10), 10);
    octController.text = _format(_currentValue!.toRadixString(8), 8);
    binController.text = _format(_currentValue!.toRadixString(2), 2);
  }

  void _clearOtherFields(int sourceRadix) {
    if (sourceRadix != 16) hexController.clear();
    if (sourceRadix != 10) decController.clear();
    if (sourceRadix != 8) octController.clear();
    if (sourceRadix != 2) binController.clear();
  }

  void onHexChanged(String val) => _processInput(val, 16);
  void onDecChanged(String val) => _processInput(val, 10);
  void onOctChanged(String val) => _processInput(val, 8);
  void onBinChanged(String val) => _processInput(val, 2);
}

// --- REAL-TIME INPUT FORMATTER ---
class NumberFormatInputFormatter extends TextInputFormatter {
  final int radix;
  final RxBool formatEnabled;

  NumberFormatInputFormatter(this.radix, this.formatEnabled);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!formatEnabled.value) return newValue;

    String text = newValue.text;

    // Fix native backspace behavior: If the user deletes a space/comma, delete the digit behind it instead.
    if (oldValue.text.length == newValue.text.length + 1) {
      int deletedOffset = oldValue.selection.baseOffset - 1;
      if (deletedOffset >= 0 && deletedOffset < oldValue.text.length) {
        String deletedChar = oldValue.text[deletedOffset];
        if (deletedChar == ' ' || deletedChar == ',') {
          if (deletedOffset > 0) {
            text = oldValue.text.substring(0, deletedOffset - 1) +
                oldValue.text.substring(deletedOffset + 1);
          }
        }
      }
    }

    String clean = text.replaceAll(RegExp(r'[\s,]'), '');
    if (clean.isEmpty) return TextEditingValue.empty;

    // Apply grouping
    String formatted;
    if (radix == 10) {
      formatted = clean.replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    } else {
      int groupSize = (radix == 16 || radix == 2) ? 4 : 3;
      String reversed = clean.split('').reversed.join();
      Iterable<Match> matches = RegExp('.{1,$groupSize}').allMatches(reversed);
      String groupedReversed = matches.map((m) => m.group(0)).join(' ');
      formatted = groupedReversed.split('').reversed.join().toUpperCase();
    }

    // Calculate intelligent cursor position based on non-formatting characters
    int cursorPosition =
        newValue.selection.end < 0 ? 0 : newValue.selection.end;
    int nonFormatCharsBeforeCursor = 0;
    for (int i = 0; i < cursorPosition && i < text.length; i++) {
      if (text[i] != ' ' && text[i] != ',') nonFormatCharsBeforeCursor++;
    }

    int newCursorPosition = 0;
    int count = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (count == nonFormatCharsBeforeCursor) {
        newCursorPosition = i;
        break;
      }
      if (formatted[i] != ' ' && formatted[i] != ',') count++;
    }
    if (count == nonFormatCharsBeforeCursor)
      newCursorPosition = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

class NumberBaseState extends ViewState {
  final formatNumber = true.obs;
}

class NumberBaseBinding extends AppBindings<NumberBaseController> {
  NumberBaseBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return NumberBaseController();
  }
}
