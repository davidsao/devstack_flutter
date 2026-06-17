import 'dart:convert';

import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Ensure your new js_service.dart is exported in your index.dart,
// or import it directly here if needed!

class SqlFormatterController extends BaseController<SqlFormatterState> {
  final inputController = TextEditingController();
  final outputController = TextEditingController();

  // 1. Swap JavascriptRuntime for your new cross-platform JsService
  late JsService _jsRuntime;
  bool _isJsReady = false;

  @override
  SqlFormatterState initState() => SqlFormatterState();

  @override
  void onInit() {
    super.onInit();
    _initJsEngine();
  }

  Future<void> _initJsEngine() async {
    // 2. Initialize using the conditional routing function
    _jsRuntime = getJsService();

    try {
      // Polyfill browser globals. Headless JS engines don't have 'window'
      // by default, which the UMD library needs to attach its exports to.
      _jsRuntime.evaluate("var window = global = globalThis = this;");

      // Load the sql-formatter JS file from your assets
      final jsCode =
          await rootBundle.loadString('assets/js/sql-formatter.min.js');

      // Evaluate the library into the runtime.
      final result = _jsRuntime.evaluate(jsCode);

      // 3. Check for errors using the new String-based error handling
      if (result.startsWith('Error:')) {
        outputController.text = 'Failed to parse JS library:\n$result';
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

      // Inject the string into a JS variable
      _jsRuntime.evaluate("var currentSql = $safeSqlString;");

      // 4. Wrap execution in a JS try/catch to gracefully handle bad SQL syntax
      final jsEvalResult = _jsRuntime.evaluate("""
        try {
          sqlFormatter.format(currentSql, { 
            language: 'sql',           // Can be changed to 'postgresql', 'mysql', etc.
            keywordCase: 'upper',
            linesBetweenQueries: 2 
          });
        } catch (err) {
          "ERROR: " + err.message;
        }
      """);

      // 5. Handle the plain String results
      if (jsEvalResult.startsWith('Error:')) {
        outputController.text = 'JS Engine Error:\n$jsEvalResult';
      } else if (jsEvalResult.startsWith('ERROR: ')) {
        outputController.text =
            'Syntax Error:\n${jsEvalResult.replaceFirst('ERROR: ', '')}';
      } else {
        outputController.text = jsEvalResult;
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
