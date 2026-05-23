import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locale_keys.g.dart';

class JsonFormatterPage
    extends BaseView<JsonFormatterController, JsonFormatterState> {
  const JsonFormatterPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    final Map<String, String> choices = {
      '  ': LocaleKeys.lbl_2_spaces.localize(),
      '    ': LocaleKeys.lbl_4_spaces.localize(),
      '\t': LocaleKeys.lbl_tabs.localize(),
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
          // Configuration Bar
          Text(
            LocaleKeys.lbl_number_configuration.localize(),
            style: AppTextStyles.b2.bold,
          ),
          kGapTiny,
          Obx(() {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary.withAlpha(24),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingSmaller,
                vertical: AppDimens.paddingTiny,
              ),
              child: DropDownWidget(
                title: LocaleKeys.lbl_indent.localize(),
                choices: choices,
                selectedValue: state.indentOption.value,
                onSelected: (String val) {
                  controller.updateIndent(val);
                },
              ),
            );
          }),
          kGapSmall,
          // Editors
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
                    isJsonFormatted: true,
                    isEditable: false,
                    showLineNumbers: true,
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
