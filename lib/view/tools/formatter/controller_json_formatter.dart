import 'dart:convert';

import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JsonFormatterController extends BaseController<JsonFormatterState> {
  final inputController = TextEditingController();
  final outputController =
      SyntaxHighlightingController(isJson: true); // Uses our custom highlighter

  @override
  JsonFormatterState initState() => JsonFormatterState();

  @override
  void onClose() {
    inputController.dispose();
    outputController.dispose();
    super.onClose();
  }

  void updateIndent(String indent) {
    state.indentOption.value = indent;
    format();
  }

  void format() {
    final text = inputController.text;
    if (text.isEmpty) {
      outputController.clear();
      return;
    }
    try {
      final dynamic parsed = jsonDecode(text);
      final encoder = JsonEncoder.withIndent(state.indentOption.value);
      outputController.text = encoder.convert(parsed);
    } catch (e) {
      outputController.text = 'Invalid JSON:\n$e';
    }
  }
}

class JsonFormatterState extends ViewState {
  final indentOption = '  '.obs;
}

class JsonFormatterBinding extends AppBindings<JsonFormatterController> {
  JsonFormatterBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return JsonFormatterController();
  }
}
