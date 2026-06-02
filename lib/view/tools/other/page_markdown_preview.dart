import 'package:devstack/generated/icon_keys.g.dart';
import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../widget/text_field/widget_markdown_text_field.dart';

class MarkdownPreviewPage
    extends BaseView<MarkdownPreviewController, MarkdownPreviewState> {
  const MarkdownPreviewPage({super.key, super.viewTag});

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
        breakpoint: 800.0,

        // --- LEFT / TOP PANEL CONTENT ---
        firstChildren: [
          Expanded(
            child: _buildInputPane(context),
          ),
        ],
        secondChildren: [
          _buildConfigurationCard(context),
          Expanded(
            child: _buildPreviewPane(context),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.primary.withAlpha(24),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingSmaller,
        vertical: AppDimens.paddingTiny,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text("Preview Theme", style: AppTextStyles.b2.bold),
          ),
          Obx(() {
            return DropDownWidget(
              title: '', // No title needed here as it's inline
              choices: {
                'system': LocaleKeys.lbl_settings_theme_default.localize(),
                'light': LocaleKeys.lbl_settings_theme_light.localize(),
                'dark': LocaleKeys.lbl_settings_theme_dark.localize(),
              },
              selectedValue: state.previewTheme.value,
              onSelected: controller.updateTheme,
              maxWidth: false,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInputPane(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Editor", style: AppTextStyles.b2.bold),
            Row(
              children: [
                IconButton(
                  icon: AppImage(IconKeys.textfieldPaste, size: 16),
                  onPressed: controller.pasteText, // UPDATED
                ),
                IconButton(
                  icon: AppImage(IconKeys.close, size: 16),
                  onPressed: controller.clearText, // UPDATED
                ),
              ],
            )
          ],
        ),
        kGapText,
        Expanded(
          child: MarkdownEditorField(
            controller: controller.textController,
            onChanged: controller.updateMarkdown,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewPane(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Aligning the header with the left side
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text("Preview", style: AppTextStyles.b2.bold),
        ),
        Expanded(
          child: Obx(() {
            // Determine if the preview should be forced light or dark
            bool isDark = Theme.of(context).brightness == Brightness.dark;
            if (state.previewTheme.value == 'light') isDark = false;
            if (state.previewTheme.value == 'dark') isDark = true;

            // Optional: Create a custom MarkdownStyleSheet if you want specific fonts
            // Otherwise, it inherits nicely from the App's text themes

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              ),
              child: Theme(
                // Wrap the Markdown widget in a specific theme block so it forces
                // the typography colors to match the selected light/dark dropdown
                data: isDark ? ThemeData.dark() : ThemeData.light(),
                child: Markdown(
                  data: state.inputText.value.isEmpty
                      ? "### Nothing to preview\nStart typing on the left!"
                      : state.inputText.value,
                  selectable:
                      true, // Allows users to highlight and copy the rendered text
                  onTapLink: (text, href, title) async {
                    if (href != null) {
                      final url = Uri.parse(href);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    }
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
