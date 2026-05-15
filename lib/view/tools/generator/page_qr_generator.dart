import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGeneratorPage
    extends BaseView<QrGeneratorController, QrGeneratorState> {
  const QrGeneratorPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    final Map<String, String> choices = {
      'Low': 'Low',
      'Medium': 'Medium',
      'Quartile': 'Quartile',
      'High': 'High',
    };

    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
        top: AppDimens.paddingSmall,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CONFIGURATION ---
          _buildSectionTitle('Configuration'),
          GlassContainer(
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(() {
                return DropDownWidget(
                  title: 'Correction Level',
                  choices: choices,
                  selectedValue: controller.currentCorrectionLevel,
                  onSelected: controller.updateCorrectionLevel,
                  maxWidth: true,
                );
              }),
            ),
          ),
          kGapMedium,

          // --- INPUT ---
          _buildSectionTitle('Input'),
          kGapText,
          Expanded(
            flex: 2,
            child: CustomTextField(
              controller: controller.inputController,
              maxLines: null,
              isMonoSpace: true,
            ),
          ),
          kGapMedium,

          // --- OUTPUT ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('QR Code'),
              ElevatedButton.icon(
                onPressed: controller.exportQrCode,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
            ],
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Obx(() {
                  if (state.qrData.value.isEmpty) {
                    return const Text('Enter text to generate QR code',
                        style: TextStyle(color: Colors.grey));
                  }

                  // Render the actual QR Code
                  return QrImageView(
                    data: state.qrData.value,
                    version: QrVersions.auto,
                    errorCorrectionLevel: state.correctionLevel.value,
                    backgroundColor: Colors.white,
                    size: 250.0, // Adjust size as needed
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}
