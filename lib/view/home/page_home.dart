import 'dart:math';

import 'package:devstack/generated/icon_keys.g.dart';
import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../generated/locale_keys.g.dart';

class HomePage extends BaseView<HomeController, HomeState> {
  HomePage({super.key, super.viewTag});

  // Now we need two scroll controllers!
  final ScrollController _tabScrollControllerLeft = ScrollController();
  final ScrollController _tabScrollControllerRight = ScrollController();

  @override
  Widget view(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 1024;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateResponsiveState(screenWidth);
    });

    return PopScope(
      canPop: false, // Prevents the OS from immediately killing the app
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // 0. For mobile size with side panel expanded, close the side panel
        if (isMobile && app.state.isMenuExpanded.value) {
          app.state.isMenuExpanded.value = false;
          return;
        }

        final isSplit = app.state.isSplitScreen.value;
        final activePane = app.state.activePane.value;

        // 1. Single panel opened
        if (!isSplit) {
          if (app.state.currentTools.value != Nav.allTools) {
            // Close the current tool
            app.closeTool(app.state.currentTools.value, pane: 'left');
          } else {
            // We are at the root, close the app
            SystemNavigator.pop();
          }
          return;
        }

        // 2. Multi-panel opened with LEFT panel in focus
        if (isSplit && activePane == 'left') {
          if (app.state.currentTools.value != Nav.allTools) {
            // Close the current tool on the left panel
            app.closeTool(app.state.currentTools.value, pane: 'left');
          } else {
            // Close the left panel entirely.
            // To make the right panel the new single panel, we copy the right
            // panel's state into the left panel's state, then disable split screen.
            app.state.openTabs.assignAll(app.state.openTabsRight);
            app.state.currentTools.value = app.state.currentToolsRight.value;

            // Clean up the right panel state
            app.state.openTabsRight.assignAll([Nav.allTools]);
            app.state.currentToolsRight.value = Nav.allTools;

            // Collapse to single screen
            app.state.isSplitScreen.value = false;
            app.state.activePane.value = 'left';
          }
          return;
        }

        // 3. Multi-panel opened with RIGHT panel in focus
        if (isSplit && activePane == 'right') {
          if (app.state.currentToolsRight.value != Nav.allTools) {
            // Close the current tool on the right panel
            app.closeTool(app.state.currentToolsRight.value, pane: 'right');
          } else {
            // Close the right panel entirely.
            // The left panel is already holding the correct state, so we just
            // clean up the right panel and disable split screen.
            app.state.openTabsRight.assignAll([Nav.allTools]);
            app.state.currentToolsRight.value = Nav.allTools;

            app.state.isSplitScreen.value = false;
            app.state.activePane.value = 'left';
          }
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Gradient
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
                  size: min(MediaQuery.sizeOf(context).height,
                          MediaQuery.sizeOf(context).width) *
                      0.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : null,
                ),
              ),
            ),

            // 1. MAIN CONTENT AREA
            Obx(() {
              final double safeTopPadding =
                  app.state.platform.value.fullSafeTopPadding(context);
              final activeNavLeft = app.state.currentTools.value;
              final activeNavRight = app.state.currentToolsRight.value;
              final isSplit = app.state.isSplitScreen.value && !isMobile;

              return AnimatedContainer(
                duration: 500.milliseconds,
                curve: Curves.easeOutQuint,
                margin: EdgeInsets.only(
                  left:
                      app.state.isMenuExpanded.value && !isMobile ? 224.0 : 0.0,
                  top: safeTopPadding + 44.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTapDown: (_) => app.state.activePane.value = 'left',
                        child: ActivePaneProvider(
                          pane: 'left',
                          child: Column(
                            children: [
                              Expanded(child: activeNavLeft.getWidget(null))
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isSplit) ...[
                      Container(
                          width: 1, color: Theme.of(context).dividerColor),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTapDown: (_) =>
                              app.state.activePane.value = 'right',
                          child: ActivePaneProvider(
                            pane: 'right',
                            child: Column(
                              children: [
                                Expanded(child: activeNavRight.getWidget(null))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              );
            }),

            // 2. Mobile Scrim
            if (isMobile)
              Obx(() {
                if (app.state.isMenuExpanded.value) {
                  return Positioned.fill(
                    child: GestureDetector(
                      onTap: () => app.state.isMenuExpanded.value = false,
                      child: Container(color: Colors.black.withAlpha(104)),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

            // 3. Side Menu
            Obx(() {
              final double safeTopPadding =
                  app.state.platform.value.fullSafeTopPadding(context);
              return AnimatedPositioned(
                duration: 500.milliseconds,
                curve: Curves.easeOutQuint,
                left: app.state.isMenuExpanded.value ? 0.0 : -224.0,
                width: 224.0,
                top: kToolbarHeight + safeTopPadding,
                bottom: MediaQuery.paddingOf(context).bottom +
                    AppDimens.marginSmaller,
                child: HomeSideMenu(),
              );
            }),

            // 4. Toggle Button & Split Screen Control
            Obx(() {
              final double safeTopPadding =
                  app.state.platform.value.fullSafeTopPadding(context);
              return Positioned(
                top: safeTopPadding,
                left: app.state.platform.value
                        .toggleButtonLeftOffset(isMobile: isMobile) +
                    AppDimens.marginSmaller,
                right: AppDimens.marginSmaller,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        if (isMobile)
                          SizedBox(
                            width: 40,
                            height: 40,
                          ),
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
                              onTap: () =>
                                  app.state.currentTools.value = Nav.allTools,
                              child: AppImage(IconKeys.home,
                                  size: AppDimens.iconSmall,
                                  color: AppColors.grey,
                                  fit: BoxFit.scaleDown),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: 400.milliseconds,
                          curve: Curves.easeOutCubic,
                          width: app.state.isMenuExpanded.value
                              ? 204
                              : 40, // Slightly wider to fit the new button
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
                                kGapTiny,
                                InkWell(
                                  onTap: () =>
                                      app.state.isMenuExpanded.toggle(),
                                  child: Icon(
                                      app.state.isMenuExpanded.value
                                          ? Icons.menu_open
                                          : Icons.menu,
                                      size: AppDimens.iconSmall,
                                      color: AppColors.grey),
                                ),
                                if (app.state.isMenuExpanded.value) ...[
                                  kGapTiny,
                                  InkWell(
                                    onTap: () {
                                      app.state.currentTools.value =
                                          Nav.allTools;
                                      if (isMobile) {
                                        app.state.isMenuExpanded.value = false;
                                      }
                                    },
                                    child: SizedBox(
                                      width: 124,
                                      child: Text(
                                          LocaleKeys.lbl_app_name.localize(),
                                          style: AppTextStyles.h4.bold,
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                  kGapTiny,
                                  // THE NEW SPLIT SCREEN BUTTON!
                                  if (!isMobile) ...[
                                    InkWell(
                                      onTap: () => app.toggleSplitScreen(),
                                      child: AppImage(
                                        app.state.isSplitScreen.value
                                            ? IconKeys.splitScreenActive
                                            : IconKeys.splitScreen,
                                        size: AppDimens.iconSmall,
                                        color: app.state.isSplitScreen.value
                                            ? AppColors.primary
                                            : AppColors.grey,
                                      ),
                                    ),
                                    kGapTiny,
                                  ],
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

            // 5. The Tab Bars
            if (!isMobile)
              Obx(() {
                final double safeTopPadding =
                    app.state.platform.value.fullSafeTopPadding(context);
                final isSplit = app.state.isSplitScreen.value;
                final contentLeftOffset =
                    app.state.isMenuExpanded.value ? 224.0 : 0.0;
                final trueCenter =
                    contentLeftOffset + (screenWidth - contentLeftOffset) / 2;
                final leftTabStart =
                    app.state.isMenuExpanded.value ? 224.0 : 64.0;

                return Stack(
                  children: [
                    Positioned(
                      top: safeTopPadding,
                      left: leftTabStart + AppDimens.marginSmall,
                      right: isSplit
                          ? (screenWidth - trueCenter) + AppDimens.marginSmall
                          : AppDimens.paddingMedium,
                      height: 48.0,
                      child: _buildTabBar(context, 'left'),
                    ),
                    if (isSplit)
                      Positioned(
                        top: safeTopPadding,
                        left: trueCenter + AppDimens.marginSmall,
                        right: AppDimens.paddingMedium,
                        height: 48.0,
                        child: _buildTabBar(context, 'right'),
                      ),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE TAB BAR BUILDER ---
  Widget _buildTabBar(BuildContext context, String pane) {
    return Obx(() {
      final isLeft = pane == 'left';
      final activeNav = isLeft
          ? app.state.currentTools.value
          : app.state.currentToolsRight.value;
      final openTabs = isLeft ? app.state.openTabs : app.state.openTabsRight;
      final isActivePane = app.state.activePane.value == pane;
      final scrollController =
          isLeft ? _tabScrollControllerLeft : _tabScrollControllerRight;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients &&
            openTabs.isNotEmpty &&
            activeNav == openTabs.last) {
          Future.delayed(const Duration(milliseconds: 50), () {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuint,
              );
            }
          });
        }
      });

      return GestureDetector(
        onTapDown: (_) => app.state.activePane.value = pane,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isActivePane
                  ? Theme.of(context).primaryColor.withAlpha(120)
                  : Colors.transparent,
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
            color: Colors.transparent,
            boxShadow: AppColors.textfieldShadow(context),
          ),
          clipBehavior: Clip.hardEdge,
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            scrollController: scrollController,
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.paddingText),
            scrollDirection: Axis.horizontal,
            itemCount: openTabs.length,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex == 0) return;
              if (newIndex == 0) newIndex = 1;
              if (oldIndex < newIndex) newIndex -= 1;

              final item = openTabs.removeAt(oldIndex);
              openTabs.insert(newIndex, item);
            },
            proxyDecorator: (child, index, animation) =>
                Material(color: Colors.transparent, child: child),
            itemBuilder: (context, index) {
              final tabTool = openTabs[index];
              final isActive = activeNav == tabTool;

              Widget tabContent = GestureDetector(
                onTap: () => app.openTool(tabTool, targetPane: pane),
                child: Container(
                  height: 44,
                  margin: const EdgeInsets.symmetric(
                      vertical: AppDimens.marginText),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingSmaller),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.surface
                        : Colors.transparent,
                    boxShadow: isActive ? AppColors.cardShadow(context) : null,
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusSmaller),
                    border: Border(
                      bottom: BorderSide(
                        color:
                            isActive ? AppColors.primary : Colors.transparent,
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
                              : (Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color ??
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
                              : (Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color ??
                                      AppColors.black)
                                  .withAlpha(200),
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      kGapText,
                      if (tabTool != Nav.allTools) ...[
                        kGapTiny,
                        InkWell(
                          onTap: () => app.closeTool(tabTool, pane: pane),
                          borderRadius: BorderRadius.circular(12),
                          child: Icon(Icons.close,
                              size: 14, color: AppColors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              );

              if (tabTool != Nav.allTools) {
                tabContent = ReorderableDragStartListener(
                    index: index, child: tabContent);
              }

              return Row(
                key: ValueKey(tabTool),
                mainAxisSize: MainAxisSize.min,
                children: [
                  tabContent,
                  if (index < openTabs.length - 1)
                    Container(
                        width: 1,
                        margin: const EdgeInsets.symmetric(
                            vertical: AppDimens.marginTiny, horizontal: 2),
                        color: AppColors.divider.withAlpha(128)),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}
