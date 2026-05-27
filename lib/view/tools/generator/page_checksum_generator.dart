import 'package:desktop_drop/desktop_drop.dart';
import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/icon_keys.g.dart';
import '../../../generated/locale_keys.g.dart';

class ChecksumPage extends BaseView<ChecksumController, ChecksumState> {
  const ChecksumPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
        top: AppDimens.paddingMedium,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CONFIGURATION ---
            _buildSectionTitle('Configuration'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary.withAlpha(24),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingSmaller,
                vertical: AppDimens.paddingTiny,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Uppercase',
                        style: AppTextStyles.b2.bold,
                      ),
                      Obx(
                        () => Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: state.isUppercase.value,
                            onChanged: controller.toggleUppercase,
                          ),
                        ),
                      ),
                    ],
                  ),
                  kGapText,
                  Obx(() {
                    return DropDownWidget(
                      title: 'Hash Algorithm',
                      choices: controller.algorithms,
                      selectedValue: state.selectedAlgorithm.value,
                      onSelected: (String val) =>
                          controller.changeAlgorithm(val),
                    );
                  }),
                ],
              ),
            ),
            kGapMedium,

            // --- FILE ---
            _buildSectionTitle('File'),
            kGapTiny,
            DropTarget(
              onDragDone: controller.handleDrop,
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
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.paddingLarge,
                ),
                child: controller.state.isProcessing.value
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            controller.state.currentFile.value != null
                                ? controller.state.currentFile.value!.name
                                : LocaleKeys.lbl_hash_drop_file.localize(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          kGapSmall,
                          ElevatedButton.icon(
                            onPressed: controller.pickFile,
                            icon: AppImage(
                              IconKeys.attach,
                              size: AppDimens.iconSmaller,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            label: Text(
                              LocaleKeys.btn_browse_file.localize(),
                            ),
                          ),
                        ],
                      ),
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
