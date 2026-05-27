import 'dart:convert';

import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:get/get.dart';

class MinifierState extends ViewState {
  final languageOption = 'JSON'.obs;
}

class MinifierController extends BaseController<MinifierState> {
  final inputController = TextEditingController();
  final outputController = TextEditingController();

  late JavascriptRuntime _jsRuntime;
  bool _isJsReady = false;

  @override
  MinifierState initState() => MinifierState();

  @override
  void onInit() {
    super.onInit();

    // 1. Initialize the headless JS engine for JavaScript minification
    _initJsEngine();

    // 2. Automatically minify whenever the input changes
    inputController.addListener(_minify);
  }

  Future<void> _initJsEngine() async {
    _jsRuntime = getJavascriptRuntime();

    try {
      // Polyfill browser globals for the UMD library
      _jsRuntime.evaluate("var window = global = globalThis = this;");

      // Load Terser from your assets
      final jsCode = await rootBundle.loadString('assets/js/terser.min.js');
      final result = _jsRuntime.evaluate(jsCode);

      if (result.isError) {
        outputController.text =
            'Failed to parse Terser JS library:\n${result.stringResult}';
        return;
      }

      _isJsReady = true;

      // Trigger an initial format if there's already text and JS is selected
      if (inputController.text.isNotEmpty &&
          state.languageOption.value == 'JavaScript') {
        _minify();
      }
    } catch (e) {
      outputController.text = 'Failed to load JS engine:\n$e';
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    outputController.dispose();
    _jsRuntime.dispose(); // Don't forget to dispose the engine!
    super.onClose();
  }

  void updateLanguage(String lang) {
    state.languageOption.value = lang;
    _minify();
  }

  void _minify() {
    final text = inputController.text;
    if (text.isEmpty) {
      outputController.clear();
      return;
    }

    try {
      if (state.languageOption.value == 'JSON') {
        final dynamic parsed = jsonDecode(text);
        outputController.text = jsonEncode(parsed);
      } else if (state.languageOption.value == 'XML') {
        outputController.text = text.replaceAll(RegExp(r'>\s+<'), '><').trim();
      } else if (state.languageOption.value == 'SQL') {
        outputController.text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
      } else if (state.languageOption.value == 'JavaScript') {
        _minifyJavaScript(text);
      }
    } catch (e) {
      outputController.text =
          'Error: Invalid ${state.languageOption.value} format.\n$e';
    }
  }

  void _minifyJavaScript(String text) {
    if (!_isJsReady) {
      outputController.text = 'Loading JavaScript minifier engine...';
      return;
    }

    try {
      // Safely escape the Dart string into a valid JS string using jsonEncode
      final safeJsString = jsonEncode(text);

      // Inject the string into a JS variable
      _jsRuntime.evaluate("var currentJs = $safeJsString;");

      // Run Terser.
      // Note: Terser exposes itself globally. We capture errors or the minified code.
      final jsEvalResult = _jsRuntime.evaluate("""
        try {
          var result = Terser.minify(currentJs);
          if (result.error) {
            "ERROR: " + result.error.message;
          } else {
            result.code;
          }
        } catch (err) {
          "ERROR: " + err.message;
        }
      """);

      if (jsEvalResult.isError) {
        outputController.text =
            'JS Engine Error:\n${jsEvalResult.stringResult}';
      } else {
        final resultStr = jsEvalResult.stringResult;
        if (resultStr.startsWith('ERROR: ')) {
          outputController.text =
              'Minification Error:\n${resultStr.replaceFirst('ERROR: ', '')}';
        } else {
          outputController.text =
              resultStr; // The beautiful, fully mangled code!
        }
      }
    } catch (e) {
      outputController.text = 'Error executing Terser:\n$e';
    }
  }
}

class MinifierBinding extends AppBindings<MinifierController> {
  MinifierBinding({required super.tag});

  @override
  get controller => MinifierController();
}
