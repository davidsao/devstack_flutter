import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locale_keys.g.dart';

// --- CUSTOM HIGHLIGHT CONTROLLER ---
class RegexHighlightTextController extends TextEditingController {
  String pattern = '';

  void updatePattern(String newPattern) {
    pattern = newPattern;
    notifyListeners(); // Forces the text field to rebuild its spans
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    if (pattern.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    try {
      final regExp = RegExp(pattern, multiLine: true);
      final matches = regExp.allMatches(text);

      if (matches.isEmpty) {
        return TextSpan(text: text, style: style);
      }

      final spans = <TextSpan>[];
      int lastMatchEnd = 0;

      // Define the highlight color using the app's theme
      final highlightStyle = style?.copyWith(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      );

      for (final match in matches) {
        // Prevent infinite loops on zero-width matches (like ^ or $)
        if (match.start == match.end) continue;

        if (match.start > lastMatchEnd) {
          spans.add(TextSpan(
              text: text.substring(lastMatchEnd, match.start), style: style));
        }
        spans.add(TextSpan(
          text: text.substring(match.start, match.end),
          style: highlightStyle,
        ));
        lastMatchEnd = match.end;
      }

      if (lastMatchEnd < text.length) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
      }

      return TextSpan(children: spans);
    } catch (e) {
      // If the regex is invalid, return plain text
      return TextSpan(text: text, style: style);
    }
  }
}

// --- STATE ---
class RegexTesterState extends ViewState {
  final selectedOption = LocaleKeys.lbl_regex_option_custom.localize().obs;
  final isRegexValid = true.obs;
}

// --- MAIN CONTROLLER ---
class RegexTesterController extends BaseController<RegexTesterState> {
  final regexInputController = TextEditingController();
  final textInputController = RegexHighlightTextController();

  final Map<String, String> predefinedRegexes = {
    LocaleKeys.lbl_regex_option_custom.localize(): '',
    LocaleKeys.lbl_regex_option_email.localize():
        r'^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6})*$',
    LocaleKeys.lbl_regex_option_alphanumeric.localize(): r'^[a-zA-Z0-9]+$',
    LocaleKeys.lbl_regex_option_date.localize():
        r'^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])$',
    LocaleKeys.lbl_regex_option_time_12_hm.localize():
        r'^((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))$',
    LocaleKeys.lbl_regex_option_time_24_hm.localize():
        r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$',
    LocaleKeys.lbl_regex_option_time_24_hms.localize():
        r'^(?:[01]\d|2[0123]):(?:[012345]\d):(?:[012345]\d)$',
    LocaleKeys.lbl_regex_option_us_postal.localize(): r'^\d{5}([\-]?\d{4})?$',
  };

  @override
  RegexTesterState initState() => RegexTesterState();

  @override
  void onInit() {
    super.onInit();
    regexInputController.addListener(_onRegexInputChanged);
  }

  @override
  void onClose() {
    regexInputController.dispose();
    textInputController.dispose();
    super.onClose();
  }

  void updateOption(String option) {
    state.selectedOption.value = option;
    if (option != LocaleKeys.lbl_regex_option_custom.localize()) {
      regexInputController.text = predefinedRegexes[option] ?? '';
    }
  }

  void _onRegexInputChanged() {
    final currentText = regexInputController.text;

    // Automatically switch dropdown to "Custom" if the user manually edits the regex
    if (state.selectedOption.value !=
            LocaleKeys.lbl_regex_option_custom.localize() &&
        currentText != predefinedRegexes[state.selectedOption.value]) {
      state.selectedOption.value =
          LocaleKeys.lbl_regex_option_custom.localize();
    }

    try {
      if (currentText.isNotEmpty) {
        RegExp(currentText); // This throws an error if regex is invalid
      }
      state.isRegexValid.value = true;
      textInputController.updatePattern(currentText);
    } catch (e) {
      state.isRegexValid.value = false;
      textInputController.updatePattern(''); // Clear highlights on error
    }
  }
}

class RegexTesterBinding extends AppBindings<RegexTesterController> {
  RegexTesterBinding({required super.tag});

  @override
  get controller => RegexTesterController();
}
