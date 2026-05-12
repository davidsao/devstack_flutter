import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class UrlEncoderController extends BaseController<UrlEncoderState> {
  final decodedController = TextEditingController();
  final encodedController = TextEditingController();

  @override
  UrlEncoderState initState() => UrlEncoderState();

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
    encodedController.text = Uri.encodeComponent(value);
  }

  void onEncodedChanged(String value) {
    if (value.isEmpty) {
      decodedController.clear();
      return;
    }
    try {
      decodedController.text = Uri.decodeComponent(value);
    } catch (e) {
      // Don't throw an error to the UI, just show it inline or do nothing if halfway typing
      decodedController.text = 'Invalid URL encoding';
    }
  }
}

class UrlEncoderState extends ViewState {}

class UrlEncoderBinding extends AppBindings<UrlEncoderController> {
  UrlEncoderBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return UrlEncoderController();
  }
}
