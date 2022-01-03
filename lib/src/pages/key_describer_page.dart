/// Provides the [KeyDescriberPage] class.
import 'dart:async';

import '../../alphabets.dart';
import '../../enumerations.dart';
import '../../main_loop.dart';
import '../ui/input_handler.dart';

/// A help page.
///
/// This page is used for speaking the functions of the keys that are
/// recognised by the system.
class KeyDescriberPage implements InputHandler {
  /// Create an instance.
  KeyDescriberPage() : _cancel = false;

  /// Whether or not the cancel button has been pressed this round.
  bool _cancel;

  /// Speak the instructions.
  @override
  Future<void> onPush(MainLoop mainLoop) => mainLoop.speak(
      'Press keys to hear their descriptions. Press cancel twice to exit.');

  /// Do nothing.
  @override
  Future<void> onPop(MainLoop mainLoop) async {}

  /// Speak instructions.
  @override
  Future<void> onReveal(MainLoop mainLoop, InputHandler covering) =>
      onPush(mainLoop);

  /// Speak key descriptions.
  @override
  Future<void> handleKeyEvent(KeyEvent event, MainLoop mainLoop) async {
    final String keyDescription;
    var characters = letters[event];
    if (characters != null) {
      characters = [
        for (final char in characters.split(''))
          char == ' ' ? 'space' : (char == '\n' ? 'line break' : char)
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
          keyDescription = 'Enter: Click the selected control or submit text.';
          break;
        case KeyEvent.left:
          keyDescription =
              'Arrow left: Go to the previous letter or menu item.';
          break;
        case KeyEvent.mode:
          keyDescription = 'Mode: Change navigation or editing modes.';
          break;
        case KeyEvent.right:
          keyDescription = 'Arrow right: Go to the next letter or menu item.';
          break;
        default:
          keyDescription = '$event: This key has no description.';
      }
    }
    _cancel = event == KeyEvent.cancel;
    await mainLoop.speak(keyDescription);
  }
}
