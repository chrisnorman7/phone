import '../../constants.dart';
import '../../enumerations.dart';
import '../../main_loop.dart';
import '../ui/input_handler.dart';
import '../ui/widget_page.dart';

/// A widget for selecting a date.
class DatePicker implements InputHandler {
  /// Create an instance.
  DatePicker({
    required this.initialDateTime,
    required this.onDone,
    this.onCancel,
    this.minYear,
    this.maxYear,
    this.minMonth,
    this.maxMonth,
    this.minDay,
    this.maxDay,
  }) {
    dateTime = initialDateTime;
  }

  /// The initial date.
  final DateTime initialDateTime;

  /// The date time to work on.
  late DateTime dateTime;

  /// The minimum allowed year.
  final int? minYear;

  /// The maximum allowed year.
  final int? maxYear;

  /// THe minimum allowed month.
  final int? minMonth;

  /// The maximum allowed month.
  final int? maxMonth;

  /// The minimum allowed day.
  final int? minDay;

  /// The maximum allowed day.
  final int? maxDay;

  /// The function to call when the desired date is selected.
  final Future<void> Function(DateTime dateTime) onDone;

  /// What to do when the cancel key is pressed.
  final MainLoopCallback? onCancel;

  /// Allow changing the date.
  @override
  Future<void> handleKeyEvent(KeyEvent event, MainLoop mainLoop) async {
    switch (event) {
      case KeyEvent.key0:
        dateTime = DateTime(
          initialDateTime.year,
          initialDateTime.month,
          initialDateTime.day,
          initialDateTime.hour,
          initialDateTime.minute,
          initialDateTime.second,
          initialDateTime.millisecond,
          initialDateTime.microsecond,
        );
        await speakDate(mainLoop);
        break;
      case KeyEvent.key1:
        await years(mainLoop, 1);
        break;
      case KeyEvent.key2:
        await months(mainLoop, 1);
        break;
      case KeyEvent.key3:
        await days(mainLoop, 1);
        break;
      case KeyEvent.key4:
        await resetDateTime(mainLoop: mainLoop, year: initialDateTime.year);
        break;
      case KeyEvent.key5:
        await resetDateTime(mainLoop: mainLoop, month: initialDateTime.month);
        break;
      case KeyEvent.key6:
        await resetDateTime(mainLoop: mainLoop, day: initialDateTime.day);
        break;
      case KeyEvent.key7:
        await years(mainLoop, -1);
        break;
      case KeyEvent.key8:
        await months(mainLoop, -1);
        break;
      case KeyEvent.key9:
        await days(mainLoop, -1);
        break;
      case KeyEvent.enter:
        await onDone(dateTime);
        break;
      case KeyEvent.cancel:
        final f = onCancel;
        if (f != null) {
          await f(mainLoop);
        }
        break;
      default:
        break;
    }
  }

  /// Do nothing when this page is popped.
  @override
  Future<void> onPop(MainLoop mainLoop) async {}

  /// Speak the date when this page is pushed.
  @override
  Future<void> onPush(MainLoop mainLoop) => speakDate(mainLoop);

  /// Speak the date when this page is revealed.
  @override
  Future<void> onReveal(MainLoop mainLoop, InputHandler covering) =>
      onPop(mainLoop);

  /// Speak the current date.
  Future<void> speakDate(MainLoop mainLoop) {
    final text = dateFormatter.format(dateTime);
    return mainLoop.speak(text);
  }

  /// Reset the [dateTime].
  Future<void> resetDateTime({
    required MainLoop mainLoop,
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) async {
    dateTime = DateTime(
      year ?? dateTime.year,
      month ?? dateTime.month,
      day ?? dateTime.day,
      hour ?? dateTime.hour,
      minute ?? dateTime.minute,
      second ?? dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
    await speakDate(mainLoop);
  }

  /// Change the year.
  Future<void> years(MainLoop mainLoop, int difference) {
    var year = dateTime.year + difference;
    final min = minYear;
    if (min != null && year < min) {
      year = min;
    }
    final max = maxYear;
    if (max != null && year > max) {
      year = max;
    }
    return resetDateTime(mainLoop: mainLoop, year: year);
  }

  /// Change the month.
  Future<void> months(MainLoop mainLoop, int difference) {
    var month = dateTime.month + difference;
    final min = minMonth;
    if (min != null && month < min) {
      month = min;
    }
    final max = maxMonth;
    if (max != null && month > max) {
      month = max;
    }
    return resetDateTime(mainLoop: mainLoop, month: month);
  }

  /// Change the day.
  Future<void> days(MainLoop mainLoop, int difference) {
    var day = dateTime.day + difference;
    final min = minDay;
    if (min != null && day < min) {
      day = min;
    }
    final max = maxDay;
    if (max != null && day > max) {
      day = max;
    }
    return resetDateTime(mainLoop: mainLoop, day: day);
  }
}
