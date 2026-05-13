import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoremIpsumGeneratorPage
    extends BaseView<LoremIpsumGeneratorController, LoremIpsumGeneratorState> {
  const LoremIpsumGeneratorPage({super.key, super.viewTag});

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
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            // FIX: Using Wrap for a responsive, side-by-side toolbar layout
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing:
                  AppDimens.paddingLarge, // Horizontal gap between components
              runSpacing: AppDimens
                  .paddingSmall, // Vertical gap if they wrap to the next line
              children: [
                Obx(() {
                  return DropDownWidget(
                    title: 'Type:',
                    choices: state.choices,
                    selectedValue: state.type.value,
                    onSelected: (String val) {
                      state.type.value = val;
                      controller.generateText();
                    },
                    // FIX: Set to false so it uses your fixed width (144) instead of taking up the whole screen
                    maxWidth: false,
                  );
                }),
                Row(
                  mainAxisSize: MainAxisSize
                      .min, // Keeps the row tight around its children
                  children: [
                    Text('Length (1-1000):', style: AppTextStyles.b2.bold),
                    kGapSmall,
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: TextField(
                        controller: controller.lengthController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: controller.updateLength,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          kGapMedium,
          // Output Area
          const Text(
            'Generated Lorem Ipsum',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          kGapTiny,
          Expanded(
            child: CustomTextField(
              controller: controller.outputController,
              maxLines: null,
              isEditable: false,
              isMonoSpace: false,
            ),
          ),
        ],
      ),
    );
  }
}
