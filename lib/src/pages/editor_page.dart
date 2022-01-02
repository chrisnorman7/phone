/// Provides the [EditorPage] class.
import 'package:characters/characters.dart';

import '../../alphabets.dart';
import '../../enumerations.dart';
import '../../main_loop.dart';
import '../ui/input_handler.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';

/// A page for editing text.
class EditorPage implements InputHandler {
  /// Create an instance.
  EditorPage({
    required this.onDone,
    String initialText = '',
    this.label,
    int? cursorPosition,
    this.mode = TypingMode.upperCase,
    this.onCancel,
  })  : text = Characters(initialText),
        lastLetterIndex = -1 {
    this.cursorPosition = cursorPosition ?? text.length;
  }

  /// The function to call when the enter key is pressed.
  final Future<void> Function(String text) onDone;

  /// The text that will be edited.
  Characters text;

  /// The label for this editor.
  ///
  /// If no label is given, then the current character will be spoken when the
  /// editor is pushed. Otherwise, this value will be used.
  final LabelType? label;

  /// The cursor position.
  ///
  /// If this value is equal to the length of [text], then the focus will be at
  /// the end of the text.
  late int cursorPosition;

  /// The current editing mode.
  TypingMode mode;

  /// What to do when the cancel key is pressed.
  final OnCancelType? onCancel;

  /// The last key to be pressed.
  KeyEvent? lastKey;

  /// The index of the last chosen letter.
  int lastLetterIndex;

  /// Handle keys.
  @override
  Future<void> handleKeyEvent(KeyEvent event, MainLoop mainLoop) async {
    final oldKey = lastKey;
    if (oldKey != null && event != oldKey) {
      var letter = letters[oldKey]![lastLetterIndex];
      if (mode == TypingMode.upperCase) {
        letter = letter.toUpperCase();
      }
      addString(letter);
      if (event != KeyEvent.enter) {
        await mainLoop.speak(letter, interrupt: false);
      }
      resetTypingState();
    }
    switch (event) {
      case KeyEvent.left:
        await moveCursor(mainLoop, -1);
        break;
      case KeyEvent.right:
        await moveCursor(mainLoop, 1);
        break;
      case KeyEvent.enter:
        await onDone(text.string);
        break;
      case KeyEvent.cancel:
        await cancel(mainLoop);
        break;
      case KeyEvent.backspace:
        await backspace(mainLoop);
        break;
      default:
        if (event == KeyEvent.mode) {
          await switchMode(mainLoop);
        } else {
          await typeLetter(mainLoop, event);
        }
    }
  }

  @override
  Future<void> onPop(MainLoop mainLoop) async {}

  @override
  Future<void> onPush(MainLoop mainLoop) async {
    final f = label;
    if (f != null) {
      await mainLoop.speak(f());
    } else {
      await speakCharacter(mainLoop);
    }
  }

  @override
  Future<void> onReveal(MainLoop mainLoop, InputHandler covering) async {
    await onPush(mainLoop);
  }

  /// Speak the character at the current [cursorPosition].
  Future<void> speakCharacter(MainLoop mainLoop) async {
    final String letter;
    if (cursorPosition == text.length) {
      letter = 'blank';
    } else {
      letter = text.characterAt(cursorPosition).string;
    }
    await mainLoop.speak(letter);
  }

  /// Insert the given string [s] at the current position.
  void addString(String s) {
    if (cursorPosition >= text.length) {
      text = Characters(text.string + s);
    } else {
      text = Characters(text.getRange(0, cursorPosition).string +
          s +
          text.getRange(cursorPosition).string);
    }
    cursorPosition += 1;
  }

  /// Cycle through letters for the given [key].
  Future<void> typeLetter(MainLoop mainLoop, KeyEvent key) async {
    if (mode == TypingMode.numbers) {
      resetTypingState();
      final letter = numbers[key]!;
      addString(letter);
      await mainLoop.speak(letter);
    } else {
      var possible = letters[key]!;
      if (mode == TypingMode.upperCase) {
        possible = possible.toUpperCase();
      }
      var index = lastLetterIndex + 1;
      if (index >= possible.length) {
        index = 0;
      }
      lastKey = key;
      lastLetterIndex = index;
      await mainLoop.speak(possible[index]);
    }
  }

  /// Move the cursor.
  Future<void> moveCursor(MainLoop mainLoop, int direction) async {
    cursorPosition += direction;
    if (cursorPosition < 0) {
      cursorPosition = 0;
    } else if (cursorPosition > text.length) {
      cursorPosition = text.length;
    }
    await speakCharacter(mainLoop);
  }

  /// Call the [onCancel] function if necessary.
  Future<void> cancel(MainLoop mainLoop) async {
    final f = onCancel;
    if (f != null) {
      await f(mainLoop);
    }
  }

  /// Reset typing state.
  void resetTypingState() {
    lastKey = null;
    lastLetterIndex = -1;
  }

  /// Switch through [mode]s.
  Future<void> switchMode(MainLoop mainLoop) async {
    resetTypingState();
    final String message;
    switch (mode) {
      case TypingMode.upperCase:
        mode = TypingMode.lowerCase;
        message = 'Lower case';
        break;
      case TypingMode.numbers:
        mode = TypingMode.upperCase;
        message = 'Upper case';
        break;
      case TypingMode.lowerCase:
        mode = TypingMode.numbers;
        message = 'Numbers';
        break;
    }
    await mainLoop.speak(message);
  }

  /// Delete the previous letter.
  Future<void> backspace(MainLoop mainLoop) async {
    final String message;
    if (cursorPosition == 0) {
      message = 'Blank';
    } else if (cursorPosition == text.length) {
      message = text.last;
      text = text.getRange(0, text.length - 1);
      cursorPosition -= 1;
    } else if (cursorPosition == 1) {
      message = text.characterAt(0).string;
      text = text.getRange(1);
      cursorPosition -= 1;
    } else {
      message = text.characterAt(cursorPosition - 1).string;
      text = text.getRange(0, cursorPosition - 1) +
          text.getRange(cursorPosition, text.length);
      cursorPosition -= 1;
    }
    await mainLoop.speak(message);
  }
}
