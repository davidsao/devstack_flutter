import 'dart:io';

import 'package:devstack/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../../generated/locale_keys.g.dart';

class CodeToImageState extends ViewState {
  final inputText = ''.obs;
  final selectedLanguage = 'Auto detect'.obs;
  final detectedLanguage = 'dart'.obs;
  final selectedTheme = 'github-dark'.obs;
  final showWindowFrame = true.obs;
  final showLineNumbers = true.obs;

  // NEW: Pre-defined background selection
  final selectedBackground = 'Blue'.obs;
}

class CodeToImageController extends BaseController<CodeToImageState> {
  final TextEditingController inputController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();

  final Map<String, String> supportedLanguages = {
    'Auto detect': LocaleKeys.lbl_code2image_auto_detect.localize(),
    'dart': 'Dart',
    'javascript': 'Javascript',
    'typescript': 'Typescript',
    'python': 'Python',
    'cpp': 'C++',
    'c': 'C',
    'csharp': 'C#',
    'vbnet': 'VB.NET',
    'swift': 'Swift',
    'objectivec': 'Objective C',
    'json': 'JSON',
    'xml': 'XML',
    'html': 'HTML',
    'css': 'CSS',
    'yaml': 'Yaml',
    'sql': 'SQL',
    'php': 'PHP',
    'rust': 'Rust',
    'go': 'Go',
    'r': 'R',
    'dockerfile': 'Dockerfile',
    'kotlin': 'Kotlin',
    'java': 'Java',
  };

  final Map<String, String> supportedThemes = {
    'github-dark': 'github-dark',
    'github': 'github',
    'monokai': 'monokai',
    'dracula': 'dracula',
    'nord': 'nord',
    'ocean': 'ocean',
    'a11y-dark': 'a11y-dark',
  };

  // NEW: List of supported backgrounds for the dropdown
  final Map<String, String> supportedBackgrounds = {
    'Blue': LocaleKeys.lbl_code2image_blue.localize(),
    'Green': LocaleKeys.lbl_code2image_green.localize(),
    'Red': LocaleKeys.lbl_code2image_red.localize(),
    'Yellow': LocaleKeys.lbl_code2image_yellow.localize(),
    'Black': LocaleKeys.lbl_code2image_black.localize(),
    'White': LocaleKeys.lbl_code2image_white.localize(),
    'Pink': LocaleKeys.lbl_code2image_pink.localize(),
    'Brown': LocaleKeys.lbl_code2image_brown.localize(),
    'Grey': LocaleKeys.lbl_code2image_grey.localize(),
    'Transparent': LocaleKeys.lbl_code2image_transparent.localize(),
  };

  // NEW: Helper to get the actual color based on the selected string
  Color getBackgroundColor(String colorName) {
    switch (colorName) {
      case 'Blue':
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Red':
        return Colors.redAccent;
      case 'Yellow':
        return Colors.amber;
      case 'Black':
        return const Color(0xFF1E1E1E); // Slightly softer than pure black
      case 'White':
        return Colors.white;
      case 'Pink':
        return Colors.pinkAccent;
      case 'Brown':
        return Colors.brown;
      case 'Grey':
        return Colors.blueGrey;
      case 'Transparent':
        return Colors.transparent;
      default:
        return Colors.blue;
    }
  }

  @override
  CodeToImageState initState() => CodeToImageState();

  @override
  void onInit() {
    super.onInit();
    ever(state.selectedLanguage, (lang) {
      if (lang == 'Auto detect') {
        state.detectedLanguage.value =
            _autoDetectLanguage(state.inputText.value);
      } else {
        state.detectedLanguage.value = lang;
      }
    });
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  void updateCode(String text, BuildContext context) {
    final lines = text.split('\n');
    String newText = text;

    if (lines.length > 40) {
      newText = lines.take(40).join('\n');
      final selection = inputController.selection;
      inputController.text = newText;

      if (selection.baseOffset <= newText.length) {
        inputController.selection = selection;
      } else {
        inputController.selection =
            TextSelection.collapsed(offset: newText.length);
      }

      if (context.mounted == true) {
        SlidingAlert.show(
          context: context,
          text: LocaleKeys.lbl_code2image_limit_reached_description.localize(),
          typeInfo: TypeInfo.warning,
        );
      }
    }

    state.inputText.value = newText;

    if (state.selectedLanguage.value == 'Auto detect') {
      state.detectedLanguage.value = _autoDetectLanguage(newText);
    }
  }

  String _autoDetectLanguage(String code) {
    if (code.isEmpty) return 'dart';
    final lower = code.toLowerCase();

    if (lower.contains('<?php')) return 'php';
    if (lower.contains('<html') || lower.contains('</div>')) return 'html';
    if (code.contains('import \'package:') || code.contains('Widget build(')) {
      return 'dart';
    }
    if (code.contains('interface ') && code.contains('type ')) {
      return 'typescript';
    }
    if (code.contains('def ') && code.contains(':')) return 'python';
    if (code.contains('#include <iostream>')) return 'cpp';
    if (code.contains('#include')) return 'c';
    if (lower.contains('using system;')) return 'csharp';
    if (code.contains('package main') || code.contains('fmt.')) return 'go';
    if (code.contains('fn main()') || code.contains('println!')) return 'rust';
    if (lower.contains('select ') && lower.contains('from ')) return 'sql';
    if (code.contains('FROM ') && code.contains('RUN ')) return 'dockerfile';
    if (code.trim().startsWith('{') || code.trim().startsWith('[')) {
      return 'json';
    }
    if (code.contains('fun ') && code.contains('val ')) return 'kotlin';
    if (code.contains('public static void main')) return 'java';
    if (code.contains('import UIKit') || code.contains('let ')) return 'swift';
    if (code.contains('console.log') ||
        code.contains('const ') ||
        code.contains('let ')) {
      return 'javascript';
    }
    if (lower.contains('color:') ||
        lower.contains('margin:') ||
        lower.contains('padding:')) {
      return 'css';
    }

    return 'dart';
  }

  Future<void> exportImage(BuildContext context) async {
    if (state.inputText.value.isEmpty && context.mounted == true) {
      SlidingAlert.show(
        context: context,
        text: LocaleKeys.lbl_code2image_save_fail_empty_description.localize(),
        typeInfo: TypeInfo.error,
      );
      return;
    }

    try {
      final imageBytes = await screenshotController.capture(
        delay: const Duration(milliseconds: 100),
        pixelRatio: 3.0,
      );

      if (imageBytes != null) {
        String? outputFile = await FilePicker.saveFile(
          dialogTitle: LocaleKeys.lbl_code2image_save_dialog_title.localize(),
          fileName:
              'code_snippet_${DateFormat('yyyy_MM_dd_hh_mm_ss').format(DateTime.now().toLocal())}.png',
          type: FileType.image,
        );

        if (outputFile != null) {
          final file = File(outputFile);
          await file.writeAsBytes(imageBytes);
          if (context.mounted == true) {
            SlidingAlert.show(
              context: context,
              text:
                  LocaleKeys.lbl_code2image_save_success_description.localize(),
              typeInfo: TypeInfo.success,
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted == true) {
        SlidingAlert.show(
          context: context,
          text:
              LocaleKeys.lbl_code2image_save_fail_export_description.localize(),
          typeInfo: TypeInfo.error,
        );
      }
    }
  }
}

class CodeToImageBinding extends AppBindings<CodeToImageController> {
  CodeToImageBinding({required super.tag});

  @override
  get controller => CodeToImageController();
}
