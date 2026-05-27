import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';

class SqlFormatterPage
    extends BaseView<SqlFormatterController, SqlFormatterState> {
  const SqlFormatterPage({super.key, super.viewTag});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ResponsiveSplitLayout(
              firstChildren: [
                Text(
                  LocaleKeys.lbl_input.localize(),
                  style: AppTextStyles.b2.bold,
                ),
                kGapTiny,
                Expanded(
                  child: CustomTextField(
                    controller: controller.inputController,
                    maxLines: null,
                    isMonoSpace: true,
                    isSqlFormatted: true,
                    onChanged: (_) => controller.format(),
                  ),
                ),
              ],
              secondChildren: [
                Text(
                  LocaleKeys.lbl_output.localize(),
                  style: AppTextStyles.b2.bold,
                ),
                kGapTiny,
                Expanded(
                  child: CustomTextField(
                    controller: controller.outputController,
                    maxLines: null,
                    isMonoSpace: true,
                    isEditable: false,
                    isSqlFormatted: true,
                    // No syntax highlighting needed for basic SQL right now
                    isJsonFormatted: false,
                    isXMLFormatted: false,
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
