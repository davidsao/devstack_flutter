import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../generated/locale_keys.g.dart';

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
        top: AppDimens.paddingMedium,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CONFIGURATION ---
          _buildSectionTitle(LocaleKeys.lbl_number_configuration.localize()),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary.withAlpha(24),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingSmaller,
              vertical: AppDimens.paddingTiny,
            ),
            child: Obx(() {
              return DropDownWidget(
                title: 'Correction Level',
                choices: choices,
                selectedValue: controller.currentCorrectionLevel,
                onSelected: controller.updateCorrectionLevel,
              );
            }),
          ),
          kGapMedium,

          // --- INPUT ---
          _buildSectionTitle('Input'),
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
              AppButton(controller.exportQrCode,
                  style: AppButtonStyle.primary(size: AppButtonStyleSize.small),
                  child: Row(
                    children: [
                      Text('Export'),
                    ],
                  )),
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
      padding: const EdgeInsets.only(bottom: AppDimens.marginTiny),
      child: Text(title, style: AppTextStyles.b2.bold),
    );
  }
}
