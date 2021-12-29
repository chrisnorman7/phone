import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:phone/enumerations.dart';
import 'package:phone/main_loop.dart';
import 'package:phone/speech.dart';
import 'package:phone/src/json/key_map.dart';
import 'package:phone/src/json/phone_options.dart';
import 'package:phone/src/speech/speech_systems.dart';

Future<void> main(List<String> arguments) async {
  final rootLogger = Logger.root;
  Logger.root.onRecord.listen((event) {
    // ignore: avoid_print
    print('${event.loggerName}: ${event.level} (${event.time}): '
        '${event.message}');
  });
  rootLogger.info('Starting...');
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
        newLineChar: Platform.isWindows ? '\r' : '\n',
        speechSystemName: speechSystems.first.name);
    rootLogger.info('Loaded options.');
  }
  final speechSystem = speechSystems
      .firstWhere((element) => element.name == options.speechSystemName);
  rootLogger.info('Using ${speechSystem.name} for TTS.');
  final engine = SpeechEngine(system: speechSystem);
  rootLogger.info('Created speech engine.');
  engine.reset();
  stdin
    ..echoMode = false
    ..lineMode = false;
  rootLogger.info('Configured stdin.');
  final KeyMap keyMap;
  if (KeyMap.keyMapFile.existsSync() == true) {
    final data = KeyMap.keyMapFile.readAsStringSync();
    rootLogger.info('Loaded keymap data.');
    final json = jsonDecode(data) as Map<String, dynamic>;
    rootLogger.info('Converted data to json.');
    keyMap = KeyMap.fromJson(json);
    rootLogger.info('Loaded keymap:\n${keyMap.keys}');
  } else {
    final keys = {
      '.': KeyEvent.mode,
      '0': KeyEvent.key0,
      '1': KeyEvent.key7,
      '2': KeyEvent.key8,
      '3': KeyEvent.key9,
      '4': KeyEvent.key4,
      '5': KeyEvent.key5,
      '6': KeyEvent.key6,
      '7': KeyEvent.key1,
      '8': KeyEvent.key2,
      '9': KeyEvent.key3,
      '/': KeyEvent.left,
      '*': KeyEvent.right,
      '-': KeyEvent.backspace,
      '+': KeyEvent.cancel,
      options.newLineChar: KeyEvent.enter
    };
    rootLogger.info('Created default keys:\n$keys');
    keyMap = KeyMap(keys);
    rootLogger.info('Created default keymap.');
  }
  final mainLoop = MainLoop(speechEngine: engine, keyMap: keyMap);
  await mainLoop.run();
  engine.shutdown();
  rootLogger.info('Engine shutdown.');
}
