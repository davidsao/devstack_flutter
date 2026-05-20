import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../generated/icon_keys.g.dart';
import '../../../generated/locale_keys.g.dart';

class DateConverterPage
    extends BaseView<DateConverterController, DateConverterState> {
  const DateConverterPage({super.key, super.viewTag});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.lbl_number_configuration.localize(),
            style: AppTextStyles.b2.bold,
          ),
          kGapTiny,
          Obx(() {
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
              child: DropDownWidget(
                title: LocaleKeys.lbl_date_time_zone.localize(),
                choices: state.choices.value,
                selectedValue: state.timeZoneName.value,
                onSelected: controller.changeTimeZone,
                maxWidth: true,
              ),
            );
          }),
          kGapMedium,

          // --- INFO BOX ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.state.isDst.value
                          ? LocaleKeys.lbl_date_has_daylight.localize()
                          : LocaleKeys.lbl_date_no_daylight.localize(),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          LocaleKeys.lbl_date_offset.localize(),
                          controller.formattedOffset,
                        ),
                        kGapTiny,
                        _buildInfoRow(
                          LocaleKeys.lbl_date_local_datetime.localize(),
                          controller.localDateTimeString,
                        ),
                        kGapTiny,
                        _buildInfoRow(
                          LocaleKeys.lbl_date_utc_ticks.localize(),
                          controller.utcTicks,
                        ),
                        kGapTiny,
                        _buildInfoRow(
                          LocaleKeys.lbl_date_utc_datetime.localize(),
                          controller.utcDateTimeString,
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          kGapSmall,

          // --- TIMESTAMP ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.lbl_date_timestamp.localize(),
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Row(
                children: [
                  Tooltip(
                    message: 'Now',
                    child: InkWell(
                      onTap: controller.setNow,
                      child: AppImage(
                        IconKeys.calendar,
                        size: AppDimens.iconSmall,
                        color: Theme.of(context).iconTheme.color,
                      ).marginAll(
                        AppDimens.marginTiny,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: LocaleKeys.input_tooltip_paste.localize(),
                    child: InkWell(
                      onTap: controller.pasteTimestamp,
                      child: AppImage(
                        IconKeys.textfieldPaste,
                        size: AppDimens.iconSmall,
                        color: Theme.of(context).iconTheme.color,
                      ).marginAll(
                        AppDimens.marginTiny,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: LocaleKeys.input_tooltip_copy.localize(),
                    child: InkWell(
                      onTap: controller.copyTimestamp,
                      child: AppImage(
                        IconKeys.textfieldCopy,
                        size: AppDimens.iconSmall,
                        color: Theme.of(context).iconTheme.color,
                      ).marginAll(
                        AppDimens.marginTiny,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingSmaller,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: TextField(
              controller: controller.timestampController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: controller.updateFromTimestamp,
            ),
          ),
          const SizedBox(height: 24),

          // --- DATE COMPONENTS ---
          LayoutBuilder(builder: (context, constraints) {
            // Break into 6 columns
            double width = (constraints.maxWidth - (5 * 8)) / 6;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildComponentInput(LocaleKeys.input_date_year.localize(),
                    controller.yearController, width),
                _buildComponentInput(LocaleKeys.input_date_month.localize(),
                    controller.monthController, width),
                _buildComponentInput(LocaleKeys.input_date_day.localize(),
                    controller.dayController, width),
                _buildComponentInput(LocaleKeys.input_date_hour.localize(),
                    controller.hourController, width),
                _buildComponentInput(LocaleKeys.input_date_minutes.localize(),
                    controller.minuteController, width),
                _buildComponentInput(LocaleKeys.input_date_seconds.localize(),
                    controller.secondController, width),
              ],
            );
          })
        ],
      ),
    );
  }

  // UI Helper for Info Box
  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(fontFamily: 'monospace'),
            textAlign: TextAlign.end,
          ),
        ),
        ToolTipIconButton(
          icon: IconKeys.textfieldCopy,
          tooltip: 'Copy',
          onTap: () {
            _copy(value);
          },
        ),
      ],
    );
  }

  // UI Helper for Date Components
  Widget _buildComponentInput(
      String label, TextEditingController ctrl, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
  }
}
