import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/icon_keys.g.dart';
import '../../../generated/locale_keys.g.dart';

class TextInspectorPage
    extends BaseView<TextInspectorController, TextInspectorState> {
  const TextInspectorPage({super.key, super.viewTag});

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
          kGapTiny,
          _buildFormatChips(context),
          kGapMedium,

          // --- INPUT / OUTPUT SPLIT PANE ---
          Expanded(
            child: ResponsiveSplitLayout(
              firstFlex: 1,
              secondFlex: 1,
              secondChildrenScrollable: false,
              breakpoint: 800.0,
              firstChildren: [
                Expanded(child: _buildInputPane(context)),
              ],
              secondChildren: [
                Expanded(child: _buildOutputPane(context)),
              ],
            ),
          ),
          kGapMedium,
          _buildStatsCard(context),
        ],
      ),
    );
  }

  Widget _buildFormatChips(BuildContext context) {
    return Obx(() => Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: controller.caseOptions.map((caseType) {
            final isSelected = state.selectedCase.value == caseType;
            return ChoiceChip(
              label: Text(caseType),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (_) => controller.setCase(caseType),
              labelStyle: AppTextStyles.b3.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildInputPane(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingText,
            vertical: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(LocaleKeys.lbl_input.localize(),
                  style: AppTextStyles.b2.bold),
              InkWell(
                onTap: controller.clearText,
                child: AppImage(IconKeys.close, size: AppDimens.iconSmall),
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomTextField(
            controller: controller.inputController,
            onChanged: controller.updateText,
            isEditable: true,
          ),
        ),
      ],
    );
  }

  Widget _buildOutputPane(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimens.paddingText),
          child: Text(LocaleKeys.lbl_output.localize(),
              style: AppTextStyles.b2.bold),
        ),
        Expanded(
          child: CustomTextField(
            controller: controller.outputController,
            isEditable: false, // Prevents typing in the output box
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Obx(
      () => Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        runSpacing: AppDimens.paddingText,
        spacing: AppDimens.paddingText,
        children: [
          _buildStatRow(
            LocaleKeys.lbl_text_inspector_chars.localize(),
            state.charCount.value.toString(),
          ),
          _buildStatRow(
            LocaleKeys.lbl_text_inspector_words.localize(),
            state.wordCount.value.toString(),
          ),
          _buildStatRow(
            LocaleKeys.lbl_text_inspector_lines.localize(),
            state.lineCount.value.toString(),
          ),
          _buildStatRow(
            LocaleKeys.lbl_text_inspector_bytes.localize(),
            state.byteCount.value.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusSmaller),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.all(
        AppDimens.paddingTiny,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: AppTextStyles.b2.bold),
          ),
          SizedBox(
            width: 72,
            child: Text(
              value,
              style: AppTextStyles.monoStyle(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
