import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class SqlFormatterPage
    extends BaseView<SqlFormatterController, SqlFormatterState> {
  const SqlFormatterPage({super.key, super.viewTag});

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
          Expanded(
            child: ResponsiveSplitLayout(
              firstChildren: [
                Text(
                  'Input',
                  style: AppTextStyles.b2.bold,
                ),
                kGapTiny,
                Expanded(
                  child: CustomTextField(
                    controller: controller.inputController,
                    maxLines: null,
                    isMonoSpace: true,
                    onChanged: (_) => controller.format(),
                  ),
                ),
              ],
              secondChildren: [
                Text(
                  'Output',
                  style: AppTextStyles.b2.bold,
                ),
                kGapTiny,
                Expanded(
                  child: CustomTextField(
                    controller: controller.outputController,
                    maxLines: null,
                    isMonoSpace: true,
                    isEditable: false,
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
