import 'dart:convert';

import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextInspectorState extends ViewState {
  final selectedCase = 'OriginalCase'.obs;
  final charCount = 0.obs;
  final wordCount = 0.obs;
  final lineCount = 0.obs;
  final byteCount = 0.obs;
}

class TextInspectorController extends BaseController<TextInspectorState> {
  final TextEditingController inputController = TextEditingController();
  final TextEditingController outputController = TextEditingController();

  final List<String> caseOptions = [
    'OriginalCase',
    'Sentence case',
    'lower case',
    'UPPER CASE',
    'Title Case',
    'camelCase',
    'PascalCase',
    'snake_case',
    'CONSTANT_CASE',
    'kebab-case',
    'COBOL-CASE',
    'Train-Case',
    'URL-slugify',
    'url-lower-slugify'
  ];

  @override
  TextInspectorState initState() => TextInspectorState();

  @override
  void onClose() {
    inputController.dispose();
    outputController.dispose();
    super.onClose();
  }

  void updateText(String text) {
    _updateStats(text);
    _convertText();
  }

  void setCase(String caseType) {
    state.selectedCase.value = caseType;
    _convertText();
  }

  void clearText() {
    inputController.clear();
    updateText('');
  }

  void _updateStats(String text) {
    state.charCount.value = text.length;

    final wordChunks = text.split(RegExp(r'\s+'));
    state.wordCount.value = text.trim().isEmpty
        ? 0
        : wordChunks
            .where((chunk) => RegExp(r'[a-zA-Z0-9\u4e00-\u9fa5\u3040-\u30ff]')
                .hasMatch(chunk))
            .length;

    state.lineCount.value = text.isEmpty ? 0 : text.split('\n').length;
    state.byteCount.value = utf8.encode(text).length;
  }

  void _convertText() {
    final input = inputController.text;
    if (input.isEmpty) {
      outputController.text = '';
      return;
    }

    String capitalize(String s) =>
        s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}';

    // The Regex used to identify distinct word boundaries
    final wordRegex = RegExp(r'[A-Z]?[a-z]+|[A-Z]+(?=[A-Z][a-z]|\d|\W|$)|\d+');

    // NEW: A helper function to process formatting on a line-by-line basis
    String convertLine(String line) {
      if (line.trim().isEmpty) return line; // Preserve empty paragraph breaks

      final words = wordRegex.allMatches(line).map((m) => m.group(0)!).toList();
      if (words.isEmpty) return line;

      switch (state.selectedCase.value) {
        case 'OriginalCase':
          return line;
        case 'Sentence case':
          final lower = line.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        case 'lower case':
          return line.toLowerCase();
        case 'UPPER CASE':
          return line.toUpperCase();
        case 'Title Case':
          return words.map(capitalize).join(' ');
        case 'camelCase':
          return words.first.toLowerCase() +
              words.skip(1).map(capitalize).join('');
        case 'PascalCase':
          return words.map(capitalize).join('');
        case 'snake_case':
          return words.map((w) => w.toLowerCase()).join('_');
        case 'CONSTANT_CASE':
          return words.map((w) => w.toUpperCase()).join('_');
        case 'kebab-case':
          return words.map((w) => w.toLowerCase()).join('-');
        case 'COBOL-CASE':
          return words.map((w) => w.toUpperCase()).join('-');
        case 'Train-Case':
          return words.map(capitalize).join('-');
        case 'URL-slugify':
          return words.join('-');
        case 'url-lower-slugify':
          return words.map((w) => w.toLowerCase()).join('-');
        default:
          return line;
      }
    }

    // Process every line individually and join them back with newlines
    String output = input.split('\n').map(convertLine).join('\n');

    // Update the output UI only if the result has actually changed
    if (outputController.text != output) {
      outputController.text = output;
    }
  }
}

class TextInspectorBinding extends AppBindings<TextInspectorController> {
  TextInspectorBinding({required super.tag});

  @override
  get controller => TextInspectorController();
}
