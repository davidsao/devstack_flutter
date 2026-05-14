import 'package:devtoys_flutter/generated/icon_keys.g.dart';
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
            final nav = app.state.currentTools.value;
            return AnimatedContainer(
              duration: 500.milliseconds,
              curve: Curves.easeOutQuint,
              // On mobile, the menu floats OVER the content, so we remove the margin push
              margin: EdgeInsets.only(
                left: app.state.isMenuExpanded.value && !isMobile ? 224.0 : 0.0,
                top: app.state.isMenuExpanded.value && !isMobile
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
              left: app.state.isMenuExpanded.value ? 0.0 : -224.0,
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
                width: app.state.isMenuExpanded.value ? 200 : 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  color: Theme.of(context).cardColor,
                  boxShadow: AppColors.cardShadow,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (app.state.isMenuExpanded.value)
                        kGapSmall
                      else
                        kGapTiny,
                      InkWell(
                        onTap: () {
                          app.state.isMenuExpanded.toggle();
                        },
                        child: Icon(
                          app.state.isMenuExpanded.value
                              ? Icons.menu_open
                              : Icons.menu,
                          size: AppDimens.iconSmall,
                          color: AppColors.grey,
                        ),
                      ),
                      if (app.state.isMenuExpanded.value) ...[
                        kGapTiny,
                        InkWell(
                          onTap: () {
                            app.state.currentTools.value = Nav.allTools;
                          },
                          child: SizedBox(
                            width: 104,
                            child: Text(
                              LocaleKeys.lbl_app_name.localize(),
                              style: AppTextStyles.h4.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        kGapTiny,
                        InkWell(
                          onTap: () {
                            app.next(Nav.settings);
                          },
                          child: AppImage(
                            IconKeys.settings,
                            size: AppDimens.iconSmall,
                            color: AppColors.grey,
                          ),
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
