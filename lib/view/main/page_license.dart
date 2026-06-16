import 'package:devstack/generated/icon_keys.g.dart';
import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/locale_keys.g.dart';

class CustomLicensePage
    extends BaseView<CustomLicenseController, CustomLicenseState> {
  const CustomLicensePage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        title: Text(
          LocaleKeys.lbl_settings_licence.localize(),
          style: AppTextStyles.b1.bold,
        ),
        leading: InkWell(
          onTap: () {
            // Obx removed here: just access the value directly for the logic check
            if (MediaQuery.sizeOf(context).width < 800 &&
                state.selectedPackage.value != null) {
              state.selectedPackage.value = null;
            } else {
              app.back();
            }
          },
          child: AppImage(
            IconKeys.back,
            size: 20,
            color: Theme.of(context).iconTheme.color,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),

      // Top level Obx only cares about the loading spinner now
      body: Obx(() {
        if (state.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 800;

            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 280,
                    child: _buildPackageList(isDesktop: true),
                  ),
                  Container(
                    width: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  Expanded(
                    child: _buildLicenseDetails(),
                  ),
                ],
              );
            } else {
              // We need an Obx here so the mobile view knows to switch between the list and details
              return Obx(() {
                return state.selectedPackage.value == null
                    ? _buildPackageList(isDesktop: false)
                    : _buildLicenseDetails();
              });
            }
          },
        );
      }),
    ).marginOnly(
      top: app.state.platform.value.windowControlOffset,
    );
  }

  // --- LEFT PANEL: The List of Packages ---
  Widget _buildPackageList({required bool isDesktop}) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      itemCount: state.packages.length,
      itemBuilder: (context, index) {
        final package = state.packages[index];

        return Obx(() {
          final activePackage = state.selectedPackage.value;
          final isSelected = isDesktop && activePackage == package;

          return InkWell(
            onTap: () {
              state.selectedPackage.value = package;
            },
            child: Container(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMedium,
                vertical: AppDimens.paddingSmall,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      package.packageName,
                      style: AppTextStyles.b2.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  Text(
                    '${package.licenses.length}',
                    style: AppTextStyles.b3.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildLicenseDetails() {
    // --- CRITICAL FIX 3: Wrap the details panel in Obx ---
    return Obx(() {
      final package = state.selectedPackage.value;
      if (package == null) {
        return const SizedBox.shrink();
      }

      return Scrollbar(
        // --- CRITICAL FIX 1: Attach Controller to BOTH widgets ---
        controller: controller.scrollController,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                package.packageName,
                style: AppTextStyles.h3.bold,
              ),
              kGapSmall,
              Text(
                '${package.licenses.length} License(s) found',
                style: AppTextStyles.b3.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Divider(height: 32),
              ...package.licenses.expand((license) {
                return license.paragraphs.map((paragraph) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left:
                          paragraph.indent < 0 ? 0.0 : paragraph.indent * 16.0,
                      bottom: AppDimens.paddingSmall,
                    ),
                    child: Text(
                      paragraph.text,
                      style: AppTextStyles.b3.copyWith(
                        fontFamily: 'monospace',
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.8),
                      ),
                    ),
                  );
                });
              }),
            ],
          ),
        ),
      );
    });
  }
}
