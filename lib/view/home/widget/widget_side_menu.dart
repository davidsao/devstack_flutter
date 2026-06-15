import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../generated/locale_keys.g.dart';

class HomeSideMenu extends BaseView<HomeController, HomeState> {
  HomeSideMenu({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 800;

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
                      hintText: LocaleKeys.input_search.localize(),
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
                child: _buildMenuContent(context, isMobile),
              ),
            ],
          ),
        ),
      );

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          color: Theme.of(context).cardColor,
          boxShadow: AppColors.cardShadow(context),
        ),
        child: content,
      ).marginOnly(
        left: AppDimens.marginSmaller,
        right: AppDimens.marginSmaller,
      );
    });
  }

  Widget _buildMenuContent(BuildContext context, bool isMobile) {
    List<Widget> menuItems = [];
    final query = state.searchQuery.value;

    // --- 1. INJECT HOME / ALL TOOLS SHORTCUT ---
    // Check if "All Tools" matches the active search query
    final bool homeMatches = query.isEmpty ||
        (Nav.allTools.getName?.toLowerCase().contains(query) ?? false) ||
        Nav.allTools.searchTerms
            .any((term) => term.toLowerCase().contains(query));

    if (homeMatches) {
      final bool isActive = app.state.currentTools.value == Nav.allTools;
      menuItems.add(
        InkWell(
          onTap: () async {
            app.state.currentTools.value = Nav.allTools;
            if (isMobile) {
              app.state.isMenuExpanded.value = false;
            }
            await HapticFeedback.heavyImpact();
          },
          child: SizedBox(
            height: 36, // Slightly taller to stand out as a top-level item
            child: _navItem(context, Nav.allTools, isActive),
          ),
        ),
      );
      menuItems.add(
        InkWell(
          onTap: () async {
            app.next(Nav.settings);
          },
          child: SizedBox(
            height: 36, // Slightly taller to stand out as a top-level item
            child: _navItem(context, Nav.settings, false),
          ),
        ),
      );
      // Add a small divider or spacing before the categories start
      menuItems.add(const SizedBox(height: 8));
    }

    // --- 2. GENERATE CATEGORIES ---
    for (final entry in app.state.tools.entries) {
      final categoryKey = entry.key;

      // Filter the items within this category based on the search query
      final filteredItems = entry.value.where((nav) {
        // 1. Check the currently active localized name
        final name = nav.getName?.toLowerCase() ?? '';
        if (name.contains(query)) return true;

        // 2. Check the global multi-language search terms
        final searchTerms = nav.searchTerms;
        for (final term in searchTerms) {
          if (term.toLowerCase().contains(query)) {
            return true;
          }
        }

        return false; // No match found
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
                    final bool isActive = app.state.currentTools.value == nav ||
                        app.state.currentToolsRight.value == nav;

                    // NEW: Check if the tool is locked in the other pane
                    final bool isEnabled = app.canOpenTool(nav);

                    return InkWell(
                      // Disable taps if locked
                      onTap: isEnabled
                          ? () async {
                              app.openTool(nav);
                              if (isMobile) {
                                app.state.isMenuExpanded.value = false;
                              }
                              await HapticFeedback.heavyImpact();
                            }
                          : null,
                      child: SizedBox(
                        height: 32,
                        // Pass the enabled state down to the visual builder
                        child: _navItem(context, nav, isActive, isEnabled),
                      ),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(), // Shrinks to 0 height when collapsed
        ),
      );
    }

    // Show a fallback if search yields zero results across all categories AND the home button
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

  // NEW: Added isEnabled parameter
  Widget _navItem(BuildContext context, Nav nav, bool active,
      [bool isEnabled = true]) {
    Color itemColor = active
        ? Theme.of(context).colorScheme.primary
        : (Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.black)
            .withAlpha(200);

    return Opacity(
      // Dim the item if it is locked out by the other pane
      opacity: isEnabled ? 1.0 : 0.3,
      child: SingleChildScrollView(
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
                // Add an italic strike or just keep it simple with the opacity
              ),
              maxLines: 2,
            ).paddingSymmetric(horizontal: AppDimens.paddingTiny),

            // Optional: Add a tiny lock icon to make it clearer why it's disabled
            if (!isEnabled) ...[
              kGapTiny,
              Icon(Icons.lock_outline, size: 12, color: itemColor),
            ]
          ],
        ),
      ),
    );
  }
}
