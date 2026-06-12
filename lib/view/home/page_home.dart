import 'dart:math';

import 'package:devstack/generated/icon_keys.g.dart';
import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/locale_keys.g.dart';

class HomePage extends BaseView<HomeController, HomeState> {
  HomePage({super.key, super.viewTag});

  final ScrollController _tabScrollController = ScrollController();

  @override
  Widget view(BuildContext context) {
    // 1. Get current screen width
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 800;

    // The macOS window controls take up roughly 28 pixels of height.
    final double desktopOffset = isMobile ? 0.0 : 32.0;
    final double safeTopPadding =
        MediaQuery.paddingOf(context).top + desktopOffset;

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
            final activeNav = app.state.currentTools.value;
            return AnimatedContainer(
              duration: 500.milliseconds,
              curve: Curves.easeOutQuint,
              margin: EdgeInsets.only(
                left: app.state.isMenuExpanded.value && !isMobile ? 224.0 : 0.0,
                top: safeTopPadding +
                    (app.state.isMenuExpanded.value && !isMobile
                        ? AppDimens.marginTiny
                        : 44.0),
              ),
              child: Column(
                children: [
                  // --- THE TOOL CONTENT ---
                  Expanded(
                    child: activeNav.getWidget(null),
                  ),
                ],
              ),
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
              duration: 500.milliseconds,
              curve: Curves.easeOutQuint,
              left: app.state.isMenuExpanded.value ? 0.0 : -224.0,
              width: 224.0,
              top: AppDimens.marginSmaller + kToolbarHeight + safeTopPadding,
              bottom: MediaQuery.paddingOf(context).bottom +
                  AppDimens.marginSmaller,
              child: HomeSideMenu(),
            );
          }),

          // 4. Toggle Button
          Obx(() {
            return Positioned(
              top: safeTopPadding + AppDimens.marginSmaller,
              left: (app.state.isIpad.value && isMobile ? 64.0 : 0.0) +
                  AppDimens.marginSmaller,
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
                      if (isMobile)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusMedium),
                            color: Theme.of(context).cardColor,
                            boxShadow: AppColors.cardShadow(context),
                          ),
                          child: InkWell(
                            onTap: () {
                              app.state.currentTools.value = Nav.allTools;
                            },
                            child: AppImage(
                              IconKeys.home,
                              size: AppDimens.iconSmall,
                              color: AppColors.grey,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
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

          // 5. The Tab Bar
          if (!isMobile)
            Obx(() {
              return AnimatedPositioned(
                duration: 500.milliseconds,
                curve: Curves.easeOutQuint,
                // Properly offset below macOS traffic lights
                top: MediaQuery.paddingOf(context).top,
                right: AppDimens.paddingMedium,
                // CRITICAL FIX: Dynamically adjust width constraints based on menu/mobile state!
                left: (app.state.isMenuExpanded.value && !isMobile)
                    ? 240.0
                    : 64.0,
                height: 44.0,
                child: _tabBar,
              );
            }),
        ],
      ),
    );
  }

  Widget get _tabBar {
    return Obx(() {
      final activeNav = app.state.currentTools.value;
      final openTabs = app.state.openTabs;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_tabScrollController.hasClients &&
            openTabs.isNotEmpty &&
            activeNav == openTabs.last) {
          Future.delayed(const Duration(milliseconds: 50), () {
            if (_tabScrollController.hasClients) {
              _tabScrollController.animateTo(
                _tabScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuint,
              );
            }
          });
        }
      });

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
          color: Colors.transparent,
          boxShadow: AppColors.textfieldShadow(context),
        ),
        child: ListView.separated(
          controller: _tabScrollController,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingText,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: app.state.openTabs.length,
          separatorBuilder: (context, index) {
            return Container(
              width: 1,
              margin: const EdgeInsets.symmetric(
                vertical: AppDimens.marginTiny,
                horizontal: 2,
              ),
              color: AppColors.divider.withAlpha(128),
            );
          },
          itemBuilder: (context, index) {
            final tabTool = app.state.openTabs[index];
            final isActive = activeNav == tabTool;

            return GestureDetector(
              onTap: () => app.openTool(tabTool),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: AppDimens.marginText,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingSmaller,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: isActive ? AppColors.cardShadow(context) : null,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmaller),
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (tabTool.getIcon != null) ...[
                      AppImage(
                        tabTool.getIcon!,
                        size: 14,
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : (Theme.of(context).textTheme.bodyMedium?.color ??
                                    AppColors.black)
                                .withAlpha(200),
                      ),
                      kGapSmaller,
                    ],
                    Text(
                      tabTool.getName ?? "Tool",
                      style: AppTextStyles.b2.copyWith(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : (Theme.of(context).textTheme.bodyMedium?.color ??
                                    AppColors.black)
                                .withAlpha(200),
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    kGapText,
                    // Close button (hide for the All Tools dashboard)
                    if (tabTool != Nav.allTools) ...[
                      kGapTiny,
                      InkWell(
                        onTap: () => app.closeTool(tabTool),
                        borderRadius: BorderRadius.circular(12),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
