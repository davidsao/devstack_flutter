import 'package:devtoys_flutter/generated/locale_keys.g.dart';
import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NumberBasePage extends BaseView<NumberBaseController, NumberBaseState> {
  const NumberBasePage({super.key, super.viewTag});

  Widget _buildFieldSection(String label, TextEditingController textController,
      List<TextInputFormatter> formatters, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.b2.bold,
        ),
        kGapText,
        SizedBox(
          height: 88,
          child: CustomTextField(
            controller: textController,
            isMonoSpace: true,
            isJsonFormatted: false,
            isXMLFormatted: false,
            isEditable: true,
            isSearchable: false,
            maxLines: 1,
            inputFormatters: formatters, // Pass the formatters down
            onChanged: onChanged,
          ),
        ),
        kGapTiny,
      ],
    );
  }

  @override
  Widget view(BuildContext context) {
    return SingleChildScrollView(
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
          Obx(() {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
                color: state.formatNumber.value
                    ? Theme.of(context).colorScheme.primary.withAlpha(24)
                    : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingSmaller,
                vertical: AppDimens.paddingText,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.text_format,
                    size: AppDimens.iconSmaller,
                  ),
                  kGapTiny,
                  Expanded(
                    child: Text(
                      LocaleKeys.lbl_number_format_number.localize(),
                      style: AppTextStyles.b2.semiBold,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: state.formatNumber.value,
                      onChanged: controller.toggleFormat,
                    ),
                  ),
                ],
              ),
            );
          }),
          kGapSmall,
          _buildFieldSection(
            LocaleKeys.lbl_number_hexadecimal.localize(),
            controller.hexController,
            [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F ]')),
              NumberFormatInputFormatter(16, controller.state.formatNumber),
            ],
            controller.onHexChanged,
          ),
          _buildFieldSection(
            LocaleKeys.lbl_number_decimal.localize(),
            controller.decController,
            [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
              NumberFormatInputFormatter(10, controller.state.formatNumber),
            ],
            controller.onDecChanged,
          ),
          _buildFieldSection(
            LocaleKeys.lbl_number_octal.localize(),
            controller.octController,
            [
              FilteringTextInputFormatter.allow(RegExp(r'[0-7 ]')),
              NumberFormatInputFormatter(8, controller.state.formatNumber),
            ],
            controller.onOctChanged,
          ),
          _buildFieldSection(
            LocaleKeys.lbl_number_binary.localize(),
            controller.binController,
            [
              FilteringTextInputFormatter.allow(RegExp(r'[01 ]')),
              NumberFormatInputFormatter(2, controller.state.formatNumber),
            ],
            controller.onBinChanged,
          ),
        ],
      ),
    );
  }
}
