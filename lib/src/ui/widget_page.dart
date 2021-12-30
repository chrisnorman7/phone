/// Provides the [WidgetPage] class.
import 'dart:math';

import 'package:logging/logging.dart';

import '../../enumerations.dart';
import '../../main_loop.dart';
import 'label.dart';
import 'widgets/widget.dart';

/// The type of the [WidgetPage.onCancel] function.
typedef OnCancelType = void Function(MainLoop mainLoop);

/// The type for all information key callbacks.
typedef InfoKeyCallback = void Function(MainLoop mainLoop);

/// A class to hold (and navigate through) a list of [Widget]s.
class WidgetPage {
  /// Create an instance.
  WidgetPage(
      {required this.label,
      required this.widgets,
      this.onCancel,
      String loggerName = 'Untitled Widget List'})
      : logger = Logger(loggerName),
        navigationMode = NavigationMode.standard,
        infoModeKeys = {} {
    infoModeKeys[KeyEvent.key0] = showCurrentTime;
  }

  /// The label for this list.
  final LabelType label;

  /// The widgets in this list.
  final List<Widget> widgets;

  /// The function that is called to cancel this list.
  ///
  /// If this value is `null`, then some other mechanism will have to be used
  /// for cancelling this menu.
  final OnCancelType? onCancel;

  /// The current index in the list.
  ///
  /// If this value is `null`, then the [label] will be shown.
  int? _index;

  /// The logger to use for this instance.
  final Logger logger;

  /// The current navigation mode.
  NavigationMode navigationMode;

  /// The map of registered information keys.
  final Map<KeyEvent, InfoKeyCallback> infoModeKeys;

  /// Get the current widget.
  ///
  /// If this value returns `null`, then the [label] should be shown.
  Widget? get currentWidget {
    final index = _index;
    if (index == null) {
      return null;
    }
    return widgets.elementAt(index);
  }

  /// Show the current item.
  Future<void> showCurrentWidget(MainLoop mainLoop) async {
    final widget = currentWidget;
    final String labelText;
    if (widget == null) {
      String items = ' with ${widgets.length} item';
      if (widgets.length != 1) {
        items += 's';
      }
      labelText = '${label()} $items';
    } else {
      labelText = widget.label();
    }
    await mainLoop.speechEngine.speak(labelText);
  }

  /// Move up in the [widgets] list.
  Future<void> moveLeft(MainLoop mainLoop) async {
    final index = _index;
    if (index == 0) {
      _index = null;
    } else if (index != null) {
      _index = index - 1;
    }
    await showCurrentWidget(mainLoop);
  }

  /// Move down in the [widgets] list.
  Future<void> moveRight(MainLoop mainLoop) async {
    final index = _index;
    if (index == null) {
      _index = 0;
    } else if (index < widgets.length) {
      _index = min(index, index + 1);
    }
    await showCurrentWidget(mainLoop);
  }

  /// Activate the current widget.
  void activate(MainLoop mainLoop) {
    final onActivate = currentWidget?.onActivate;
    if (onActivate != null) {
      onActivate(mainLoop);
    }
  }

  /// Show the current time.
  Future<void> showCurrentTime(MainLoop mainLoop) async {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final month = [
      'Months start from 1',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ].elementAt(now.month);
    final weekDay = [
      'Week days start at 1',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ].elementAt(now.weekday);
    final dayString = now.day.toString();
    final String day;
    if ([11, 12, 13].contains(now.day)) {
      day = '${now.day}th';
    } else if (dayString.endsWith('1')) {
      day = '${dayString}st';
    } else if (dayString.endsWith('2')) {
      day = '${dayString}nd';
    } else if (dayString.endsWith('3')) {
      day = '${dayString}rd';
    } else {
      day = '${dayString}th';
    }
    await mainLoop.speechEngine
        .speak('$hour:$minute on $weekDay $month $day ${now.year}.');
  }

  /// Handle a key event.
  void handleKeyEvent({required KeyEvent event, required MainLoop mainLoop}) {
    if (navigationMode == NavigationMode.standard) {
      logger.info('Handle key $event.');
      switch (event) {
        case KeyEvent.cancel:
          final f = onCancel;
          if (f != null) {
            f(mainLoop);
          }
          break;
        case KeyEvent.enter:
          activate(mainLoop);
          break;
        case KeyEvent.left:
          moveLeft(mainLoop);
          break;
        case KeyEvent.right:
          moveRight(mainLoop);
          break;
        case KeyEvent.mode:
          if (navigationMode == NavigationMode.standard) {
            navigationMode = NavigationMode.info;
            mainLoop.speechEngine
                .speak('Information mode. Press again to exit.');
          } else {
            navigationMode = NavigationMode.standard;
            mainLoop.speechEngine.speak('Navigation mode.');
          }
          break;
        default:
          logger.info('Unhandled event $event.');
      }
    } else {
      final callback = infoModeKeys[event];
      if (callback == null) {
        logger.warning('Info key $event is unregistered.');
      } else {
        callback(mainLoop);
      }
      if (mainLoop.options.navigationModeSticky) {
        navigationMode = NavigationMode.standard;
      }
    }
  }
}
