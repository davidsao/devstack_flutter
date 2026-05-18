import 'package:devtoys_flutter/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../generated/locale_keys.g.dart';

class SettingsPage extends BaseView<SettingsController, SettingsState> {
  const SettingsPage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Builder(
      builder: (context) {
        // Generate language choices dynamically from your Language enum
        final Map<String, String> languageChoices = Map.fromEntries(
          Language.values.map((lang) => MapEntry(lang.name, lang.display)),
        );

        // Get current language based on EasyLocalization context
        final currentLanguage = Language.values.firstWhere(
          (l) => l.locale.languageCode == context.locale.languageCode,
          orElse: () => Language.english,
        );

        final Map<String, String> themeChoices = {
          'system': LocaleKeys.lbl_settings_theme_default.localize(),
          'light': LocaleKeys.lbl_settings_theme_light.localize(),
          'dark': LocaleKeys.lbl_settings_theme_dark.localize(),
        };

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              LocaleKeys.lbl_settings_title.localize(),
              style: AppTextStyles.b1.bold,
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppDimens.paddingMedium,
              right: AppDimens.paddingMedium,
              top: AppDimens.paddingMedium,
              bottom:
                  AppDimens.paddingSmall + MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                    LocaleKeys.lbl_settings_appearance.localize()),
                GlassContainer(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    child: Obx(() {
                      String currentTheme = 'system';
                      if (state.themeMode.value == ThemeMode.light) {
                        currentTheme = 'light';
                      } else if (state.themeMode.value == ThemeMode.dark) {
                        currentTheme = 'dark';
                      }

                      return DropDownWidget(
                        title: LocaleKeys.lbl_settings_theme.localize(),
                        choices: themeChoices,
                        selectedValue: currentTheme,
                        onSelected: controller.changeTheme,
                        maxWidth: false,
                      );
                    }),
                  ),
                ),
                kGapMedium,

                // --- LANGUAGE ---
                _buildSectionHeader(
                    LocaleKeys.lbl_settings_language.localize()),
                GlassContainer(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    child: DropDownWidget(
                      title: LocaleKeys.lbl_settings_app_language.localize(),
                      choices: languageChoices,
                      selectedValue: currentLanguage.name,
                      onSelected: (String langName) {
                        final selectedLang = Language.values
                            .firstWhere((l) => l.name == langName);
                        // Tell EasyLocalization to update the app's language
                        controller.setLocale(selectedLang);
                      },
                      maxWidth: false,
                    ),
                  ),
                ),
                kGapMedium,

                // --- ABOUT ---
                _buildSectionHeader(LocaleKeys.lbl_settings_about.localize()),
                GlassContainer(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.lbl_app_name.localize(),
                            style: AppTextStyles.h4.bold),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                              '${LocaleKeys.lbl_settings_version.localize()} '
                              '${state.appVersion.value} '
                              '(${LocaleKeys.lbl_settings_build.localize()} '
                              '${state.buildNumber.value})',
                              style: AppTextStyles.b3.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.7),
                              ),
                            )),
                        const Divider(height: 32),
                        Text(
                          '© 2026 DevStack Flutter. All rights reserved.',
                          style: AppTextStyles.b3.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingSmall),
      child: Text(
        title,
        style: AppTextStyles.b1.bold,
      ),
    );
  }
}
