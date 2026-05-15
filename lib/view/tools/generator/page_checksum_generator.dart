import 'package:desktop_drop/desktop_drop.dart';
import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChecksumPage extends BaseView<ChecksumController, ChecksumState> {
  const ChecksumPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
        top: AppDimens.paddingSmall,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CONFIGURATION ---
            _buildSectionTitle('Configuration'),
            GlassContainer(
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('aA',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        SizedBox(width: 16),
                        Text('Uppercase',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Obx(() => Switch(
                          value: state.isUppercase.value,
                          onChanged: controller.toggleUppercase,
                        )),
                  ],
                ),
              ),
            ),
            kGapSmall,
            GlassContainer(
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.swap_horiz, color: Colors.grey),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hash Algorithm',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            Text('Select which algorithm you want to use',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    Obx(() => DropdownButtonHideUnderline(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: state.selectedAlgorithm.value,
                              items: controller.algorithms
                                  .map((a) => DropdownMenuItem(
                                      value: a, child: Text(a)))
                                  .toList(),
                              onChanged: (val) =>
                                  controller.changeAlgorithm(val!),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            kGapMedium,

            // --- FILE ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('File'),
                ElevatedButton.icon(
                  onPressed: controller.pickFile,
                  icon: const Icon(Icons.file_open, size: 16),
                  label: const Text('Open'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                  ),
                ),
              ],
            ),
            kGapTiny,
            DropTarget(
              onDragDone: controller.handleDrop,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Obx(() {
                  if (state.isProcessing.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 2), // Simulate dashed
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.move_to_inbox,
                            size: 32, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.currentFile.value != null
                            ? state.currentFile.value!.name
                            : 'Drop Files Here',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  );
                }),
              ),
            ),
            kGapMedium,

            // --- OUTPUT ---
            _buildSectionTitle('Output'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.outputController,
                    readOnly: true,
                    style: const TextStyle(fontFamily: 'monospace'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: controller.copyOutput,
                  icon: const Icon(Icons.copy),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                )
              ],
            ),
            kGapMedium,

            // --- OUTPUT COMPARER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('Output Comparer'),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.pasteComparer,
                      icon: const Icon(Icons.paste, size: 16),
                      label: const Text('Paste'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => controller.compareController.clear(),
                      icon: const Icon(Icons.clear, size: 16),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  ],
                ),
              ],
            ),
            kGapTiny,
            GetBuilder<ChecksumController>(
                id: 'comparer',
                builder: (ctrl) {
                  // Determine background color based on match
                  Color? bgColor = Theme.of(context).colorScheme.surfaceVariant;
                  Color borderColor = Colors.transparent;

                  final outText =
                      ctrl.outputController.text.trim().toLowerCase();
                  final compText =
                      ctrl.compareController.text.trim().toLowerCase();

                  if (compText.isNotEmpty &&
                      outText.isNotEmpty &&
                      outText != 'calculating...') {
                    if (outText == compText) {
                      bgColor = Colors.green.withOpacity(0.2);
                      borderColor = Colors.green;
                    } else {
                      bgColor = Colors.red.withOpacity(0.2);
                      borderColor = Colors.red;
                    }
                  }

                  return TextField(
                    controller: ctrl.compareController,
                    style: const TextStyle(fontFamily: 'monospace'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: bgColor,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}
