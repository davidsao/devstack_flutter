import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';

class HtmlEncoderPage
    extends BaseView<HtmlEncoderController, HtmlEncoderState> {
  const HtmlEncoderPage({super.key, super.viewTag});

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
                  LocaleKeys.lbl_decoded.localize(),
                  style: AppTextStyles.b2.semiBold,
                ),
                kGapText,
                Expanded(
                  child: CustomTextField(
                    controller: controller.decodedController,
                    maxLines: null,
                    onChanged: controller.onDecodedChanged,
                  ),
                ),
              ],
              secondChildren: [
                Text(
                  LocaleKeys.lbl_encoded.localize(),
                  style: AppTextStyles.b2.semiBold,
                ),
                kGapText,
                Expanded(
                  child: CustomTextField(
                    controller: controller.encodedController,
                    maxLines: null,
                    onChanged: controller.onEncodedChanged,
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
