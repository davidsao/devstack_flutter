import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locale_keys.g.dart';

class UuidGeneratorPage
    extends BaseView<UuidGeneratorController, UuidGeneratorState> {
  const UuidGeneratorPage({super.key, super.viewTag});

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
            child: Obx(() {
              return Column(
                children: [
                  kGapTiny,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.lbl_uuid_generate.localize(),
                        style: AppTextStyles.b2.bold,
                      ),
                      SizedBox(
                        width: 152,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Slider(
                                value:
                                    controller.state.quantity.value.toDouble(),
                                min: 1,
                                max: 20,
                                divisions: 19,
                                label:
                                    controller.state.quantity.value.toString(),
                                padding: EdgeInsets.zero,
                                onChanged: (val) {
                                  controller.state.quantity.value = val.toInt();
                                  controller.generateUuids();
                                },
                              ),
                            ),
                            kGapSmaller,
                            SizedBox(
                              width: 20,
                              child: Text(
                                '${controller.state.quantity.value}',
                                style: AppTextStyles.b2.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  kGapTiny,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.lbl_uuid_hyphens.localize(),
                        style: AppTextStyles.b2.bold,
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: controller.state.hasHyphens.value,
                          onChanged: (v) {
                            controller.state.hasHyphens.value = v;
                            controller.generateUuids();
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.lbl_uuid_uppercase.localize(),
                        style: AppTextStyles.b2.bold,
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: controller.state.isUpperCase.value,
                          onChanged: (v) {
                            controller.state.isUpperCase.value = v;
                            controller.generateUuids();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          // Output Area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('UUIDs',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              AppButton(
                controller.generateUuids,
                leading: const Icon(Icons.refresh),
                style: AppButtonStyle.primary(
                  size: AppButtonStyleSize.small,
                ),
                child: Text(LocaleKeys.btn_regenerate.localize()),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: CustomTextField(
              controller: controller.outputController,
              maxLines: null,
              isMonoSpace: true,
              isEditable: false,
            ),
          ),
        ],
      ),
    );
  }
}
