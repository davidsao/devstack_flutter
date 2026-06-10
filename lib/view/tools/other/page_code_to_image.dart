import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:get/get.dart';
import 'package:re_highlight/styles/all.dart';
import 'package:screenshot/screenshot.dart';

class CodeToImagePage
    extends BaseView<CodeToImageController, CodeToImageState> {
  const CodeToImagePage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
        top: AppDimens.paddingMedium,
        bottom: AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
      ),
      child: ResponsiveSplitLayout(
        firstFlex: 1,
        secondFlex: 1,
        secondChildrenScrollable: false,
        breakpoint: 900.0,
        firstChildren: [
          Expanded(child: _buildConfigPane(context)),
        ],
        secondChildren: [
          Expanded(child: _buildPreviewPane(context)),
        ],
      ),
    );
  }

  // ==========================================
  // LEFT PANE: CONFIGURATION & INPUT
  // ==========================================
  Widget _buildConfigPane(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Code Input", style: AppTextStyles.b2.bold),
        kGapSmall,
        Expanded(
          child: CustomTextField(
            controller: controller.inputController,
            onChanged: controller.updateCode,
            isEditable: true,
            maxLines: 50,
          ),
        ),
        kGapMedium,
        Text("Configuration", style: AppTextStyles.b2.bold),
        kGapSmall,
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
              _buildDropdownRow(
                "Language",
                controller.supportedLanguages,
                state.selectedLanguage,
              ),
              kGapTiny,
              _buildDropdownRow(
                "Code Theme",
                controller.supportedThemes,
                state.selectedTheme,
              ),
              kGapTiny,
              _buildDropdownRow(
                "Background",
                controller.supportedBackgrounds,
                state.selectedBackground,
              ),
              kGapText,
              Obx(() {
                return SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Show Window Controls",
                      style: AppTextStyles.b2.bold),
                  value: state.showWindowFrame.value,
                  onChanged: (v) => state.showWindowFrame.value = v,
                );
              }),
              Obx(() {
                return SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title:
                      Text("Show Line Numbers", style: AppTextStyles.b2.bold),
                  value: state.showLineNumbers.value,
                  onChanged: (v) => state.showLineNumbers.value = v,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownRow(
      String label, Map<String, String> options, RxString rxValue) {
    return DropDownWidget(
      title: label,
      choices: options,
      selectedValue: rxValue.value,
      onSelected: (String? newValue) {
        if (newValue != null) rxValue.value = newValue;
      },
    );
  }

  // ==========================================
  // RIGHT PANE: LIVE PREVIEW & EXPORT
  // ==========================================
  Widget _buildPreviewPane(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Image Preview", style: AppTextStyles.b2.bold),
            ElevatedButton.icon(
              onPressed: controller.exportImage,
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text("Export Image"),
            )
          ],
        ),
        kGapSmall,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            ),
            clipBehavior: Clip.hardEdge,
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.marginMedium),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Screenshot(
                      controller: controller.screenshotController,
                      child: Obx(() {
                        return Container(
                          constraints: const BoxConstraints(minWidth: 400),
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: controller.getBackgroundColor(
                                state.selectedBackground.value),
                          ),
                          alignment: Alignment.center,
                          child: _buildCodeWindow(context),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Builds the actual floating "macOS style" code window
  Widget _buildCodeWindow(BuildContext context) {
    final themeBg =
        builtinAllThemes[state.selectedTheme.value]?['root']?.backgroundColor ??
            const Color(0xFF282C34);

    final lineCount = state.inputText.value.isEmpty
        ? 1
        : state.inputText.value.split('\n').length;

    return Container(
      // REMOVED: width: double.infinity. We want it to shrink-wrap the intrinsic code size!
      decoration: BoxDecoration(
        color: themeBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // NEW: Shrink-wrap vertical height
        children: [
          // Optional Window Controls
          if (state.showWindowFrame.value)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMacBtn(const Color(0xFFFF5F56)),
                  const SizedBox(width: 8),
                  _buildMacBtn(const Color(0xFFFFBD2E)),
                  const SizedBox(width: 8),
                  _buildMacBtn(const Color(0xFF27C93F)),
                ],
              ),
            ),

          // The Syntax Highlighted Code
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
              top: state.showWindowFrame.value ? 0 : 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // NEW: Shrink-wrap horizontal width
              children: [
                if (state.showLineNumbers.value) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(lineCount, (index) {
                      return Text(
                        '${index + 1}',
                        style: AppTextStyles.monoStyle().copyWith(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.4),
                          height: 1.4,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 16),
                ],
                // REMOVED: Expanded. We don't want it forced to the screen boundaries anymore!
                HighlightView(
                  state.inputText.value.isEmpty
                      ? "// Type code on the left..."
                      : state.inputText.value,
                  language: state.detectedLanguage.value,
                  theme: builtinAllThemes[state.selectedTheme.value] ??
                      builtinAllThemes['github-dark']!,
                  padding: EdgeInsets.zero,
                  textStyle: AppTextStyles.monoStyle().copyWith(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacBtn(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
