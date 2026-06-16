import 'package:devstack/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // NEW: Required for ScrollController
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class PackageLicense {
  final String packageName;
  final List<LicenseEntry> licenses;

  PackageLicense(this.packageName, this.licenses);
}

class CustomLicenseController extends BaseController<CustomLicenseState> {
  final ScrollController scrollController = ScrollController();

  @override
  CustomLicenseState initState() => CustomLicenseState();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadLicenses();
  }

  @override
  void onClose() {
    scrollController.dispose(); // Don't forget to clean up!
    super.onClose();
  }

  Future<void> _loadLicenses() async {
    final Map<String, List<LicenseEntry>> packagesMap = {};

    await for (final license in LicenseRegistry.licenses) {
      for (final package in license.packages) {
        packagesMap.putIfAbsent(package, () => []).add(license);
      }
    }

    final sortedNames = packagesMap.keys.toList()..sort();
    final parsedPackages = sortedNames
        .map((name) => PackageLicense(name, packagesMap[name]!))
        .toList();

    state.packages.value = parsedPackages;
    if (parsedPackages.isNotEmpty) {
      state.selectedPackage.value = parsedPackages.first;
    }
    state.isLoading.value = false;
  }
}

class CustomLicenseState extends ViewState {
  RxList<PackageLicense> packages = <PackageLicense>[].obs;
  Rxn<PackageLicense> selectedPackage = Rxn<PackageLicense>();
  RxBool isLoading = true.obs;
}

class CustomLicenseBinding extends AppBindings<CustomLicenseController> {
  CustomLicenseBinding({required super.tag});

  final getIt = GetIt.instance;

  @override
  get controller => CustomLicenseController();
}
