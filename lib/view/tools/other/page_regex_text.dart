import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locale_keys.g.dart';

class RegexTesterPage
    extends BaseView<RegexTesterController, RegexTesterState> {
  const RegexTesterPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    final Map<String, String> choices = controller.predefinedRegexes.map(
      (key, value) => MapEntry(key, key),
    );

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
                title: LocaleKeys.lbl_regex_option.localize(),
                choices: choices,
                selectedValue: state.selectedOption.value,
                onSelected: controller.updateOption,
              ),
            );
          }),
          kGapSmall,

          // Regex Input
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.lbl_regex_title.localize(),
                  style: AppTextStyles.b2.bold),
              Obx(() => state.isRegexValid.value
                  ? const SizedBox.shrink()
                  : Text(LocaleKeys.lbl_regex_invalid.localize(),
                      style: AppTextStyles.b3.copyWith(color: Colors.red))),
            ],
          ),
          kGapTiny,

          SizedBox(
            height: 120,
            child: CustomTextField(
              controller: controller.regexInputController,
              isMonoSpace: true,
              maxLines: 1,
            ),
          ),
          kGapSmall,

          // Text Input
          Text(LocaleKeys.lbl_regex_text.localize(),
              style: AppTextStyles.b2.bold),
          kGapTiny,

          // FIX: Use a native TextField instead of CustomTextField (re_editor)
          // so the overridden buildTextSpan actually renders the highlights!
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor.withAlpha(10),
                ),
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                color: Colors.transparent,
                boxShadow: AppColors.textfieldShadow(context),
              ),
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controller.textInputController,
                maxLines: null,
                expands: true,
                style: AppTextStyles.monoStyle().copyWith(height: 1.5),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
