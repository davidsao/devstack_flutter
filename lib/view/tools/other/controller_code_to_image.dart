import 'dart:io';

import 'package:devstack/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

class CodeToImageState extends ViewState {
  final inputText = ''.obs;
  final selectedLanguage = 'Auto detect'.obs; // Default dropdown value
  final detectedLanguage = 'dart'.obs; // The actual language rendered
  final selectedTheme = 'github-dark'.obs;
  final showWindowFrame = true.obs;
  final showLineNumbers = true.obs;

  // Background customization
  final backgroundType = 'gradient'.obs;
  final solidColor = const Color(0xFF8B5CF6).obs;
  final gradientColor1 = const Color(0xFF00C6FF).obs;
  final gradientColor2 = const Color(0xFF0072FF).obs;
}

class CodeToImageController extends BaseController<CodeToImageState> {
  final TextEditingController inputController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();

  final List<String> supportedLanguages = [
    'Auto detect', // NEW: Added to the top of the list
    'dart', 'javascript', 'typescript', 'python', 'cpp', 'c', 'csharp',
    'vbnet', 'swift', 'objectivec', 'json', 'xml', 'html', 'css',
    'yaml', 'sql', 'php', 'rust', 'go', 'r', 'dockerfile', 'kotlin', 'java'
  ];

  final List<String> supportedThemes = [
    'github-dark',
    'github',
    'monokai',
    'dracula',
    'nord',
    'ocean',
    'a11y-dark'
  ];

  @override
  CodeToImageState initState() => CodeToImageState();

  @override
  void onInit() {
    super.onInit();
    // Listen to manual dropdown changes
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

  void updateCode(String text) {
    final lines = text.split('\n');
    String newText = text;

    if (lines.length > 40) {
      // Cut off at exactly 40 lines
      newText = lines.take(40).join('\n');

      // Save current cursor position so typing isn't interrupted
      final selection = inputController.selection;

      inputController.text = newText;

      // Restore cursor position safely
      if (selection.baseOffset <= newText.length) {
        inputController.selection = selection;
      } else {
        inputController.selection =
            TextSelection.collapsed(offset: newText.length);
      }

      // Show warning message
      Get.snackbar(
        "Limit Reached",
        "Code snippets are restricted to at most 40 lines. Overflowing lines have been removed.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
    }

    state.inputText.value = newText;

    // Run the lightning-fast auto-detect if the user is in Auto mode
    if (state.selectedLanguage.value == 'Auto detect') {
      state.detectedLanguage.value = _autoDetectLanguage(newText);
    }
  }

  // --- NEW: Lightweight, blazing-fast heuristic engine ---
  String _autoDetectLanguage(String code) {
    if (code.isEmpty) return 'dart';

    final lower = code.toLowerCase();

    if (lower.contains('<?php')) return 'php';
    if (lower.contains('<html') || lower.contains('</div>')) return 'html';
    if (code.contains('import \'package:') || code.contains('Widget build('))
      return 'dart';
    if (code.contains('interface ') && code.contains('type '))
      return 'typescript';
    if (code.contains('def ') && code.contains(':')) return 'python';
    if (code.contains('#include <iostream>')) return 'cpp';
    if (code.contains('#include')) return 'c';
    if (lower.contains('using system;')) return 'csharp';
    if (code.contains('package main') || code.contains('fmt.')) return 'go';
    if (code.contains('fn main()') || code.contains('println!')) return 'rust';
    if (lower.contains('select ') && lower.contains('from ')) return 'sql';
    if (code.contains('FROM ') && code.contains('RUN ')) return 'dockerfile';
    if (code.trim().startsWith('{') || code.trim().startsWith('['))
      return 'json';
    if (code.contains('fun ') && code.contains('val ')) return 'kotlin';
    if (code.contains('public static void main')) return 'java';
    if (code.contains('import UIKit') || code.contains('let ')) return 'swift';
    if (code.contains('console.log') ||
        code.contains('const ') ||
        code.contains('let ')) return 'javascript';
    if (lower.contains('color:') ||
        lower.contains('margin:') ||
        lower.contains('padding:')) return 'css';

    return 'dart'; // Fallback
  }

  Future<void> exportImage() async {
    if (state.inputText.value.isEmpty) {
      Get.snackbar("Error", "Please enter some code first.");
      return;
    }

    try {
      final imageBytes = await screenshotController.capture(
        delay: const Duration(milliseconds: 100),
        pixelRatio: 3.0,
      );

      if (imageBytes != null) {
        String? outputFile = await FilePicker.saveFile(
          dialogTitle: 'Save Snippet Image',
          fileName: 'code_snippet.png',
          type: FileType.image,
        );

        if (outputFile != null) {
          final file = File(outputFile);
          await file.writeAsBytes(imageBytes);
          Get.snackbar("Success", "Image saved successfully!");
        }
      }
    } catch (e) {
      Get.snackbar("Export Failed", e.toString());
    }
  }
}
