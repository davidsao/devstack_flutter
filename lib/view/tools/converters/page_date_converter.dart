import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../generated/icon_keys.g.dart';

class DateConverterPage
    extends BaseView<DateConverterController, DateConverterState> {
  const DateConverterPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimens.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return DropDownWidget(
              title: 'Time zone:',
              choices: state.choices.value,
              selectedValue: state.timeZoneName.value,
              onSelected: (String val) {
                if (val == 'UTC') {
                  controller.state.timeZoneOffset.value = Duration.zero;
                  controller.state.timeZoneName.value = 'UTC';
                } else {
                  controller.state.timeZoneOffset.value =
                      DateTime.now().timeZoneOffset;
                  controller.state.timeZoneName.value = 'Local System Time';
                }
                // Force sync fields to new timezone
                controller
                    .updateFromTimestamp(controller.timestampController.text);
              },
              maxWidth: true,
            );
          }),
          kGapMedium,

          // --- INFO BOX ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            ),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.state.isDst.value
                        ? 'There is daylight saving time.'
                        : 'There is no daylight saving time.'),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          'Offset',
                          controller.formattedOffset,
                        ),
                        kGapTiny,
                        _buildInfoRow(
                          'Local Date Time',
                          controller.localDateTimeString,
                        ),
                        kGapTiny,
                        _buildInfoRow(
                          'UtcTicks',
                          controller.utcTicks,
                        ),
                        kGapTiny,
                        _buildInfoRow(
                          'UTC Date Time',
                          controller.utcDateTimeString,
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 24),

          // --- TIMESTAMP ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Timestamp',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Row(
                children: [
                  Tooltip(
                      message: 'Now',
                      child: IconButton(
                          icon: const Icon(Icons.today, size: 20),
                          onPressed: controller.setNow)),
                  Tooltip(
                      message: 'Paste',
                      child: IconButton(
                          icon: const Icon(Icons.paste, size: 20),
                          onPressed: controller.pasteTimestamp)),
                  Tooltip(
                      message: 'Copy',
                      child: IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: controller.copyTimestamp)),
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
                _buildComponentInput('Year', controller.yearController, width),
                _buildComponentInput(
                    'Month', controller.monthController, width),
                _buildComponentInput('Day', controller.dayController, width),
                _buildComponentInput(
                    'Hour (24 hour)', controller.hourController, width),
                _buildComponentInput(
                    'Minutes', controller.minuteController, width),
                _buildComponentInput(
                    'Seconds', controller.secondController, width),
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
