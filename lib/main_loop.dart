/// Provides the [mainLoop] function.
import 'dart:io';

import 'package:logging/logging.dart';

import 'speech.dart';
import 'src/json/key_map.dart';

/// The main loop for the program.
Future<void> mainLoop(
    {required SpeechEngine engine, required KeyMap keyMap}) async {
  final logger = Logger('Main Loop')..info('Started.');
  await for (final charCodes in stdin) {
    for (final charCode in charCodes) {
      final char = String.fromCharCode(charCode);
      final keyEvent = keyMap.keys[char];
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
