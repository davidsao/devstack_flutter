enum Flavor {
  dev,
  qa,
  uat,
  prod;

  static Flavor fromString(String text) {
    switch (text) {
      case "dev":
        return Flavor.dev;
      case "qa":
        return Flavor.qa;
      case "uat":
        return Flavor.uat;
      default:
        return Flavor.prod;
    }
  }
}

extension FlavorsExtension on Flavor {
  String get flavor {
    switch (this) {
      case Flavor.dev:
        return "dev";
      case Flavor.qa:
        return "qa";
      case Flavor.uat:
        return "uat";
      case Flavor.prod:
        return "";
    }
  }
}
