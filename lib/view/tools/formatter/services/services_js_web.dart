import 'dart:js_interop';

import 'package:devstack/view/tools/formatter/services/services_js_stub.dart';

// Bind to the browser's native JavaScript eval() function
@JS('eval')
external JSAny? _browserEval(JSString code);

class WebJsService implements JsService {
  @override
  String evaluate(String code) {
    try {
      // Execute directly in the browser's JS engine
      final result = _browserEval(code.toJS);
      // Convert the result back to a Dart string
      return result?.isUndefinedOrNull == true ? "null" : result.toString();
    } catch (e) {
      return "Error: $e";
    }
  }

  @override
  void dispose() {
    // Web doesn't need manual memory disposal for the JS engine!
  }
}

// Override the stub with the web implementation
JsService getJsService() => WebJsService();
