import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/locale_keys.g.dart';

class HomePage extends BaseView<HomeController, HomeState> {
  const HomePage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    // 1. Get current screen width
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 800;

    // 2. Safely trigger the responsive check after the current build phase completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateResponsiveState(screenWidth);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Main Content Area
          Obx(() {
            final nav = state.currentBottomNavigation.value;
            return AnimatedContainer(
              duration: 500.milliseconds,
              curve: Curves.easeOutQuint,
              // On mobile, the menu floats OVER the content, so we remove the margin push
              margin: EdgeInsets.only(
                left: state.isMenuExpanded.value && !isMobile ? 224.0 : 0.0,
                top: state.isMenuExpanded.value && !isMobile
                    ? 0.0
                    : kToolbarHeight,
              ),
              child: nav.getWidget(null),
            );
          }),

          // Side Menu
          Obx(() {
            return AnimatedPositioned(
              duration: 800.milliseconds,
              curve: const ElasticOutCurve(0.9),
              left: state.isMenuExpanded.value ? 0.0 : -224.0,
              top: AppDimens.marginSmaller + kToolbarHeight,
              bottom: MediaQuery.paddingOf(context).bottom +
                  AppDimens.marginSmaller,
              child: HomeSideMenu(),
            );
          }),

          // Toggle Button
          Obx(() {
            return Positioned(
              top: AppDimens.marginSmaller,
              left: AppDimens.marginMedium,
              child: AnimatedContainer(
                duration: 400.milliseconds,
                curve: Curves.easeOutCubic,
                width: state.isMenuExpanded.value ? 160 : 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  color: Theme.of(context).cardColor,
                  boxShadow: AppColors.cardShadow,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.isMenuExpanded.value) kGapSmall else kGapTiny,
                      InkWell(
                        onTap: () {
                          state.isMenuExpanded.toggle();
                        },
                        child: Icon(state.isMenuExpanded.value
                            ? Icons.menu_open
                            : Icons.menu),
                      ),
                      if (state.isMenuExpanded.value) ...[
                        kGapTiny,
                        Text(
                          LocaleKeys.lbl_app_name.localize(),
                          style: AppTextStyles.h4.bold,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
