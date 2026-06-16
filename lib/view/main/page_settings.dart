import 'package:devstack/generated/icon_keys.g.dart';
import 'package:devstack/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:url_launcher/url_launcher.dart';

import '../../generated/locale_keys.g.dart';

class SettingsPage
    extends BaseBottomSheetView<SettingsController, SettingsState> {
  SettingsPage({super.key, super.viewTag, super.bindingCreator});

  @override
  Widget view(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radiusExtraLarge),
          topRight: Radius.circular(AppDimens.radiusExtraLarge),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.only(
        top: AppDimens.paddingTiny,
      ),
      clipBehavior: Clip.hardEdge,
      height: (MediaQuery.sizeOf(context).height -
              MediaQuery.paddingOf(context).vertical) *
          0.8,
      child: Builder(
        builder: (context) {
          // Generate language choices dynamically from your Language enum
          final Map<String, String> languageChoices = Map.fromEntries(
            Language.values.map((lang) => MapEntry(lang.name, lang.display)),
          );

          // Get current language based on EasyLocalization context
          final currentLanguage = Language.values.firstWhere(
            (l) => l.locale == context.locale,
            orElse: () => Language.english,
          );

          final Map<String, String> themeChoices = {
            'system': LocaleKeys.lbl_settings_theme_default.localize(),
            'light': LocaleKeys.lbl_settings_theme_light.localize(),
            'dark': LocaleKeys.lbl_settings_theme_dark.localize(),
          };

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                LocaleKeys.lbl_settings_title.localize(),
                style: AppTextStyles.b1.bold,
              ),
              backgroundColor: Colors.transparent,
              scrolledUnderElevation: 0.0,
              automaticallyImplyLeading: false,
              leading: InkWell(
                onTap: () => app.back(),
                child: Container(
                  height: 32,
                  // width: 32,
                  margin: const EdgeInsets.all(AppDimens.marginSmaller),
                  child: AppImage(
                    IconKeys.back,
                    // fit: BoxFit.scaleDown,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppDimens.paddingMedium,
                right: AppDimens.paddingMedium,
                top: AppDimens.paddingMedium,
                bottom: AppDimens.paddingSmall +
                    MediaQuery.paddingOf(context).bottom,
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

                          // --- NEW: DEVTOYS CREDIT ---
                          Text(
                            LocaleKeys.lbl_settings_copyright.localize(),
                            style: AppTextStyles.b2
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          kGapTiny,
                          InkWell(
                            onTap: () {
                              launchUrl(
                                Uri.parse('https://github.com/veler/DevToys'),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text(
                              'https://github.com/veler/DevToys',
                              style: AppTextStyles.b3.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          kGapMedium,

                          // --- NEW: OPEN SOURCE LICENSES BUTTON ---
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                showLicensePage(
                                  context: context,
                                  applicationName:
                                      LocaleKeys.lbl_app_name.localize(),
                                  applicationVersion: state.appVersion.value,
                                  applicationLegalese:
                                      '© 2026 DevStack Flutter. '
                                      '${LocaleKeys.lbl_settings_all_rights_reserved.localize()}',
                                );
                              },
                              icon: const Icon(Icons.description_outlined,
                                  size: 18),
                              label: Text(
                                  LocaleKeys.lbl_settings_licence.localize()),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          kGapLarge,

                          Text(
                            '© 2026 DevStack Flutter. '
                            '${LocaleKeys.lbl_settings_all_rights_reserved.localize()}',
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
      ),
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
