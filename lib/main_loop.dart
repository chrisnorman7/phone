/// Provides the [MainLoop] class.
import 'dart:io';

import 'package:logging/logging.dart';

import 'speech.dart';
import 'src/json/contacts.dart';
import 'src/json/emojis.dart';
import 'src/json/phone_options.dart';
import 'src/pages/main_page.dart';
import 'src/ui/input_handler.dart';
import 'src/ui/widget_page.dart';

/// The file where the log level lives.
final logLevelFile = File('log_level.txt');

/// The main loop for the program.
class MainLoop {
  /// Create an instance.
  MainLoop(
      {required this.speechEngine,
      required this.options,
      required this.emojis,
      required this.contactList})
      : pages = [];

  /// The speech engine to use.
  SpeechEngine speechEngine;

  /// The phone options.
  final PhoneOptions options;

  /// The emojis recognised by this program.
  final EmojiList emojis;

  /// The contact list.
  final ContactList contactList;

  /// The stack of [WidgetPage] instances.
  final List<InputHandler> pages;

  /// Run the loop.
  Future<void> run() async {
    final logger = Logger('Main Loop')..info('Started.');
    await pushPage(MainPage());
    OUTER:
    await for (final charCodes in stdin) {
      for (final charCode in charCodes) {
        final char = String.fromCharCode(charCode);
        final keyEvent = options.keyMap[char];
        if (char == 'q') {
          break OUTER;
        } else if (keyEvent == null) {
          logger.warning('Unhandled key $char.');
        } else {
          if (pages.isEmpty) {
            logger.info('Key event with no pages: $keyEvent.');
          } else {
            await pages.last.handleKeyEvent(keyEvent, this);
          }
        }
      }
    }
    pages.clear();
    logger.info('Completed successfully.');
  }

  /// Speak some text.
  ///
  /// This method uses the [options] speech dictionary for substitutions.
  Future<void> speak(String text, {bool interrupt = true}) =>
      speechEngine.speak(
          text: text,
          substitutions: {...options.speechDictionary, ...emojis.conversions},
          interrupt: interrupt);

  /// Push a new page onto the [pages] stack.
  Future<void> pushPage(InputHandler page) async {
    await page.onPush(this);
    pages.add(page);
  }

  /// Pop the top page from the [pages] stack.
  Future<void> popPage() async {
    final covering = pages.removeLast()..onPop(this);
    if (pages.isNotEmpty) {
      await pages.last.onReveal(this, covering);
    }
  }
}
