import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class JwtEncoderPage extends BaseView<JwtEncoderController, JwtEncoderState> {
  const JwtEncoderPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
        top: AppDimens.paddingSmall + MediaQuery.paddingOf(context).top,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDE: Encoded JWT String
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Encoded JWT',
                  style: AppTextStyles.b1.semiBold,
                ),
                kGapText,
                Expanded(
                  child: CustomTextField(
                    controller: controller.encodedController,
                    maxLines: null,
                    isMonoSpace: true, // JWTs are best viewed in monospace
                    isJsonFormatted: false,
                    isXMLFormatted: false,
                    isEditable: true,
                    onChanged: controller.onEncodedChanged,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // RIGHT SIDE: Decoded JSON Parts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Decoded Header (JSON)',
                  style: AppTextStyles.b1.semiBold,
                ),
                kGapText,
                Expanded(
                  flex: 1, // Header usually takes less space
                  child: CustomTextField(
                    controller: controller.headerController,
                    maxLines: null,
                    isMonoSpace: true,
                    isJsonFormatted: true, // Turns on JSON syntax highlighting
                    isXMLFormatted: false,
                    isEditable: true,
                    onChanged: controller.onDecodedChanged,
                  ),
                ),
                kGapSmall,
                Text(
                  'Decoded Payload (JSON)',
                  style: AppTextStyles.b1.semiBold,
                ),
                kGapText,
                Expanded(
                  flex: 2, // Payload usually has more data
                  child: CustomTextField(
                    controller: controller.payloadController,
                    maxLines: null,
                    isMonoSpace: true,
                    isJsonFormatted: true, // Turns on JSON syntax highlighting
                    isXMLFormatted: false,
                    isEditable: true,
                    onChanged: controller.onDecodedChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
