import 'dart:math';

import 'package:devstack/generated/icon_keys.g.dart';
import 'package:devstack/index.dart';
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
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withAlpha(32),
                  AppColors.primaryColor.withAlpha(8),
                  Colors.transparent,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.02,
              child: AppImage(
                IconKeys.bg,
                size: min(
                      MediaQuery.sizeOf(context).height,
                      MediaQuery.sizeOf(context).width,
                    ) *
                    0.5,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : null,
              ),
            ),
          ),
          // 1. Main Content Area
          Obx(() {
            final nav = app.state.currentTools.value;
            return AnimatedContainer(
              duration: 500.milliseconds,
              curve: Curves.easeOutQuint,
              // On mobile, the menu floats OVER the content, so we remove the margin push
              margin: EdgeInsets.only(
                left: app.state.isMenuExpanded.value && !isMobile ? 224.0 : 0.0,
                top: app.state.isMenuExpanded.value && app.state.isIpad.value
                    ? MediaQuery.paddingOf(context).top + 44.0
                    : (app.state.isMenuExpanded.value && !isMobile
                        ? MediaQuery.paddingOf(context).top
                        : kToolbarHeight + MediaQuery.paddingOf(context).top),
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
              width: 224.0,
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
              top: MediaQuery.paddingOf(context).top +
                  (app.state.isIpad.value ? 0.0 : AppDimens.marginSmaller),
              left:
                  AppDimens.marginSmaller + (app.state.isIpad.value ? 64 : 0.0),
              right: AppDimens.marginSmaller,
              child: Stack(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      if (isMobile ||
                          (!app.state.isMenuExpanded.value &&
                              app.state.currentTools.value != Nav.allTools))
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
                          boxShadow: AppColors.cardShadow(context),
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
