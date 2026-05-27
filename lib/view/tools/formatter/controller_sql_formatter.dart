import 'dart:convert';

import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class SqlFormatterController extends BaseController<SqlFormatterState> {
  final inputController = TextEditingController();
  final outputController = TextEditingController();

  late JavascriptRuntime _jsRuntime;
  bool _isJsReady = false;

  @override
  SqlFormatterState initState() => SqlFormatterState();

  @override
  void onInit() {
    super.onInit();
    _initJsEngine();
  }

  Future<void> _initJsEngine() async {
    // 1. Initialize the JS runtime
    _jsRuntime = getJavascriptRuntime();

    try {
      // Polyfill browser globals. Headless JS engines don't have 'window'
      // by default, which the UMD library needs to attach its exports to.
      _jsRuntime.evaluate("var window = global = globalThis = this;");

      // 2. Load the sql-formatter JS file from your assets
      final jsCode =
          await rootBundle.loadString('assets/js/sql-formatter.min.js');

      // 3. Evaluate the library into the runtime.
      final result = _jsRuntime.evaluate(jsCode);

      // Optional safety check: ensure the library evaluated without syntax errors
      if (result.isError) {
        outputController.text =
            'Failed to parse JS library:\n${result.stringResult}';
        return;
      }

      _isJsReady = true;

      // Trigger an initial format if there's already text
      if (inputController.text.isNotEmpty) {
        format();
      }
    } catch (e) {
      outputController.text = 'Failed to load formatting engine:\n$e';
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    outputController.dispose();
    _jsRuntime.dispose();
    super.onClose();
  }

  void format() {
    final text = inputController.text;
    if (text.isEmpty) {
      outputController.clear();
      return;
    }

    if (!_isJsReady) {
      outputController.text = 'Loading formatting engine...';
      return;
    }

    try {
      // Safely escape the Dart string into a valid JS string using jsonEncode
      final safeSqlString = jsonEncode(text);

      // Inject the string into a JS variable, then run the formatter
      _jsRuntime.evaluate("var currentSql = $safeSqlString;");

      final jsEvalResult = _jsRuntime.evaluate("""
        sqlFormatter.format(currentSql, { 
          language: 'sql',           // Can be changed to 'postgresql', 'mysql', etc.
          keywordCase: 'upper',
          linesBetweenQueries: 2 
        });
      """);

      if (jsEvalResult.isError) {
        outputController.text =
            'Formatting Error:\n${jsEvalResult.stringResult}';
      } else {
        outputController.text = jsEvalResult.stringResult;
      }
    } catch (e) {
      outputController.text = 'Error executing formatter:\n$e';
    }
  }
}

class SqlFormatterState extends ViewState {}

class SqlFormatterBinding extends AppBindings<SqlFormatterController> {
  SqlFormatterBinding({required super.tag});

  @override
  get controller {
    return SqlFormatterController();
  }
}
