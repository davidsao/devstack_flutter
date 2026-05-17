import 'package:devtoys_flutter/index.dart';
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
          left: AppDimens.paddingMedium,
          right: AppDimens.paddingMedium,
          top: AppDimens.paddingMedium,
          bottom: AppDimens.paddingSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.lbl_all_tools.localize(),
              style: AppTextStyles.h2.bold,
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
                              style: AppTextStyles.b1.bold,
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
          app.state.currentTools.value = nav;
          // If you are on a mobile device, auto-close the menu after selecting a tool
          if (MediaQuery.sizeOf(context).width < 800) {
            app.state.isMenuExpanded.value = false;
          }
        },
        child: GlassContainer(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingSmall,
                vertical: AppDimens.paddingTiny),
            child: Row(
              children: [
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
                    message: isPinned ? 'Unpin Tool' : 'Pin Tool',
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
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          isPinned ? Icons.push_pin : Icons.push_pin_outlined,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
