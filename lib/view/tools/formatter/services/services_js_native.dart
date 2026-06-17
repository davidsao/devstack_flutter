import 'package:devstack/view/tools/formatter/services/services_js_stub.dart';
import 'package:flutter_js/flutter_js.dart';

class NativeJsService implements JsService {
  late JavascriptRuntime flutterJs;

  NativeJsService() {
    // Initialize the native flutter_js engine
    flutterJs = getJavascriptRuntime();
  }

  @override
  String evaluate(String code) {
    try {
      final jsResult = flutterJs.evaluate(code);
      return jsResult.stringResult;
    } catch (e) {
      return "Error: $e";
    }
  }

  @override
  void dispose() {
    flutterJs.dispose();
  }
}

// Override the stub with the native implementation
JsService getJsService() => NativeJsService();
