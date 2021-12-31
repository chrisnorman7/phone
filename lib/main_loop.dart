/// Provides the [MainLoop] class.
import 'dart:io';

import 'package:logging/logging.dart';

import 'speech.dart';
import 'src/json/emojis.dart';
import 'src/json/phone_options.dart';
import 'src/pages/main_page.dart';
import 'src/ui/widget_page.dart';

/// The main loop for the program.
class MainLoop {
  /// Create an instance.
  MainLoop(
      {required this.speechEngine, required this.options, required this.emojis})
      : pages = [];

  /// The speech engine to use.
  SpeechEngine speechEngine;

  /// The phone options.
  final PhoneOptions options;

  /// The emojis recognised by this program.
  final EmojiList emojis;

  /// The stack of [WidgetPage] instances.
  final List<WidgetPage> pages;

  /// Run the loop.
  Future<void> run() async {
    final logger = Logger('Main Loop')..info('Started.');
    await pushPage(MainPage());
    await for (final charCodes in stdin) {
      for (final charCode in charCodes) {
        final char = String.fromCharCode(charCode);
        final keyEvent = options.keyMap[char];
        if (char == 'q') {
          pages.clear();
          logger.info('Done.');
          speechEngine.shutdown();
          logger.info('Speech engine shutdown.');
          return;
        } else if (keyEvent == null) {
          logger.warning('Unhandled key $char.');
        } else {
          if (pages.isEmpty) {
            logger.info('Key event with no pages: $keyEvent.');
          } else {
            await pages.last.handleKeyEvent(event: keyEvent, mainLoop: this);
          }
        }
      }
    }
  }

  /// Speak some text.
  ///
  /// This method uses the [options] speech dictionary for substitutions.
  Future<void> speak(String text, {bool interrupt = true}) =>
      speechEngine.speak(
          text: text,
          substitutions: options.speechDictionary,
          interrupt: interrupt);

  /// Push a new page onto the [pages] stack.
  Future<void> pushPage(WidgetPage page) async {
    await page.showCurrentWidget(this);
    pages.add(page);
  }

  /// Pop the top page from the [pages] stack.
  Future<void> popPage() async {
    pages.removeLast();
    if (pages.isNotEmpty) {
      await pages.last.showCurrentWidget(this);
    }
  }
}
