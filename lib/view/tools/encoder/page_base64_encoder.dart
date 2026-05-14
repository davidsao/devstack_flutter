import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class Base64EncoderPage
    extends BaseView<Base64EncoderController, Base64EncoderState> {
  const Base64EncoderPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
        top: AppDimens.paddingSmall,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: Expanded(
        child: ResponsiveSplitLayout(
          firstChildren: [
            Text(
              'Decoded',
              style: AppTextStyles.b1.semiBold,
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
              'Encoded',
              style: AppTextStyles.b1.semiBold,
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
    );
  }
}
