import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

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

    // 1. Initialize the global IANA timezone database
    tz_data.initializeTimeZones();

    // 2. Load all timezones into the dropdown
    _populateTimezones();

    // 3. Set to current time
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

  // --- TIMEZONE SETUP ---

  void _populateTimezones() {
    final map = <String, String>{};

    // Add Local System Time at the top
    Duration sysOffset = DateTime.now().timeZoneOffset;
    map['Local System Time'] =
        '(UTC${_formatOffset(sysOffset)}) Local System Time';

    // Add UTC explicitly
    map['UTC'] = '(UTC+00:00) UTC';

    // Add all global timezones from the database
    final locations = tz.timeZoneDatabase.locations;
    final nowMs = DateTime.now().toUtc().millisecondsSinceEpoch;

    // Sort names alphabetically
    final sortedKeys = locations.keys.toList()..sort();

    for (final locName in sortedKeys) {
      if (locName == 'UTC') continue; // Skip duplicate UTC

      final loc = locations[locName]!;
      // Calculate the specific offset for this location right now
      final tzTime = tz.TZDateTime.fromMillisecondsSinceEpoch(loc, nowMs);
      map[locName] = '(UTC${_formatOffset(tzTime.timeZoneOffset)}) $locName';
    }

    state.choices.value = map;
  }

  void changeTimeZone(String val) {
    state.timeZoneName.value = val;
    // Force sync the fields to calculate the new offset and DST status for this timezone
    _updateStateAndFields(state.currentUtcTime.value, skipTimestamp: true);
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

      DateTime trueUtc;

      // Smart Parsing: Convert the typed local components accurately into UTC
      // (This handles DST boundary jumps perfectly!)
      if (state.timeZoneName.value == 'Local System Time') {
        trueUtc = DateTime(y, m, d, h, min, s).toUtc();
      } else {
        final loc = tz.getLocation(state.timeZoneName.value);
        trueUtc = tz.TZDateTime(loc, y, m, d, h, min, s).toUtc();
      }

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

    // 1. Calculate the precise local time and DST status for the selected zone
    DateTime localTime;
    if (state.timeZoneName.value == 'Local System Time') {
      localTime = newUtc.toLocal();
      state.isDst.value = false;
    } else {
      final loc = tz.getLocation(state.timeZoneName.value);
      final tzTime = tz.TZDateTime.from(newUtc, loc);
      localTime = tzTime;
      final timeZoneInfo = loc.timeZone(newUtc.millisecondsSinceEpoch);
      state.isDst.value = timeZoneInfo.isDst;
    }

    state.timeZoneOffset.value = localTime.timeZoneOffset;

    // 2. Update Timestamp
    if (!skipTimestamp) {
      timestampController.text =
          (newUtc.millisecondsSinceEpoch ~/ 1000).toString();
    }

    // 3. Update Text Fields
    if (!skipComponents) {
      yearController.text = localTime.year.toString();
      monthController.text = localTime.month.toString();
      dayController.text = localTime.day.toString();
      hourController.text = localTime.hour.toString();
      minuteController.text = localTime.minute.toString();
      secondController.text = localTime.second.toString();
    }

    _isUpdatingFields = false;
  }

  // --- FORMATTING HELPERS FOR UI ---

  String _formatOffset(Duration offset) {
    String sign = offset.isNegative ? '-' : '+';
    int hours = offset.inHours.abs();
    int minutes = (offset.inMinutes.abs() % 60);
    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String get formattedOffset => _formatOffset(state.timeZoneOffset.value);

  String formatDate(DateTime time) {
    return '${time.year}/${time.month.toString().padLeft(2, '0')}/${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  String get localDateTimeString {
    // Return the accurately calculated time based on offset
    return formatDate(
        state.currentUtcTime.value.add(state.timeZoneOffset.value));
  }

  String get utcDateTimeString {
    return formatDate(state.currentUtcTime.value);
  }

  String get utcTicks {
    // DevToys uses C# ticks: 100-nanosecond intervals since 0001-01-01
    int msSinceEpoch = state.currentUtcTime.value.millisecondsSinceEpoch;
    return ((msSinceEpoch * 10000) + 621355968000000000).toString();
  }
}

class DateConverterState extends ViewState {
  final currentUtcTime = DateTime.now().toUtc().obs;
  final timeZoneOffset = DateTime.now().timeZoneOffset.obs;
  final timeZoneName = 'Local System Time'.obs;
  final isDst = false.obs;
  final choices = <String, String>{}.obs;
}

class DateConverterBinding extends AppBindings<DateConverterController> {
  DateConverterBinding({required super.tag});
  @override
  get controller => DateConverterController();
}
