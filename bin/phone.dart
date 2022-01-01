import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:phone/emojis.dart';
import 'package:phone/main_loop.dart';
import 'package:phone/speech.dart';
import 'package:phone/src/json/phone_options.dart';
import 'package:phone/ui.dart';

Future<void> main(List<String> arguments) async {
  final now = DateTime.now();
  final rootLogger = Logger.root;
  final year = now.year;
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  final second = now.second.toString().padLeft(2, '0');
  final timestamp = '$year-$month-$day $hour-$minute-$second';
  final logDirectory = Directory('logs');
  final logFile = File(path.join(logDirectory.path, '$timestamp.txt'));
  IOSink? logWriter;
  try {
    Logger.root
      ..level = Level.INFO
      ..onRecord.listen((event) {
        final message = StringBuffer()
          ..writeln('${event.loggerName}: ${event.level} ('
              '${event.time}): ${event.message}');
        final e = event.error;
        if (e != null) {
          message
            ..writeln(e)
            ..writeln(event.stackTrace);
        }
        if (logWriter == null) {
          // ignore: avoid_print
          print(message.toString().substring(0, message.length - 2));
        } else {
          logWriter.write(message);
        }
      });
    if (logDirectory.existsSync() == false) {
      logDirectory.createSync(recursive: true);
      rootLogger.info('Created log directory.');
    }
    logFile.createSync();
    logWriter = logFile.openWrite();
    rootLogger.info('Logging to ${logFile.path}.');
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
  } finally {
    rootLogger.info('Done.');
    await logWriter?.close();
    logWriter = null;
  }
  final size = logFile.statSync().size;
  if (size == 0) {
    rootLogger.info('Deleting empty log file ${logFile.path}.');
    logFile.deleteSync(recursive: true);
  } else {
    rootLogger.info('Log file size: $size bytes.');
  }
}
