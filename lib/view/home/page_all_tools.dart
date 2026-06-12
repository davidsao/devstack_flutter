import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/locale_keys.g.dart';

class AllToolsPage extends BaseView<AllToolsController, AllToolsState> {
  const AllToolsPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    // Access the HomeController to get the master list of tools and categories
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(
          top: AppDimens.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.lbl_all_tools.localize(),
              style: AppTextStyles.h2.bold,
            ).marginSymmetric(
              horizontal: AppDimens.paddingMedium,
            ),
            kGapMedium,
            Expanded(
              child: Obx(() {
                final categories = app.state.tools.value;

                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: AppDimens.paddingMedium,
                      left: AppDimens.paddingMedium,
                      right: AppDimens.paddingMedium,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final categoryName = categories.keys.elementAt(index);
                      final tools = categories[categoryName]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppDimens.paddingTiny),
                            child: Text(
                              categoryName,
                              style: AppTextStyles.t3,
                            ),
                          ),
                          // Responsive Grid of Tool Cards
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 240, // Max width of a card
                              mainAxisExtent: 64, // Fixed height of a card
                              crossAxisSpacing: AppDimens.marginSmaller,
                              mainAxisSpacing: AppDimens.marginSmaller,
                            ),
                            itemCount: tools.length,
                            itemBuilder: (context, toolIndex) {
                              final nav = tools[toolIndex];
                              return _buildToolCard(context, nav);
                            },
                          ),
                          kGapSmall,
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, Nav nav) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          app.openTool(nav);
          // If you are on a mobile device, auto-close the menu after selecting a tool
          if (MediaQuery.sizeOf(context).width < 800) {
            app.state.isMenuExpanded.value = false;
          }
        },
        child: GlassContainer(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(
              AppDimens.paddingTiny,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    kGapText,
                    AppImage(
                      nav.getIcon ?? "",
                      size: AppDimens.iconSmall,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        nav.getName ?? '',
                        style: AppTextStyles.b2.semiBold.copyWith(height: 1.1),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Obx(() {
                      final isPinned = app.state.pinnedTools.contains(nav);
                      return Tooltip(
                        message: isPinned
                            ? LocaleKeys.lbl_unpin.localize()
                            : LocaleKeys.lbl_pin.localize(),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => app.togglePin(nav),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(64),
                              ),
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                            ),
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              isPinned
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined,
                              size: 18,
                              color: isPinned
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .iconTheme
                                      .color
                                      ?.withAlpha(72),
                            ),
                          ),
                        ),
                      );
                    }),
                    kGapText,
                  ],
                ),
                Obx(() {
                  final isOpen = app.state.openTabs.contains(nav);
                  if (isOpen) {
                    return Positioned(
                      top: 4,
                      right: 0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Get.isDarkMode
                              ? AppColors.white
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
