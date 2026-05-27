import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class JsonYamlPage extends BaseView<JsonYamlController, JsonYamlState> {
  const JsonYamlPage({super.key, super.viewTag});

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
        children: [
          Expanded(
            child: ResponsiveSplitLayout(
              firstChildren: [
                Text(
                  'JSON',
                  style: AppTextStyles.b2.bold,
                ),
                kGapText,
                Expanded(
                  child: CustomTextField(
                    controller: controller.jsonController,
                    maxLines: null,
                    isMonoSpace: true,
                    isJsonFormatted: true, // Applies syntax highlighting
                    isXMLFormatted: false,
                    isEditable: true,
                    onChanged: controller.onJsonChanged,
                  ),
                ),
              ],
              secondChildren: [
                Text(
                  'YAML',
                  style: AppTextStyles.b2.bold,
                ),
                kGapText,
                Expanded(
                  child: CustomTextField(
                    controller: controller.yamlController,
                    maxLines: null,
                    isMonoSpace: true,
                    isJsonFormatted: false,
                    isXMLFormatted: false,
                    isYamlFormatted: true,
                    isEditable: true,
                    onChanged: controller.onYamlChanged,
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
