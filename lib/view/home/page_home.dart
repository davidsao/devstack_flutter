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
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Main Content Area
          Obx(() {
            final nav = app.state.currentTools.value;
            return AnimatedContainer(
              duration: 500.milliseconds,
              curve: Curves.easeOutQuint,
              // On mobile, the menu floats OVER the content, so we remove the margin push
              margin: EdgeInsets.only(
                left: app.state.isMenuExpanded.value && !isMobile ? 224.0 : 0.0,
                top: app.state.isMenuExpanded.value && !isMobile
                    ? MediaQuery.paddingOf(context).top
                    : kToolbarHeight + MediaQuery.paddingOf(context).top,
              ),
              child: nav.getWidget(null),
            );
          }),

          // 2. Mobile Scrim (Dark overlay so users can tap outside the menu to close it)
          if (isMobile)
            Obx(() {
              if (app.state.isMenuExpanded.value) {
                return Positioned.fill(
                  child: GestureDetector(
                    onTap: () => app.state.isMenuExpanded.value = false,
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

          // 3. Side Menu
          Obx(() {
            return AnimatedPositioned(
              duration: 500.milliseconds, // Snappier duration for mobile
              curve: Curves.easeOutQuint,
              left: app.state.isMenuExpanded.value ? 0.0 : -224.0,
              width:
                  224.0, // <-- CRITICAL FIX: Explicit width guarantees it renders off-screen
              top: AppDimens.marginSmaller +
                  kToolbarHeight +
                  MediaQuery.paddingOf(context).top,
              bottom: MediaQuery.paddingOf(context).bottom +
                  AppDimens.marginSmaller,
              child: HomeSideMenu(),
            );
          }),

          // 4. Toggle Button
          Obx(() {
            return Positioned(
              top: AppDimens.marginSmaller + MediaQuery.paddingOf(context).top,
              left: AppDimens.marginSmaller,
              right: AppDimens.marginSmaller,
              child: Stack(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      if (isMobile)
                        Text(
                          app.state.currentTools.value.getName ??
                              LocaleKeys.lbl_app_name.localize(),
                          style: AppTextStyles.h4.bold,
                        ).marginOnly(top: AppDimens.marginTiny),
                      const Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: 400.milliseconds,
                        curve: Curves.easeOutCubic,
                        width: app.state.isMenuExpanded.value ? 200 : 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusMedium),
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
                                    // Auto-close menu on mobile when tapping logo
                                    if (isMobile) {
                                      app.state.isMenuExpanded.value = false;
                                    }
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
                                    if (isMobile) {
                                      app.state.isMenuExpanded.value = false;
                                    }
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
                      Spacer(),
                    ],
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
