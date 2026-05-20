import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

import '../../generated/icon_keys.g.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    required this.title,
    required this.choices,
    required this.selectedValue,
    required this.onSelected,
    this.maxWidth = false,
    super.key,
  });

  final String title;
  final Map<String, String> choices;
  final String selectedValue;
  final Function(String) onSelected;
  final bool maxWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.b2.bold),
        kGapSmall,
        if (maxWidth)
          Expanded(
            child: dropDownWidget(context),
          )
        else
          dropDownWidget(context),
      ],
    );
  }

  Widget dropDownWidget(BuildContext context) {
    return Container(
      height: 40,
      width: maxWidth ? null : 144,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingSmaller),
      decoration: BoxDecoration(
        color:
            Theme.of(context).dropdownMenuTheme.inputDecorationTheme?.fillColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        boxShadow: AppColors.toolbarShadow(context),
      ),
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(
            focusColor: Theme.of(context).colorScheme.primary.withAlpha(80),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            dropdownColor: Theme.of(context).inputDecorationTheme.fillColor,
            icon: AppImage(
              IconKeys.dropDown,
              color: Theme.of(context).iconTheme.color,
              size: AppDimens.radiusMedium,
            ),
            items: choices.entries.map((e) {
              return DropdownMenuItem(
                value: e.key,
                child: Text(
                  e.value,
                  style: AppTextStyles.b2.copyWith(height: 1.1),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              );
            }).toList(),
            // onChanged: (val) => controller.updateIndent(val!),
            onChanged: (val) {
              if (val != null) {
                onSelected.call(val);
              }
            },
          ),
        ),
      ),
    );
  }
}
