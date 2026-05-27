import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../../../generated/icon_keys.g.dart';
import '../../../generated/locale_keys.g.dart';

class ColorPickerPage
    extends BaseView<ColorPickerController, ColorPickerState> {
  const ColorPickerPage({super.key, super.viewTag});

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          kGapSmall,
          // 1. INTERACTIVE COLOR PICKER
          LayoutBuilder(
            builder: (context, constraints) {
              // Determine the width: Use available space, but cap it at 600px
              final double pickerWidth =
                  constraints.maxWidth > 560 ? 560 : constraints.maxWidth;

              return SizedBox(
                width: pickerWidth,
                child: Obx(() {
                  return ColorPicker(
                    pickerColor: state.currentColor.value,
                    onColorChanged: controller.updateColor,
                    colorPickerWidth: pickerWidth,
                    pickerAreaHeightPercent: 0.5,
                    enableAlpha: true,
                    displayThumbColor: true,
                    paletteType: PaletteType.hsvWithHue,
                    pickerAreaBorderRadius: BorderRadius.circular(
                      AppDimens.radiusMedium,
                    ),
                    hexInputBar: false,
                    labelTypes: const [],
                    portraitOnly: true,
                  );
                }),
              );
            },
          ),

          // 2. HEX COLOR DISPLAYS
          Row(
            children: [
              Text(LocaleKeys.lbl_color_hex.localize(),
                  style: AppTextStyles.b2.bold),
              const Spacer(),
            ],
          ),
          kGapTiny,
          Obx(() {
            return Row(
              children: [
                _buildHexBox(context, controller.hexShort),
                kGapSmall,
                _buildHexBox(context, controller.hexStandard),
                kGapSmall,
                _buildHexBox(context, controller.hexAlpha),
              ],
            );
          }),
          kGapMedium,

          // 3. COLOR COPY FORMATTER
          Row(
            children: [
              Text(LocaleKeys.lbl_color_copy.localize(),
                  style: AppTextStyles.b2.bold),
              const Spacer(),
            ],
          ),
          kGapTiny,
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
            child: Obx(() {
              final Map<String, String> copyChoices = {
                'Components': LocaleKeys.lbl_color_components.localize(),
                'iOS UIColor': 'iOS UIColor',
                'mac NSColor': 'macOS NSColor',
                'SwiftUI HSB Color': 'SwiftUI HSB Color',
                'SwiftUI RGB Color': 'SwiftUI RGB Color',
                'Android RGB': 'Android RGB',
                'Android HEX': 'Android HEX',
                'Android XML': 'Android XML',
                'Web HEX': 'Web HEX',
                'Web RGB': 'Web RGB',
                'Web HSL': 'Web HSL',
              };

              return Row(
                children: [
                  Expanded(
                    child: DropDownWidget(
                      title: LocaleKeys.lbl_color_picker_type.localize(),
                      choices: copyChoices,
                      selectedValue: state.copyType.value,
                      onSelected: controller.updateCopyType,
                    ),
                  ),
                ],
              );
            }),
          ),
          kGapMedium,

          // Code Preview
          Obx(() {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.1)),
                    ),
                    child: SelectableText(
                      controller.getFormattedCopy(),
                      style: AppTextStyles.monoStyle().copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Tooltip(
                  message: LocaleKeys.input_tooltip_copy.localize(),
                  child: InkWell(
                    onTap: () {
                      controller.copyFormatted();
                    },
                    child: AppImage(
                      IconKeys.textfieldCopy,
                      size: AppDimens.iconSmaller,
                      color: Theme.of(context).iconTheme.color,
                    ).marginAll(
                      AppDimens.marginTiny,
                    ),
                  ),
                ),
              ],
            );
          }),
          kGapLarge,

          // 4. COMPONENTS DISPLAY (RGB, HSB, CMYK)
          Obx(() {
            final c = state.currentColor.value;
            final hsv = HSVColor.fromColor(c);
            final cmyk = controller.cmyk;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildComponentColumn('RGB',
                        ['R: ${c.red}', 'G: ${c.green}', 'B: ${c.blue}'])),
                Expanded(
                    child: _buildComponentColumn('HSB', [
                  'H: ${hsv.hue.round()}°',
                  'S: ${(hsv.saturation * 100).round()}%',
                  'B: ${(hsv.value * 100).round()}%'
                ])),
                Expanded(
                    child: _buildComponentColumn('CMYK', [
                  'C: ${cmyk[0]}%',
                  'M: ${cmyk[1]}%',
                  'Y: ${cmyk[2]}%',
                  'K: ${cmyk[3]}%'
                ])),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHexBox(BuildContext context, String text) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(text, style: AppTextStyles.monoStyle()),
              ),
            ),
            Container(
              width: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
            Tooltip(
              message: LocaleKeys.input_tooltip_copy.localize(),
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                },
                child: AppImage(
                  IconKeys.textfieldCopy,
                  size: AppDimens.iconSmaller,
                  color: Theme.of(context).iconTheme.color,
                ).marginAll(
                  AppDimens.marginTiny,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentColumn(String title, List<String> values) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.b3.bold),
        kGapSmall,
        ...values.map((v) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(v,
                    style: AppTextStyles.monoStyle().copyWith(fontSize: 13)),
              ),
            )),
      ],
    );
  }
}
