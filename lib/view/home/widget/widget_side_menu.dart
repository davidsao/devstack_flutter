// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
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
          child: _buildMenuContent(context),
        ),
      );

      return GlassContainer(
        color: Theme.of(context).cardColor,
        child: content,
      ).marginOnly(
        left: AppDimens.marginSmaller,
        right: AppDimens.marginSmaller,
      );
    });
  }

  /// Builds the Stack containing the highlight box and the menu items
  Widget _buildMenuContent(BuildContext context) {
    List<Widget> menuItems = [];

    for (final entry in state.bottomNavigation.entries) {
      menuItems.add(
        SizedBox(
          height: 48,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppDimens.paddingSmaller,
                right: AppDimens.paddingSmaller,
                bottom: AppDimens.paddingTiny,
              ),
              child: Text(
                entry.key.toUpperCase(),
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
          ),
        ),
      );

      // 2. Add Navigation Items under this section
      for (final nav in entry.value) {
        final bool isActive = state.currentBottomNavigation.value == nav;

        menuItems.add(
          InkWell(
            onTap: () async {
              state.currentBottomNavigation.value = nav;
              await HapticFeedback.heavyImpact();
            },
            child: SizedBox(
              height: 48,
              child: _navItem(context, nav, isActive),
            ),
          ),
        );
      }
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

  /// Builds the individual Icon and Text
  Widget _navItem(BuildContext context, Nav nav, bool active) {
    Color itemColor = active
        ? Theme.of(context).colorScheme.primary
        : (Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.black)
            .withAlpha(200);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingSmaller),
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          AppImage(
            nav.getIcon ?? "",
            size: 28,
            fit: BoxFit.scaleDown,
            color: itemColor,
          ),
          Text(
            nav.getName ?? '',
            style: Get.textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: itemColor,
            ),
            maxLines: 2,
          ).paddingSymmetric(horizontal: AppDimens.paddingTiny),
        ],
      ),
    );
  }
}
