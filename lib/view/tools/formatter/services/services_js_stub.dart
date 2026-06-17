abstract class JsService {
  /// Evaluates the given JavaScript code and returns the string result.
  String evaluate(String code);

  /// Cleans up any native engine memory (No-op on Web).
  void dispose();
}

/// A stub method that gets overridden by conditional imports.
JsService getJsService() =>
    throw UnsupportedError('Cannot create a JS service for this platform');
