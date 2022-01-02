import 'package:characters/characters.dart';
import 'package:phone/enumerations.dart';
import 'package:phone/src/pages/editor_page.dart';
import 'package:test/test.dart';

import 'common.dart';

/// Default `onDone` function.
Future<void> onDone(String text) async {
  throw UnimplementedError('That should not have happened.');
}

void main() {
  group(
    'EditorPage class',
    () {
      final mainLoop = DummyMainLoop();
      test(
        'Initialisation',
        () {
          final editor =
              EditorPage(onDone: onDone, initialText: 'Hello world.');
          expect(editor.cursorPosition, 12);
          expect(editor.lastKey, isNull);
          expect(editor.lastLetterIndex, -1);
          expect(editor.mode, TypingMode.upperCase);
          expect(editor.onCancel, isNull);
          expect(editor.text.string, 'Hello world.');
        },
      );
      test(
        '.onDone',
        () async {
          String? string;
          final editor = EditorPage(
              onDone: (text) async => string = text,
              initialText: 'Hello world.');
          expect(string, isNull);
          await editor.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(string, editor.text.string);
          string = null;
          editor.text = Characters('Testing.');
          await editor.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(string, 'Testing.');
        },
      );
      test(
        '.mode',
        () async {
          final editor = EditorPage(onDone: onDone);
          expect(editor.mode, TypingMode.upperCase);
          final speech = mainLoop.speechEngine as DummySpeechEngine
            ..utterances.clear();
          await editor.handleKeyEvent(KeyEvent.mode, mainLoop);
          expect(editor.mode, TypingMode.lowerCase);
          speech.expectUtterance(
              length: 1, interrupt: true, text: 'Lower case');
          await editor.handleKeyEvent(KeyEvent.mode, mainLoop);
          expect(editor.mode, TypingMode.numbers);
          speech.expectUtterance(length: 2, interrupt: true, text: 'Numbers');
          await editor.handleKeyEvent(KeyEvent.mode, mainLoop);
          expect(editor.mode, TypingMode.upperCase);
          speech.expectUtterance(
              length: 3, interrupt: true, text: 'Upper case');
          await editor.handleKeyEvent(KeyEvent.mode, mainLoop);
          expect(editor.mode, TypingMode.lowerCase);
          speech.expectUtterance(
              length: 4, interrupt: true, text: 'Lower case');
        },
      );
      test(
        '.cancel',
        () async {
          var cancel = 0;
          final editor = EditorPage(
            onDone: onDone,
            onCancel: (mainLoop) async {
              cancel++;
            },
          );
          expect(cancel, isZero);
          await editor.handleKeyEvent(KeyEvent.cancel, mainLoop);
          expect(cancel, 1);
          await editor.handleKeyEvent(KeyEvent.cancel, mainLoop);
          expect(cancel, 2);
        },
      );
      test(
        '.typeLetter',
        () async {
          String? string;
          final editor = EditorPage(
            onDone: (text) async => string = text,
          );
          final speech = mainLoop.speechEngine as DummySpeechEngine
            ..utterances.clear();
          await editor.handleKeyEvent(KeyEvent.key4, mainLoop);
          expect(editor.text, isEmpty);
          expect(editor.lastKey, KeyEvent.key4);
          expect(editor.lastLetterIndex, isZero);
          speech.expectUtterance(length: 1, interrupt: true, text: 'G');
          await editor.handleKeyEvent(KeyEvent.key4, mainLoop);
          expect(editor.text, isEmpty);
          expect(editor.lastKey, KeyEvent.key4);
          expect(editor.lastLetterIndex, 1);
          speech.expectUtterance(length: 2, interrupt: true, text: 'H');
          await editor.handleKeyEvent(KeyEvent.mode, mainLoop);
          expect(editor.text.string, 'H');
          expect(editor.lastKey, isNull);
          expect(editor.mode, TypingMode.lowerCase);
          speech.expectUtterance(
              length: 4, interrupt: true, text: 'Lower case');
          var utterance = speech.utterances[speech.utterances.length - 2];
          expect(utterance.interrupt, isFalse);
          expect(utterance.text, 'H');
          await editor.handleKeyEvent(KeyEvent.key3, mainLoop);
          expect(editor.text.string, 'H');
          speech.expectUtterance(length: 5, interrupt: true, text: 'd');
          await editor.handleKeyEvent(KeyEvent.key3, mainLoop);
          expect(editor.text.string, 'H');
          speech.expectUtterance(length: 6, interrupt: true, text: 'e');
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);
          expect(editor.text.string, 'He');
          speech.expectUtterance(length: 8, interrupt: true, text: 'j');
          utterance = speech.utterances[speech.utterances.length - 2];
          expect(utterance.interrupt, isFalse);
          expect(utterance.text, 'e');
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);
          expect(editor.text.string, 'He');
          speech.expectUtterance(length: 9, interrupt: true, text: 'k');
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);
          expect(editor.text.string, 'He');
          speech.expectUtterance(length: 10, interrupt: true, text: 'l');
          await editor.handleKeyEvent(KeyEvent.key7, mainLoop);
          speech.expectUtterance(length: 12, interrupt: true, text: 'p');
          utterance = speech.utterances[speech.utterances.length - 2];
          expect(utterance.interrupt, isFalse);
          expect(utterance.text, 'l');
          await editor.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(string, 'Help');
          speech.expectUtterance(length: 13, interrupt: false, text: 'p');
          editor.cursorPosition = 2;
          await editor.handleKeyEvent(KeyEvent.key2, mainLoop);
          await editor.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(editor.cursorPosition, 3);
          expect(string, 'Healp');
        },
      );
      test(
        '.moveCursor',
        () async {
          final editor =
              EditorPage(onDone: onDone, initialText: 'Hello world.');
          expect(editor.cursorPosition, editor.text.length);
          final speech = mainLoop.speechEngine as DummySpeechEngine
            ..utterances.clear();
          await editor.handleKeyEvent(KeyEvent.left, mainLoop);
          expect(editor.cursorPosition, editor.text.length - 1);
          speech.expectUtterance(length: 1, interrupt: true, text: '.');
          await editor.handleKeyEvent(KeyEvent.left, mainLoop);
          expect(editor.cursorPosition, editor.text.length - 2);
          speech.expectUtterance(length: 2, interrupt: true, text: 'd');
          await editor.handleKeyEvent(KeyEvent.right, mainLoop);
          expect(editor.cursorPosition, editor.text.length - 1);
          speech.expectUtterance(length: 3, interrupt: true, text: '.');
        },
      );
      test(
        '.backspace',
        () async {
          final editor =
              EditorPage(onDone: onDone, initialText: 'Hello world.');
          final speech = mainLoop.speechEngine as DummySpeechEngine
            ..utterances.clear();
          await editor.handleKeyEvent(KeyEvent.backspace, mainLoop);
          expect(editor.text.string, 'Hello world');
          expect(editor.cursorPosition, editor.text.length);
          speech.expectUtterance(length: 1, interrupt: true, text: '.');
          editor.cursorPosition = 0;
          await editor.handleKeyEvent(KeyEvent.backspace, mainLoop);
          speech.expectUtterance(length: 2, interrupt: true, text: 'Blank');
          expect(editor.text.string, 'Hello world');
          expect(editor.cursorPosition, 0);
          editor.cursorPosition = 1;
          await editor.handleKeyEvent(KeyEvent.backspace, mainLoop);
          expect(editor.text.string, 'ello world');
          expect(editor.cursorPosition, isZero);
          speech.expectUtterance(length: 3, interrupt: true, text: 'H');
        },
      );
      test(
        'Typing session',
        () async {
          String? string;
          final editor = EditorPage(
            onDone: (text) async => string = text,
          );

          // Type h.
          await editor.handleKeyEvent(KeyEvent.key4, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key4, mainLoop);

          // Change mode to lower case.
          await editor.handleKeyEvent(KeyEvent.mode, mainLoop);

          // Type e.
          await editor.handleKeyEvent(KeyEvent.key3, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key3, mainLoop);

          // Type l.
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);

          // Go right to enter the letter.
          await editor.handleKeyEvent(KeyEvent.right, mainLoop);

          // Enter another l.
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);

          // Type o.
          await editor.handleKeyEvent(KeyEvent.key6, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key6, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key6, mainLoop);

          // Type space.
          await editor.handleKeyEvent(KeyEvent.key0, mainLoop);

          // Switch mode to numbers.
          await editor.handleKeyEvent(KeyEvent.mode, mainLoop);

          // Type 123.
          await editor.handleKeyEvent(KeyEvent.key1, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key2, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key3, mainLoop);

          // Switch mode back to upper case.
          await editor.handleKeyEvent(KeyEvent.mode, mainLoop);

          // Type a full stop.
          await editor.handleKeyEvent(KeyEvent.key1, mainLoop);

          // Check the final output.
          await editor.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(string, 'Hello 123.');

          // Go back to the character 1.
          await editor.moveCursor(mainLoop, -4);

          // Type w.
          await editor.handleKeyEvent(KeyEvent.key9, mainLoop);

          // Switch to lower case.
          await editor.handleKeyEvent(KeyEvent.mode, mainLoop);

          // Type o.
          await editor.handleKeyEvent(KeyEvent.key6, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key6, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key6, mainLoop);

          // Type r.
          await editor.handleKeyEvent(KeyEvent.key7, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key7, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key7, mainLoop);

          // Type l.
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key5, mainLoop);

          // Type d.
          await editor.handleKeyEvent(KeyEvent.key3, mainLoop);

          // Type a space.
          await editor.handleKeyEvent(KeyEvent.key0, mainLoop);

          // Move to near the end.
          while (editor.cursorPosition != (editor.text.length - 1)) {
            await editor.handleKeyEvent(KeyEvent.right, mainLoop);
          }

          // Type a $.
          await editor.handleKeyEvent(KeyEvent.key4, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key4, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key4, mainLoop);
          await editor.handleKeyEvent(KeyEvent.key4, mainLoop);

          // Check the output again.
          await editor.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(string, r'Hello World 123$.');
        },
      );
    },
  );
}
