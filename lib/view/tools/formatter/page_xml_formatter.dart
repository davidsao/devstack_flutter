import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class XmlFormatterPage
    extends BaseView<XmlFormatterController, XmlFormatterState> {
  const XmlFormatterPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    final Map<String, String> choices = {
      '  ': '2 spaces',
      '    ': '4 spaces',
      '\t': '1 tab',
    };

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
          // Configuration Bar
          Obx(() {
            return DropDownWidget(
              title: 'Indentation:',
              choices: choices,
              selectedValue: state.indentOption.value,
              onSelected: (String val) {
                controller.updateIndent(val);
              },
            );
          }),
          kGapSmall,
          // Editors
          Expanded(
            child: ResponsiveSplitLayout(
              firstChildren: [
                Text(
                  'Input',
                  style: AppTextStyles.b2.bold,
                ),
                kGapTiny,
                Expanded(
                  child: CustomTextField(
                    controller: controller.inputController,
                    maxLines: null,
                    isMonoSpace: true,
                    onChanged: (_) => controller.format(),
                  ),
                ),
              ],
              secondChildren: [
                Text(
                  'Output',
                  style: AppTextStyles.b2.bold,
                ),
                kGapTiny,
                Expanded(
                  child: CustomTextField(
                    controller: controller.outputController,
                    maxLines: null,
                    isMonoSpace: true,
                    isJsonFormatted: true,
                    isEditable: false,
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
