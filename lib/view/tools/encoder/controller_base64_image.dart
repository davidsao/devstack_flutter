import 'dart:convert';
import 'dart:typed_data';

import 'package:devstack/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Base64ImageController extends BaseController<Base64ImageState> {
  @override
  Base64ImageState initState() => Base64ImageState();

  // Switch between encoding and decoding modes
  void setOperation(bool isEncode) {
    state.isEncode.value = isEncode;
    clearAll();
  }

  // ENCODE: Browse device and parse selected file to Base64
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        withData: true, // Required for reading raw byte buffers directly
      );

      if (result != null && result.files.first.bytes != null) {
        Uint8List fileBytes = result.files.first.bytes!;
        state.imageBytes.value = fileBytes;

        String rawBase64 = base64Encode(fileBytes);
        String extension = result.files.first.extension ?? 'png';

        // Formats output string as a valid browser/render Data URI
        state.base64Output.value = "data:image/$extension;base64,$rawBase64";
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to process image file: $e");
    }
  }

  // DECODE: Monitors input and evaluates valid structural image data
  void decodeBase64(String input) {
    state.base64Input.value = input;
    if (input.trim().isEmpty) {
      state.imageBytes.value = null;
      return;
    }

    try {
      String cleanInput = input.trim();

      // Strip out Data-URI headers if present (e.g. data:image/png;base64,)
      if (cleanInput.contains(',')) {
        cleanInput = cleanInput.split(',').last;
      }

      // Erase any code breaks or whitespace formatting lines
      cleanInput = cleanInput.replaceAll(RegExp(r'\s+'), '');

      state.imageBytes.value = base64Decode(cleanInput);
    } catch (e) {
      state.imageBytes.value = null; // Faulty/Malformed string sequence
    }
  }

  void clearAll() {
    state.base64Input.value = '';
    state.base64Output.value = '';
    state.imageBytes.value = null;
  }
}

class Base64ImageState extends ViewState {
  final isEncode = true.obs;
  final base64Input = ''.obs;
  final base64Output = ''.obs;
  final imageBytes = Rxn<Uint8List>();
}
