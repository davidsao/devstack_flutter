import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locale_keys.g.dart';

class MinifierPage extends BaseView<MinifierController, MinifierState> {
  const MinifierPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    // Hardcoded choices for now, but you can move these to LocaleKeys later
    final Map<String, String> choices = {
      'JSON': 'JSON',
      'JavaScript': 'JavaScript',
      'XML': 'XML',
      'SQL': 'SQL',
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
          Text(LocaleKeys.lbl_number_configuration.localize(),
              style: AppTextStyles.b2.bold),
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
                title: LocaleKeys.lbl_minifier_language.localize(),
                choices: choices,
                selectedValue: state.languageOption.value,
                onSelected: controller.updateLanguage,
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
                    showLineNumbers: true, // Helpful for the unminified input
                  ),
                ),
              ],
              secondChildren: [
                Text(LocaleKeys.lbl_output.localize(),
                    style: AppTextStyles.b2.bold),
                kGapTiny,
                Expanded(
                  child: CustomTextField(
                    controller: controller.outputController,
                    maxLines: null,
                    isMonoSpace: true,
                    isEditable: false,
                    showLineNumbers: false,
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
