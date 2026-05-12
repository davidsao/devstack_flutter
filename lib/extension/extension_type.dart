import 'package:easy_localization/easy_localization.dart';

extension LocalizationExtension on String {
  String localize({List<String>? args, List<String>? sequenceArgs}) {
    var text = tr(this);
    if (RegExp(r'{@(\d)}').hasMatch(text) && sequenceArgs?.isNotEmpty == true) {
      /// @1, @2, @n... are defined from the string resources as sequence
      /// We use pre-set sequence instead of dynamic key-value structure here
      ///
      /// e.g. I go to {@1} by {@2} -> I go to school by bus
      ///      localize(sequenceArgs: [ "school", "bus" ]);
      /// It can be used with non-sequence args
      /// e.g. I go to {@1} by {} on {@2} -> I go to school by bus on Monday
      ///      localize(args: [ "bus" ], sequenceArgs: [ "school", "Monday" ]);
      Map<String, String> map = {};
      RegExp(r'{@(\d)}').allMatches(text).forEach((e) {
        final index = int.parse(e[1]!);
        map["@$index"] = sequenceArgs![index - 1];
      });
      return tr(this, namedArgs: map, args: args);
    } else if (args?.isNotEmpty == true) {
      /// default sequence is used here.
      /// e.g. I go to {} by {} -> I go to school by bus
      ///      localize(args: [ "school", "bus" ];
      return tr(this, args: args);
    } else {
      return text;
    }
  }

  String plurals(num number) {
    return plural(this, number, format: NumberFormat("###,###,###"));
  }
}
