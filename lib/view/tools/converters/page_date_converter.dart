import 'package:devtoys_flutter/generated/locale_keys.g.dart';
import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class DateConverterPage
    extends BaseView<DateConverterController, DateConverterState> {
  const DateConverterPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.nav_date.localize()),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Placeholder(),
    );
  }
}
