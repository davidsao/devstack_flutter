import 'dart:math';

import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UuidGeneratorState extends ViewState {
  final hasHyphens = true.obs;
  final isUpperCase = false.obs;
  final quantity = 1.obs; // 1 to 20
}

class UuidGeneratorController extends BaseController<UuidGeneratorState> {
  final outputController = TextEditingController();

  @override
  UuidGeneratorState initState() => UuidGeneratorState();

  @override
  void onInit() {
    super.onInit();
    generateUuids();
  }

  @override
  void onClose() {
    outputController.dispose();
    super.onClose();
  }

  // Pure Dart UUIDv4 Generator
  String _generateUuidV4() {
    final random = Random();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0F) | 0x40; // Set version to 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // Set variant to 1

    final hexChars =
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).toList();
    final uuid =
        '${hexChars.sublist(0, 4).join()}-${hexChars.sublist(4, 6).join()}-${hexChars.sublist(6, 8).join()}-${hexChars.sublist(8, 10).join()}-${hexChars.sublist(10, 16).join()}';
    return uuid;
  }

  void generateUuids() {
    List<String> uuids = [];
    for (int i = 0; i < state.quantity.value; i++) {
      String id = _generateUuidV4();
      if (!state.hasHyphens.value) id = id.replaceAll('-', '');
      if (state.isUpperCase.value) id = id.toUpperCase();
      uuids.add(id);
    }
    outputController.text = uuids.join('\n');
  }
}

class UuidGeneratorBinding extends AppBindings<UuidGeneratorController> {
  UuidGeneratorBinding({required super.tag});
  @override
  get controller => UuidGeneratorController();
}
