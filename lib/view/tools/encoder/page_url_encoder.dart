import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class UrlEncoderPage extends BaseView<UrlEncoderController, UrlEncoderState> {
  const UrlEncoderPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
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
          kGapSmall,
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
    );
  }
}
