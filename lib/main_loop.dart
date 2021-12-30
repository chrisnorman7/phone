/// Provides the [MainLoop] class.
import 'dart:io';

import 'package:logging/logging.dart';

import 'speech.dart';
import 'src/json/phone_options.dart';

/// The main loop for the program.
class MainLoop {
  /// Create an instance.
  const MainLoop({required this.speechEngine, required this.options});

  /// The speech engine to use.
  final SpeechEngine speechEngine;

  /// The phone options.
  final PhoneOptions options;

  /// Run the loop.
  Future<void> run() async {
    final logger = Logger('Main Loop')..info('Started.');
    await for (final charCodes in stdin) {
      for (final charCode in charCodes) {
        final char = String.fromCharCode(charCode);
        final keyEvent = options.keyMap[char];
        if (char == 'q') {
          logger.info('Done.');
          return;
        } else if (keyEvent == null) {
          logger.warning('Unhandled key $char.');
        } else {
          logger.info('Key event $keyEvent.');
        }
      }
    }
  }
}
