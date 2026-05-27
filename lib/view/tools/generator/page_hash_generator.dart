import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/icon_keys.g.dart';
import '../../../generated/locale_keys.g.dart';

class HashGeneratorPage
    extends BaseView<HashGeneratorController, HashGeneratorState> {
  const HashGeneratorPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
        top: AppDimens.paddingMedium,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: ResponsiveSplitLayout(
        firstFlex: 1,
        secondFlex: 1,
        secondChildrenScrollable: true,
        breakpoint: 800.0,

        // --- LEFT / TOP PANEL CONTENT ---
        firstChildren: [
          _inputType,
          kGapTiny,
          Expanded(
            child: Obx(() {
              if (controller.state.isTextMode.value) {
                // TEXT MODE
                return CustomTextField(
                  controller: controller.inputController,
                  maxLines: null,
                  isEditable: true,
                  onChanged: controller.onTextChanged,
                );
              } else {
                // FILE MODE
                return DropTarget(
                  onDragDone: controller.handleDrop,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: controller.state.isProcessing.value
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: AppImage(IconKeys.upload,
                                    size: AppDimens.iconLarge,
                                    color: Colors.grey),
                              ),
                              kGapSmall,
                              Text(
                                controller.state.currentFile.value != null
                                    ? controller.state.currentFile.value!.name
                                    : LocaleKeys.lbl_hash_drop_file.localize(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                              kGapSmall,
                              ElevatedButton.icon(
                                onPressed: controller.pickFile,
                                icon: AppImage(
                                  IconKeys.attach,
                                  size: AppDimens.iconSmaller,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                label: Text(
                                  LocaleKeys.btn_browse_file.localize(),
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              }
            }),
          ),
        ],

        secondChildren: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
              color: Theme.of(context).colorScheme.primary.withAlpha(24),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingSmaller,
              vertical: AppDimens.paddingTiny,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.lbl_hash_uppercase.localize(),
                  style: AppTextStyles.b2.bold,
                ),
                Obx(
                  () => Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: controller.state.isUpperCase.value,
                      onChanged: controller.toggleCase,
                    ),
                  ),
                ),
              ],
            ),
          ),
          kGapSmaller,
          ...controller.algorithms.expand((algo) {
            return [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(algo, style: AppTextStyles.b2.bold),
                      Tooltip(
                        message: LocaleKeys.input_tooltip_copy.localize(),
                        child: InkWell(
                          onTap: () {
                            controller.copy(
                              controller.outputControllers[algo]!.value,
                              context,
                            );
                          },
                          child: AppImage(
                            IconKeys.textfieldCopy,
                            size: AppDimens.iconSmaller,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      )
                    ],
                  ),
                  kGapText,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.paddingTiny,
                      horizontal: AppDimens.paddingSmaller,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withAlpha(16),
                      ),
                    ),
                    child: Obx(() {
                      return SelectableText(
                        controller.outputControllers[algo]!.value,
                        style: AppTextStyles.monoStyle(
                          fontSize: 13,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ];
          }).toList()
            ..removeLast(),
        ],
      ),
    );
  }

  Widget get _inputType {
    return Row(
      children: [
        const Spacer(),
        Obx(() {
          return CustomSlidingSegmentedControl<bool>(
            height: 32,
            duration: const Duration(seconds: 1),
            curve: const ElasticOutCurve(0.9),
            padding: 0.0,
            innerPadding: const EdgeInsets.all(AppDimens.paddingText),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 0.2,
                  color: Theme.of(context).colorScheme.primary.withAlpha(20),
                  blurStyle: BlurStyle.inner,
                )
              ],
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withAlpha(60),
                  Theme.of(context).colorScheme.primary.withAlpha(35),
                  Theme.of(context).colorScheme.primary.withAlpha(40),
                  Theme.of(context).colorScheme.primary.withAlpha(50),
                ],
                stops: const [0.0, 0.45, 0.6, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            ),
            thumbDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
            ),
            initialValue: controller.state.isTextMode.value,
            children: {
              true: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingSmaller),
                child: Text(
                  LocaleKeys.tab_hash_text.localize(),
                  style: AppTextStyles.b2.semiBold,
                ),
              ),
              false: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingSmaller),
                child: Text(
                  LocaleKeys.tab_hash_file.localize(),
                  style: AppTextStyles.b2.semiBold,
                ),
              ),
            },
            onValueChanged: (bool val) => controller.setMode(val),
          );
        }),
        const Spacer(),
      ],
    );
  }
}
