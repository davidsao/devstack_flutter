import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../generated/locale_keys.g.dart';

class LoremIpsumGeneratorPage
    extends BaseView<LoremIpsumGeneratorController, LoremIpsumGeneratorState> {
  const LoremIpsumGeneratorPage({super.key, super.viewTag});

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
          Text(
            LocaleKeys.lbl_number_configuration.localize(),
            style: AppTextStyles.b2.bold,
          ),
          kGapTiny,
          // Configuration Panel
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary.withAlpha(24),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingSmaller,
              vertical: AppDimens.paddingTiny,
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppDimens.paddingLarge,
              runSpacing: AppDimens.paddingSmaller,
              children: [
                Obx(() {
                  return DropDownWidget(
                    title: LocaleKeys.lbl_lorem_ipsum_type.localize(),
                    choices: state.choices,
                    selectedValue: state.type.value,
                    onSelected: (String val) {
                      state.type.value = val;
                      controller.generateText();
                    },
                    maxWidth: false,
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.lbl_lorem_ipsum_length.localize(),
                      style: AppTextStyles.b2.bold,
                    ),
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: TextField(
                        controller: controller.lengthController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        textAlign: TextAlign.center,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          counterText: "",
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: controller.updateLength,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          kGapMedium,
          // Output Area
          Text(
            LocaleKeys.lbl_lorem_ipsum_generated.localize(),
            style: AppTextStyles.b2.bold,
          ),
          kGapTiny,
          Expanded(
            child: CustomTextField(
              controller: controller.outputController,
              maxLines: null,
              isEditable: false,
              isMonoSpace: false,
            ),
          ),
        ],
      ),
    );
  }
}
