// 1. ALWAYS export the JsService interface so it is never lost during compile time
// 2. Conditionally swap out the getJsService() implementation based on platform
export 'services_js_stub.dart'
    if (dart.library.js_interop) 'services_js_web.dart'
    if (dart.library.io) 'services_js_native.dart';
export 'services_js_stub.dart' show JsService;
