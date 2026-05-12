import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class JsonYamlPage extends BaseView<JsonYamlController, JsonYamlState> {
  const JsonYamlPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
        top: AppDimens.paddingSmall,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDE: JSON String
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'JSON',
                  style: AppTextStyles.b1.semiBold,
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
            ),
          ),
          const SizedBox(width: 16),
          // RIGHT SIDE: YAML String
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YAML',
                  style: AppTextStyles.b1.semiBold,
                ),
                kGapText,
                Expanded(
                  child: CustomTextField(
                    controller: controller.yamlController,
                    maxLines: null,
                    isMonoSpace: true,
                    isJsonFormatted: false,
                    isXMLFormatted: false,
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
