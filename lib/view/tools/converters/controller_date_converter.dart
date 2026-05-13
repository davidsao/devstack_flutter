import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DateConverterController extends BaseController<DateConverterState> {
  // Text Controllers
  final timestampController = TextEditingController();
  final yearController = TextEditingController();
  final monthController = TextEditingController();
  final dayController = TextEditingController();
  final hourController = TextEditingController();
  final minuteController = TextEditingController();
  final secondController = TextEditingController();

  // Flag to prevent infinite loops when updating fields programmatically
  bool _isUpdatingFields = false;

  @override
  DateConverterState initState() => DateConverterState();

  @override
  Future<void> onInit() async {
    super.onInit();
    setNow();

    // Add listeners to date component fields
    final components = [
      yearController,
      monthController,
      dayController,
      hourController,
      minuteController,
      secondController
    ];
    for (var ctrl in components) {
      ctrl.addListener(_updateFromComponents);
    }
  }

  @override
  void onClose() {
    timestampController.dispose();
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    super.onClose();
  }

  // --- ACTIONS ---

  void setNow() {
    _updateStateAndFields(DateTime.now().toUtc());
  }

  Future<void> pasteTimestamp() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      timestampController.text = data.text!;
      updateFromTimestamp(data.text!);
    }
  }

  void copyTimestamp() {
    Clipboard.setData(ClipboardData(text: timestampController.text));
  }

  void updateFromTimestamp(String val) {
    if (_isUpdatingFields || val.isEmpty) return;
    int? seconds = int.tryParse(val);
    if (seconds != null) {
      final newTime =
          DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
      _updateStateAndFields(newTime, skipTimestamp: true);
    }
  }

  void _updateFromComponents() {
    if (_isUpdatingFields) return;

    try {
      int y = int.parse(yearController.text);
      int m = int.parse(monthController.text);
      int d = int.parse(dayController.text);
      int h = int.parse(hourController.text);
      int min = int.parse(minuteController.text);
      int s = int.parse(secondController.text);

      // The user is typing the time in their selected local offset
      DateTime localInput = DateTime.utc(y, m, d, h, min, s);
      // Convert it back to pure UTC
      DateTime trueUtc = localInput.subtract(state.timeZoneOffset.value);

      _updateStateAndFields(trueUtc, skipComponents: true);
    } catch (e) {
      // Ignore incomplete formats while typing
    }
  }

  // Core synchronization method
  void _updateStateAndFields(DateTime newUtc,
      {bool skipTimestamp = false, bool skipComponents = false}) {
    _isUpdatingFields = true;
    state.currentUtcTime.value = newUtc;

    if (!skipTimestamp) {
      timestampController.text =
          (newUtc.millisecondsSinceEpoch ~/ 1000).toString();
    }

    if (!skipComponents) {
      // Calculate local time based on the selected offset
      DateTime localTime = newUtc.add(state.timeZoneOffset.value);
      yearController.text = localTime.year.toString();
      monthController.text = localTime.month.toString();
      dayController.text = localTime.day.toString();
      hourController.text = localTime.hour.toString();
      minuteController.text = localTime.minute.toString();
      secondController.text = localTime.second.toString();
    }

    // REMOVED: state.choices.addAll(...) which was breaking the dropdown options

    _isUpdatingFields = false;
  }

  // --- FORMATTING HELPERS FOR UI ---

  String get formattedOffset {
    Duration offset = state.timeZoneOffset.value;
    String sign = offset.isNegative ? '-' : '+';
    int hours = offset.inHours.abs();
    int minutes = (offset.inMinutes.abs() % 60);
    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String formatDate(DateTime time) {
    return '${time.year}/${time.month.toString().padLeft(2, '0')}/${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  String get localDateTimeString {
    return formatDate(
        state.currentUtcTime.value.add(state.timeZoneOffset.value));
  }

  String get utcDateTimeString {
    return formatDate(state.currentUtcTime.value);
  }

  String get utcTicks {
    // DevToys uses C# ticks: 100-nanosecond intervals since 0001-01-01
    // Epoch is 621,355,968,000,000,000 ticks
    int msSinceEpoch = state.currentUtcTime.value.millisecondsSinceEpoch;
    return ((msSinceEpoch * 10000) + 621355968000000000).toString();
  }
}

class DateConverterState extends ViewState {
  // We store the absolute moment in time in UTC
  final currentUtcTime = DateTime.now().toUtc().obs;

  // Active timezone details
  final timeZoneOffset = DateTime.now().timeZoneOffset.obs;
  final timeZoneName = 'Local System Time'.obs;
  final isDst = false.obs;

  late final RxMap<String, String> choices;

  DateConverterState() {
    // Determine the system's actual local offset only ONCE upon initialization
    Duration sysOffset = DateTime.now().timeZoneOffset;
    String sign = sysOffset.isNegative ? '-' : '+';
    int hours = sysOffset.inHours.abs();
    int minutes = (sysOffset.inMinutes.abs() % 60);
    String sysFormattedOffset =
        '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    // Populate the dropdown choices statically based on true system time
    choices = <String, String>{
      'Local System Time': '(UTC$sysFormattedOffset) Local System Time',
      'UTC': '(UTC+00:00) Coordinated Universal Time',
    }.obs;
  }
}

class DateConverterBinding extends AppBindings<DateConverterController> {
  DateConverterBinding({required super.tag});

  @override
  get controller {
    return DateConverterController();
  }
}
