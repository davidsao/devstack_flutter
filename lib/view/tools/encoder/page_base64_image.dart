import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/icon_keys.g.dart';
import '../../../generated/locale_keys.g.dart';

class Base64ImagePage
    extends BaseView<Base64ImageController, Base64ImageState> {
  const Base64ImagePage({super.key, super.viewTag});

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.lbl_base64_operation.localize(),
                      style: AppTextStyles.b2.bold),
                  CustomSlidingSegmentedControl<bool>(
                    height: 32,
                    duration: const Duration(seconds: 1),
                    curve: const ElasticOutCurve(0.9),
                    padding: 0.0,
                    innerPadding: const EdgeInsets.all(AppDimens.paddingText),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.2,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(20),
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
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMedium),
                    ),
                    thumbDecoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusSmall),
                    ),
                    initialValue: state.isEncode.value,
                    children: {
                      true: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingSmaller),
                        child: Text(
                          LocaleKeys.lbl_base64_encode.localize(),
                          style: AppTextStyles.b2.semiBold,
                        ),
                      ),
                      false: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingSmaller),
                        child: Text(
                          LocaleKeys.lbl_base64_decode.localize(),
                          style: AppTextStyles.b2.semiBold,
                        ),
                      ),
                    },
                    onValueChanged: (bool val) => controller.setOperation(val),
                  ),
                ],
              ),
            );
          }),
          kGapSmall,
          Expanded(
            child: Obx(() {
              if (state.isEncode.value) {
                return _buildCard(context,
                    title: LocaleKeys.lbl_base64_output.localize(),
                    expand: true,
                    child: CustomTextField(
                      key: const ValueKey('encode_output_field'),
                      controller: controller.outputController,
                      maxLines: null,
                      isEditable: false,
                      isMonoSpace: true,
                    ));
              } else {
                return _buildCard(
                  context,
                  title: LocaleKeys.lbl_base64_input.localize(),
                  expand: true,
                  child: CustomTextField(
                    key: const ValueKey('encode_input_field'),
                    controller: controller.inputController,
                    onChanged: controller.decodeBase64,
                    maxLines: null,
                    isEditable: true,
                    isMonoSpace: true,
                  ),
                );
              }
            }),
          ),
        ],
        secondChildren: [
          Obx(() => state.isEncode.value
              ? _buildEncoderWorkspace(context)
              : _buildDecoderWorkspace(context)),
        ],
      ),
    );
  }

  // --- WORKSPACE: Image -> Base64 ---
  Widget _buildEncoderWorkspace(BuildContext context) {
    return Column(
      children: [
        _buildCard(
          context,
          title: LocaleKeys.lbl_base64_source_image.localize(),
          child: Column(
            children: [
              DropTarget(
                onDragDone: (detail) {
                  controller.handleDrop(detail, context);
                },
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kGapLarge,
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
                            size: AppDimens.iconLarge, color: Colors.grey),
                      ),
                      kGapSmall,
                      Text(
                        LocaleKeys.lbl_hash_drop_file.localize(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      kGapSmall,
                      ElevatedButton.icon(
                        onPressed: () => controller.pickImage(context),
                        icon: AppImage(
                          IconKeys.attach,
                          size: AppDimens.iconSmaller,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        label: Text(
                          LocaleKeys.btn_browse_file.localize(),
                        ),
                      ),
                      kGapMedium,
                    ],
                  ),
                ),
              ),
              if (state.imageBytes.value != null) ...[
                kGapMedium,
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(state.imageBytes.value!,
                        fit: BoxFit.contain),
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  // --- WORKSPACE: Base64 -> Image ---
  Widget _buildDecoderWorkspace(BuildContext context) {
    return Column(
      children: [
        _buildCard(
          context,
          title: LocaleKeys.lbl_base64_preview.localize(),
          child: Container(
            width: double.infinity,
            height: 260,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).dividerColor.withOpacity(0.02),
            ),
            child: state.imageBytes.value != null
                ? Image.memory(
                    state.imageBytes.value!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Text(
                      LocaleKeys.lbl_base64_fail.localize(),
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  )
                : Text(
                    LocaleKeys.lbl_base64_hint.localize(),
                    style: AppTextStyles.b3
                        .copyWith(color: Theme.of(context).disabledColor),
                  ),
          ),
        ),
      ],
    );
  }

  // --- BASE CARD WRAPPER COMPONENT ---
  Widget _buildCard(BuildContext context,
      {required String title, required Widget child, bool expand = false}) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        kGapSmall,
        Text(title, style: AppTextStyles.b2.bold),
        kGapSmaller,
        expand ? Expanded(child: child) : child,
        kGapMedium,
      ],
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
      // If expand is true, skip the scroll view entirely
      child: expand ? content : SingleChildScrollView(child: content),
    );
  }
}
