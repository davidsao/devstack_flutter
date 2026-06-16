import 'dart:io';
import 'dart:ui' as ui;

import 'package:cross_file/cross_file.dart';
import 'package:devstack/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../generated/locale_keys.g.dart';

class QrGeneratorState extends ViewState {
  final correctionLevel = QrErrorCorrectLevel.H.obs;
  final qrData = 'Hello World'.obs;
}

class QrGeneratorController extends BaseController<QrGeneratorState> {
  final inputController = TextEditingController(text: 'Hello World');

  @override
  QrGeneratorState initState() => QrGeneratorState();

  @override
  void onInit() {
    super.onInit();
    // Update the QR code instantly as the user types
    inputController.addListener(() {
      state.qrData.value = inputController.text;
    });
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  // --- ACTIONS ---

  void updateCorrectionLevel(String level) {
    switch (level) {
      case 'Low':
        state.correctionLevel.value = QrErrorCorrectLevel.L;
        break;
      case 'Medium':
        state.correctionLevel.value = QrErrorCorrectLevel.M;
        break;
      case 'Quartile':
        state.correctionLevel.value = QrErrorCorrectLevel.Q;
        break;
      case 'High':
        state.correctionLevel.value = QrErrorCorrectLevel.H;
        break;
    }
  }

  String get currentCorrectionLevel {
    switch (state.correctionLevel.value) {
      case QrErrorCorrectLevel.L:
        return 'Low';
      case QrErrorCorrectLevel.M:
        return 'Medium';
      case QrErrorCorrectLevel.Q:
        return 'Quartile';
      case QrErrorCorrectLevel.H:
        return 'High';
      default:
        return 'High';
    }
  }

  Future<void> pasteInput() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      inputController.text = data.text!;
    }
  }

  void clearInput() {
    inputController.clear();
  }

  // --- EXPORT ---

  Future<void> exportQrCode(BuildContext context) async {
    if (state.qrData.value.isEmpty) return;

    try {
      // 1. Paint the QR code to an off-screen canvas
      final painter = QrPainter(
        data: state.qrData.value,
        version: QrVersions.auto,
        errorCorrectionLevel: state.correctionLevel.value,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF), // White background
      );

      // 2. Convert to PNG image data (High resolution: 1024x1024)
      final picData =
          await painter.toImageData(1024, format: ui.ImageByteFormat.png);
      if (picData == null) return;
      final bytes = picData.buffer.asUint8List();

      // 3. Save the file
      if (kIsWeb) {
        // On web, XFile translates saveTo() into a browser download prompt
        final xFile = XFile.fromData(
          bytes,
          name:
              'qrcode_${DateFormat('yyyy_MM_dd_hh_mm_ss').format(DateTime.now().toLocal())}.png',
          mimeType: 'image/png',
        );
        await xFile.saveTo(''); // The path argument is ignored on Web
        if (context.mounted == true) {
          SlidingAlert.show(
            context: context,
            text: LocaleKeys.lbl_qr_save_success_description.localize(),
            typeInfo: TypeInfo.success,
          );
        }
      } else {
        // Desktop / Mobile native save dialog
        String? outputFile = await FilePicker.saveFile(
          dialogTitle: LocaleKeys.lbl_qr_save_dialog_title.localize(),
          fileName:
              'qrcode_${DateFormat('yyyy_MM_dd_hh_mm_ss').format(DateTime.now().toLocal())}.png',
          type: FileType.image,
        );

        if (outputFile != null) {
          final file = File(outputFile);
          await file.writeAsBytes(bytes);
          if (context.mounted == true) {
            SlidingAlert.show(
              context: context,
              text: LocaleKeys.lbl_qr_save_success_description.localize(),
              typeInfo: TypeInfo.success,
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted == true) {
        SlidingAlert.show(
          context: context,
          text: LocaleKeys.lbl_qr_save_failed_description.localize(),
          typeInfo: TypeInfo.error,
        );
      }
    }
  }
}

class QrGeneratorBinding extends AppBindings<QrGeneratorController> {
  QrGeneratorBinding({required super.tag});
  @override
  get controller => QrGeneratorController();
}
