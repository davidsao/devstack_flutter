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
          style: AppTextStyles.b1.semiBold,
        ),
        kGapSmall,
        SizedBox(
          height: 92,
          child: CustomTextField(
            controller: textController,
            isMonoSpace: true,
            isJsonFormatted: false,
            isXMLFormatted: false,
            isEditable: true,
            maxLines: null,
            inputFormatters: formatters, // Pass the formatters down
            onChanged: onChanged,
          ),
        ),
        kGapText,
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
            'Configuration',
            style: AppTextStyles.b1.semiBold,
          ),
          kGapSmall,
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            ),
            child: Obx(
              () => SwitchListTile(
                title: const Text('Format number'),
                value: controller.state.formatNumber.value,
                onChanged: controller.toggleFormat,
                activeColor: Theme.of(context).colorScheme.primary,
                secondary: const Icon(Icons.text_format),
              ),
            ),
          ),
          kGapLarge,
          _buildFieldSection(
            'Hexadecimal',
            controller.hexController,
            [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F ]')),
              NumberFormatInputFormatter(16, controller.state.formatNumber),
            ],
            controller.onHexChanged,
          ),
          _buildFieldSection(
            'Decimal',
            controller.decController,
            [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
              NumberFormatInputFormatter(10, controller.state.formatNumber),
            ],
            controller.onDecChanged,
          ),
          _buildFieldSection(
            'Octal',
            controller.octController,
            [
              FilteringTextInputFormatter.allow(RegExp(r'[0-7 ]')),
              NumberFormatInputFormatter(8, controller.state.formatNumber),
            ],
            controller.onOctChanged,
          ),
          _buildFieldSection(
            'Binary',
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
