import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeSideMenu extends BaseView<HomeController, HomeState> {
  HomeSideMenu({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Obx(() {
      Widget content = SizedBox(
        width: 208,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppDimens.paddingSmaller,
            top: AppDimens.paddingSmaller,
            bottom: AppDimens.paddingSmaller,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // --- SEARCH BAR ---
              Padding(
                padding: const EdgeInsets.only(
                  right: AppDimens.paddingSmaller,
                  bottom: AppDimens.paddingSmall,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.paddingText,
                    horizontal: AppDimens.paddingSmaller,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: TextField(
                    onChanged: controller.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Type to search...',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: AppTextStyles.b3,
                  ),
                ),
              ),
              // --- MENU LIST ---
              Expanded(
                child: _buildMenuContent(context),
              ),
            ],
          ),
        ),
      );

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          color: Theme.of(context).cardColor,
          boxShadow: AppColors.cardShadow,
        ),
        child: content,
      ).marginOnly(
        left: AppDimens.marginSmaller,
        right: AppDimens.marginSmaller,
      );
    });
  }

  Widget _buildMenuContent(BuildContext context) {
    List<Widget> menuItems = [];
    final query = state.searchQuery.value;

    for (final entry in app.state.tools.entries) {
      final categoryKey = entry.key;

      // Filter the items within this category based on the search query
      final filteredItems = entry.value.where((nav) {
        final name = nav.getName?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();

      // If a search is active and this category has no matches, skip drawing it
      if (query.isNotEmpty && filteredItems.isEmpty) {
        continue;
      }

      final isCollapsed = state.collapsedCategories.contains(categoryKey);
      final shouldShowItems = query.isNotEmpty || !isCollapsed;

      // 1. Add Category Header (Clickable to toggle)
      menuItems.add(
        InkWell(
          onTap: () => controller.toggleCategory(categoryKey),
          child: SizedBox(
            height: 40,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppDimens.paddingSmaller,
                  right: AppDimens.paddingSmaller,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        categoryKey.toUpperCase(),
                        style: Get.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    // Animated Chevron
                    if (query.isEmpty)
                      AnimatedRotation(
                        // 0.0 is pointing down, -0.5 is pointing up
                        turns: isCollapsed ? 0.0 : -0.5,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.5),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // 2. Add Animated Navigation Items
      menuItems.add(
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.hardEdge,
          child: shouldShowItems
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: filteredItems.map((nav) {
                    final bool isActive = app.state.currentTools.value == nav;

                    return InkWell(
                      onTap: () async {
                        app.state.currentTools.value = nav;
                        await HapticFeedback.heavyImpact();
                      },
                      child: SizedBox(
                        height: 32,
                        child: _navItem(context, nav, isActive),
                      ),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(), // Shrinks to 0 height when collapsed
        ),
      );
    }

    // Show a fallback if search yields zero results across all categories
    if (query.isNotEmpty && menuItems.isEmpty) {
      return Center(
        child: Text(
          'No tools found.',
          style: AppTextStyles.b3.copyWith(
            color:
                Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...menuItems,
          SizedBox(
            height:
                MediaQuery.of(context).padding.bottom + AppDimens.marginSmall,
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, Nav nav, bool active) {
    Color itemColor = active
        ? Theme.of(context).colorScheme.primary
        : (Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.black)
            .withAlpha(200);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingText),
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          AppImage(
            nav.getIcon ?? "",
            size: 18,
            fit: BoxFit.scaleDown,
            color: itemColor,
          ),
          Text(
            nav.getName ?? '',
            style: AppTextStyles.b3.copyWith(
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: itemColor,
            ),
            maxLines: 2,
          ).paddingSymmetric(horizontal: AppDimens.paddingTiny),
        ],
      ),
    );
  }
}
