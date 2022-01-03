/// Provides the [WidgetPage ] class.
import 'package:characters/characters.dart';
import 'package:logging/logging.dart';

import '../../constants.dart';
import '../../enumerations.dart';
import '../../main_loop.dart';
import 'input_handler.dart';
import 'label.dart';
import 'widgets/widget.dart';

/// The type of the [WidgetPage.onCancel] function.
typedef MainLoopCallback = Future<void> Function(MainLoop mainLoop);

/// The type for all information key callbacks.
typedef InfoKeyCallback = void Function(MainLoop mainLoop);

/// A class to hold (and navigate through) a list of [Widget]s.
class WidgetPage implements InputHandler {
  /// Create an instance.
  WidgetPage({
    required this.label,
    required this.widgets,
    this.onCancel,
    String loggerName = 'Untitled Page',
  })  : logger = Logger(loggerName),
        navigationMode = NavigationMode.standard,
        infoModeKeys = {} {
    infoModeKeys[KeyEvent.key0] = showCurrentTime;
    infoModeKeys[KeyEvent.mode] = (mainLoop) async {
      navigationMode = NavigationMode.standard;
      await mainLoop.speak('Navigation mode.');
    };
  }

  /// The label for this list.
  final LabelType label;

  /// The widgets in this list.
  final List<Widget> widgets;

  /// The function that is called to cancel this list.
  ///
  /// If this value is `null`, then some other mechanism will have to be used
  /// for cancelling this menu.
  final MainLoopCallback? onCancel;

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

  /// Speak the title and number of widgets.
  @override
  Future<void> onPush(MainLoop mainLoop) => showCurrentWidget(mainLoop);

  /// This method does nothing.
  @override
  Future<void> onPop(MainLoop mainLoop) async {}

  /// Show the current widget.
  @override
  Future<void> onReveal(MainLoop mainLoop, InputHandler covering) =>
      showCurrentWidget(mainLoop);

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
      String items = 'with ${widgets.length} item';
      if (widgets.length != 1) {
        items += 's';
      }
      labelText = '${label()} $items';
    } else {
      labelText = widget.label();
    }
    await mainLoop.speak(labelText);
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
    } else if (index < (widgets.length - 1)) {
      _index = index + 1;
    }
    await showCurrentWidget(mainLoop);
  }

  /// Activate the current widget.
  Future<void> activate(MainLoop mainLoop) async {
    final onActivate = currentWidget?.onActivate;
    if (onActivate != null) {
      await onActivate(mainLoop);
    }
  }

  /// Show the current time.
  Future<void> showCurrentTime(MainLoop mainLoop) async {
    final now = DateTime.now();
    await mainLoop.speak(dateTimeFormatter.format(now));
  }

  /// Handle a key event.
  @override
  Future<void> handleKeyEvent(KeyEvent event, MainLoop mainLoop) async {
    if (navigationMode == NavigationMode.standard) {
      logger.info('Handle key $event.');
      switch (event) {
        case KeyEvent.cancel:
          final f = onCancel;
          if (f != null) {
            await f(mainLoop);
          }
          break;
        case KeyEvent.enter:
          await activate(mainLoop);
          break;
        case KeyEvent.left:
          await moveLeft(mainLoop);
          break;
        case KeyEvent.right:
          await moveRight(mainLoop);
          break;
        case KeyEvent.mode:
          navigationMode = NavigationMode.info;
          await mainLoop.speak('Information mode. Press again to exit.');
          break;
        default:
          final widget = currentWidget;
          if (widget != null && widget.handledKeys.containsKey(event)) {
            await widget.handledKeys[event]!(mainLoop);
          } else if (event == KeyEvent.key2) {
            _index = 0;
            await showCurrentWidget(mainLoop);
          } else if (event == KeyEvent.key8) {
            _index = widgets.length - 1;
            await showCurrentWidget(mainLoop);
          } else if (event == KeyEvent.key4) {
            var index = _index;
            if (index != null) {
              final startLetter = widgets[index]
                  .label()
                  .toLowerCase()
                  .characters
                  .characterAt(0);
              while (index! >= 0 &&
                  widgets[index]
                          .label()
                          .toLowerCase()
                          .characters
                          .characterAt(0) ==
                      startLetter) {
                index -= 1;
                _index = index;
              }
              await showCurrentWidget(mainLoop);
            }
          } else if (event == KeyEvent.key6) {
            var index = _index;
            if (index != null) {
              final startLetter =
                  widgets[index].label().characters.characterAt(0);
              while (true) {
                index = index! + 1;
                if (index >= widgets.length) {
                  break;
                } else if (widgets[index]
                    .label()
                    .characters
                    .startsWith(startLetter)) {
                  continue;
                } else {
                  _index = index;
                  await showCurrentWidget(mainLoop);
                  break;
                }
              }
            }
          } else {
            logger.info('Unhandled event $event.');
          }
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
