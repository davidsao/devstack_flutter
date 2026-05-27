import 'dart:convert';

import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class Base64EncoderController extends BaseController<Base64EncoderState> {
  Base64EncoderController();

  final decodedController = TextEditingController();
  final encodedController = TextEditingController();

  @override
  Base64EncoderState initState() => Base64EncoderState();

  @override
  void onClose() {
    decodedController.dispose();
    encodedController.dispose();
    super.onClose();
  }

  void onDecodedChanged(String value) {
    if (value.isEmpty) {
      encodedController.clear();
      return;
    }
    try {
      final bytes = utf8.encode(value);
      encodedController.text = base64.encode(bytes);
    } catch (e) {
      encodedController.text = 'Error encoding to Base64';
    }
  }

  void onEncodedChanged(String value) {
    if (value.isEmpty) {
      decodedController.clear();
      return;
    }
    try {
      final bytes = base64.decode(value);
      decodedController.text = utf8.decode(bytes);
    } catch (e) {
      decodedController.text = 'Invalid Base64 input';
    }
  }
}

class Base64EncoderState extends ViewState {}

class Base64EncoderBinding extends AppBindings<Base64EncoderController> {
  Base64EncoderBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return Base64EncoderController();
  }
}
