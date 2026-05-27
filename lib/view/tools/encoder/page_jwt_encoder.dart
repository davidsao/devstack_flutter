import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';

class JwtEncoderPage extends BaseView<JwtEncoderController, JwtEncoderState> {
  const JwtEncoderPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
        top: AppDimens.paddingMedium,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        children: [
          Expanded(
            child: ResponsiveSplitLayout(
              firstChildren: [
                Text(
                  LocaleKeys.lbl_encoded_jwt.localize(),
                  style: AppTextStyles.b2.semiBold,
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
              secondChildren: [
                Text(
                  LocaleKeys.lbl_decoded_header.localize(),
                  style: AppTextStyles.b2.semiBold,
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
                  LocaleKeys.lbl_decoded_payload.localize(),
                  style: AppTextStyles.b2.semiBold,
                ),
                kGapText,
                Expanded(
                  flex: 1, // Payload usually has more data
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
