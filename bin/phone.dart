import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:phone/emojis.dart';
import 'package:phone/main_loop.dart';
import 'package:phone/speech.dart';
import 'package:phone/src/json/phone_options.dart';
import 'package:phone/ui.dart';

Future<void> main(List<String> arguments) async {
  final now = DateTime.now();
  final rootLogger = Logger.root;
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen((event) {
      // ignore: avoid_print
      print('${event.loggerName}: ${event.level} (${event.time}): '
          '${event.message}');
    });
  rootLogger.info('Starting...');
  try {
    final PhoneOptions options;
    if (PhoneOptions.optionsFile.existsSync() == true) {
      final data = PhoneOptions.optionsFile.readAsStringSync();
      rootLogger.info('Loaded options data.');
      final json = jsonDecode(data) as Map<String, dynamic>;
      rootLogger.info('Converted data to JSON.');
      options = PhoneOptions.fromJson(json);
      rootLogger.info('Loaded options.');
    } else {
      options = PhoneOptions(
          newLineChar: newLineChar,
          speechSystemName: speechSystems.first.name,
          keyMap: defaultKeymap);
      rootLogger.info('Loaded options.');
    }
    final speechSystem = speechSystems
        .firstWhere((element) => element.name == options.speechSystemName);
    rootLogger.info('Using ${speechSystem.name} for TTS.');
    final engine = SpeechEngine(system: speechSystem);
    final rate = options.getSpeechRate(speechSystem.name);
    if (rate != null) {
      engine.rate = rate;
      rootLogger.info('Setting speech rate to $rate.');
    }
    rootLogger.info('Created speech engine.');
    final emojiList = getEmojis();
    rootLogger.info('Loaded emojis.');
    stdin
      ..echoMode = false
      ..lineMode = false;
    rootLogger.info('Configured stdin.');
    final mainLoop =
        MainLoop(speechEngine: engine, options: options, emojis: emojiList);
    rootLogger.info('Initialised in ${DateTime.now().difference(now)}.');
    await mainLoop.run();
  } catch (e, s) {
    rootLogger.severe('System failed.', e, s);
  }
}
