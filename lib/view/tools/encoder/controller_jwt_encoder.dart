import 'dart:convert';

import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class JwtEncoderController extends BaseController<JwtEncoderState> {
  final encodedController = TextEditingController();
  final headerController = SyntaxHighlightingController(isJson: true);
  final payloadController = SyntaxHighlightingController(isJson: true);

  // Store the signature so we don't lose it when re-encoding from the JSON side
  String _currentSignature = '';

  @override
  JwtEncoderState initState() => JwtEncoderState();

  @override
  void onClose() {
    encodedController.dispose();
    headerController.dispose();
    payloadController.dispose();
    super.onClose();
  }

  // --- HELPER METHODS FOR JWT BASE64URL ---
  String _decodeBase64Url(String input) {
    // JWT base64url doesn't use padding, but Dart's decoder requires it to be normalized
    final normalized = base64Url.normalize(input);
    return utf8.decode(base64Url.decode(normalized));
  }

  String _encodeBase64Url(String input) {
    // Encode and strip the padding ('=') as per JWT spec
    return base64Url.encode(utf8.encode(input)).replaceAll('=', '');
  }

  String _prettyPrintJson(String input) {
    try {
      final object = jsonDecode(input);
      return const JsonEncoder.withIndent('  ').convert(object);
    } catch (e) {
      return input; // Fallback if it's not valid JSON
    }
  }

  // --- EVENT HANDLERS ---
  void onEncodedChanged(String jwt) {
    if (jwt.isEmpty) {
      headerController.clear();
      payloadController.clear();
      _currentSignature = '';
      return;
    }

    final parts = jwt.split('.');

    try {
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        final decodedHeader = _decodeBase64Url(parts[0]);
        headerController.text = _prettyPrintJson(decodedHeader);
      }
      if (parts.length > 1 && parts[1].isNotEmpty) {
        final decodedPayload = _decodeBase64Url(parts[1]);
        payloadController.text = _prettyPrintJson(decodedPayload);
      }
      // Save signature for later re-encoding
      _currentSignature = parts.length > 2 ? parts[2] : '';
    } catch (e) {
      // Allow the user to keep typing without throwing red errors to the UI
    }
  }

  void onDecodedChanged(String _) {
    final headerText = headerController.text;
    final payloadText = payloadController.text;

    if (headerText.isEmpty && payloadText.isEmpty) {
      encodedController.clear();
      return;
    }

    try {
      // We parse the JSON to ensure it's valid, and minify it (remove spaces) before encoding
      final headerMinified =
          headerText.isNotEmpty ? jsonEncode(jsonDecode(headerText)) : '{}';
      final payloadMinified =
          payloadText.isNotEmpty ? jsonEncode(jsonDecode(payloadText)) : '{}';

      final encodedHeader = _encodeBase64Url(headerMinified);
      final encodedPayload = _encodeBase64Url(payloadMinified);

      encodedController.text =
          '$encodedHeader.$encodedPayload.${_currentSignature}';
    } catch (e) {
      // Invalid JSON halfway through typing; do nothing until it's valid again
    }
  }
}

class JwtEncoderState extends ViewState {}

class JwtEncoderBinding extends AppBindings<JwtEncoderController> {
  JwtEncoderBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return JwtEncoderController();
  }
}
