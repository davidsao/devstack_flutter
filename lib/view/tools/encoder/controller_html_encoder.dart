import 'dart:convert';

import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class HtmlEncoderController extends BaseController<HtmlEncoderState> {
  final decodedController = TextEditingController();
  final encodedController = TextEditingController();

  @override
  HtmlEncoderState initState() => HtmlEncoderState();

  @override
  void onClose() {
    decodedController.dispose();
    encodedController.dispose();
    super.onClose();
  }

  String _unescapeHtml(String input) {
    return input
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
  }

  void onDecodedChanged(String value) {
    if (value.isEmpty) {
      encodedController.clear();
      return;
    }
    encodedController.text = const HtmlEscape().convert(value);
  }

  void onEncodedChanged(String value) {
    if (value.isEmpty) {
      decodedController.clear();
      return;
    }
    decodedController.text = _unescapeHtml(value);
  }
}

class HtmlEncoderState extends ViewState {}

class HtmlEncoderBinding extends AppBindings<HtmlEncoderController> {
  HtmlEncoderBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return HtmlEncoderController();
  }
}
