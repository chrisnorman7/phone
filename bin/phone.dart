import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:phone/main_loop.dart';
import 'package:phone/speech.dart';
import 'package:phone/src/json/key_map.dart';

Future<void> main(List<String> arguments) async {
  final rootLogger = Logger.root;
  Logger.root.onRecord.listen((event) {
    // ignore: avoid_print
    print('${event.loggerName}: ${event.level} (${event.time}): '
        '${event.message}');
  });
  rootLogger.info('Starting...');
  const espeakNg = SpeechSystem(
      name: 'espeak-ng',
      executableName: 'espeak-ng',
      pitchArgument: '-p',
      pitchConfiguration:
          SpeechConfigurationValue(minValue: 0, defaultValue: 50, maxValue: 99),
      rateArgument: '-s',
      rateConfiguration: SpeechConfigurationValue(
          minValue: 60, defaultValue: 175, maxValue: 5000),
      extraArguments: ['-z']);
  rootLogger.info('Created espeak-ng.');
  final engine = SpeechEngine(system: espeakNg);
  rootLogger.info('Created speech engine.');
  engine.reset();
  stdin
    ..echoMode = false
    ..lineMode = false;
  final KeyMap keyMap;
  if (KeyMap.keyMapFile.existsSync() == true) {
    final data = KeyMap.keyMapFile.readAsStringSync();
    rootLogger.info('Loaded keymap data.');
    final json = jsonDecode(data) as Map<String, dynamic>;
    rootLogger.info('Converted data to json.');
    keyMap = KeyMap.fromJson(json);
    rootLogger.info('Loaded keymap:\n${keyMap.keys}');
  } else {
    keyMap = KeyMap();
    rootLogger.info('Created default keymap.');
  }
  await mainLoop(engine: engine, keyMap: keyMap);
  engine.shutdown();
  rootLogger.info('Engine shutdown.');
}
