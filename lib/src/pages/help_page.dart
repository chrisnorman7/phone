/// Provides the [HelpPage] class.
import 'dart:async';

import '../../enumerations.dart';
import '../../letters.dart';
import '../../main_loop.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';

/// A help page.
///
/// This page is used for speaking the functions of the keys that are
/// recognised by the system.
class HelpPage extends WidgetPage {
  /// Create an instance.
  HelpPage()
      : _cancel = false,
        super(label: label('Press any key to hear its function.'), widgets: [
          for (final key in KeyEvent.values)
            Widget(label: label(key.toString()))
        ]);

  /// Whether or not the cancel button has been pressed this round.
  bool _cancel;

  /// Speak key descriptions.
  @override
  Future<void> handleKeyEvent(
      {required KeyEvent event, required MainLoop mainLoop}) async {
    final String keyDescription;
    var characters = letters[event];
    if (characters != null) {
      characters = [
        for (final char in characters.split('')) char == ' ' ? 'space' : char
      ].join(' ');
      keyDescription = 'Used to type $characters';
    } else {
      switch (event) {
        case KeyEvent.backspace:
          keyDescription =
              'Backspace: Delete the previous letter in text fields.';
          break;
        case KeyEvent.cancel:
          if (_cancel == true) {
            return mainLoop.popPage();
          }
          keyDescription =
              'Cancel: Return to the previous menu in menus that can be '
              'cancelled. Press again to return to the main menu.';
          break;
        case KeyEvent.enter:
          keyDescription =
              'Enter: Click the selected control or enter a new line.';
          break;
        case KeyEvent.left:
          keyDescription = 'Left: Go to the previous letter or menu item.';
          break;
        case KeyEvent.mode:
          keyDescription = 'Mode: Change navigation or editing modes.';
          break;
        case KeyEvent.right:
          keyDescription = 'Right: Go to the next letter or menu item.';
          break;
        default:
          keyDescription = '$event: This key has no description.';
      }
    }
    _cancel = event == KeyEvent.cancel;
    await mainLoop.speak(keyDescription);
  }
}
