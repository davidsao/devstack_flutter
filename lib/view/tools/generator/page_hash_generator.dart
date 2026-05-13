import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HashGeneratorPage
    extends BaseView<HashGeneratorController, HashGeneratorState> {
  const HashGeneratorPage({super.key, super.viewTag});

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
          // LEFT: Input and Settings
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Input',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Obx(() => Row(
                          children: [
                            const Text('Uppercase'),
                            Switch(
                              value: controller.state.isUpperCase.value,
                              onChanged: controller.toggleCase,
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: CustomTextField(
                    controller: controller.inputController,
                    maxLines: null,
                    isEditable: true,
                    onChanged: (_) => controller.generateHashes(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // RIGHT: Outputs List
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Outputs',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: controller.algorithms.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final algo = controller.algorithms[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(algo,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 80, // Fixed height for each hash output
                            child: CustomTextField(
                              controller: controller.outputControllers[algo]!,
                              isMonoSpace: true,
                              isEditable: false,
                            ),
                          ),
                        ],
                      );
                    },
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
