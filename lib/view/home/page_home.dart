import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/locale_keys.g.dart';

class HomePage extends BaseView<HomeController, HomeState> {
  const HomePage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(LocaleKeys.lbl_app_name.localize()),
        leading: Obx(() {
          return InkWell(
            onTap: () {
              state.isMenuExpanded.toggle();
            },
            child:
                Icon(state.isMenuExpanded.value ? Icons.menu : Icons.menu_open),
          );
        }),
        scrolledUnderElevation: 0.0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Obx(() {
            final nav = state.currentBottomNavigation.value;
            return AnimatedContainer(
              duration: 500.milliseconds,
              curve: Curves.easeOutQuint,
              margin: EdgeInsets.only(
                  left: state.isMenuExpanded.value ? 224.0 : 0.0),
              child: nav.getWidget(null),
            );
          }),
          Obx(() {
            return AnimatedPositioned(
              duration: 800.milliseconds,
              curve: ElasticOutCurve(0.9),
              left: state.isMenuExpanded.value ? 0.0 : -224.0,
              top: AppDimens.marginSmaller,
              bottom: MediaQuery.paddingOf(context).bottom +
                  AppDimens.marginSmaller,
              child: HomeSideMenu(),
            );
          }),
        ],
      ),
    );
  }
}
