import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UuidGeneratorPage
    extends BaseView<UuidGeneratorController, UuidGeneratorState> {
  const UuidGeneratorPage({super.key, super.viewTag});

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
          // Configuration Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              return Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Slider(
                          value: controller.state.quantity.value.toDouble(),
                          min: 1,
                          max: 20,
                          divisions: 19,
                          label: controller.state.quantity.value.toString(),
                          padding: EdgeInsets.zero,
                          onChanged: (val) {
                            controller.state.quantity.value = val.toInt();
                            controller.generateUuids();
                          },
                        ),
                      ),
                      kGapTiny,
                      Text('${controller.state.quantity.value} ×'),
                      kGapTiny,
                      AppButton(
                        controller.generateUuids,
                        leading: const Icon(Icons.refresh),
                        style: AppButtonStyle.primary(
                          size: AppButtonStyleSize.small,
                        ),
                        child: const Text('Generate'),
                      )
                    ],
                  ),
                  kGapTiny,
                  Row(
                    children: [
                      Text(
                        'Hyphens',
                        style: AppTextStyles.b2.semiBold,
                      ),
                      Switch(
                        value: controller.state.hasHyphens.value,
                        onChanged: (v) {
                          controller.state.hasHyphens.value = v;
                          controller.generateUuids();
                        },
                      ),
                      kGapSmall,
                      Text(
                        'Uppercase',
                        style: AppTextStyles.b2.semiBold,
                      ),
                      Switch(
                        value: controller.state.isUpperCase.value,
                        onChanged: (v) {
                          controller.state.isUpperCase.value = v;
                          controller.generateUuids();
                        },
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          // Output Area
          const Text('Generated UUIDs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
