import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:phone/enumerations.dart';
import 'package:phone/main_loop.dart';
import 'package:phone/speech.dart';
import 'package:phone/src/json/emojis.dart';
import 'package:phone/src/json/phone_options.dart';

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
    final newLineChar = Platform.isWindows ? '\r' : '\n';
    options = PhoneOptions(
        newLineChar: newLineChar,
        speechSystemName: speechSystems.first.name,
        keyMap: {
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
          newLineChar: KeyEvent.enter
        });
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
  final emojiFile = File('unicode/data/all_emojis.json');
  final data = emojiFile.readAsStringSync();
  rootLogger.info('Loaded emoji data.');
  final json = jsonDecode(data) as List<dynamic>;
  rootLogger.info('Loaded emoji JSON.');
  final emojiNames = <String, String>{};
  final categories = <String, EmojiCategory>{};
  final subcategories = <String, EmojiSubcategory>{};
  for (final entry in json) {
    final emoji = Emoji.fromJson(entry as Map<String, dynamic>);
    emojiNames[emoji.characters] = emoji.description;
    EmojiSubcategory? subcategory = subcategories[emoji.subcategoryName];
    if (subcategory == null) {
      subcategory = EmojiSubcategory(name: emoji.subcategoryName, emojis: []);
      subcategories[subcategory.name] = subcategory;
      rootLogger.info('Created subcategory ${subcategory.name}.');
    }
    EmojiCategory? category = categories[emoji.categoryName];
    if (category == null) {
      category = EmojiCategory(name: emoji.categoryName, subcategories: []);
      categories[category.name] = category;
      rootLogger.info('Created category ${category.name}.');
    }
    category.subcategories.add(subcategory);
    subcategory.emojis.add(emoji);
  }
  final emojiList = EmojiList(
      conversions: emojiNames, categories: categories.values.toList());
  rootLogger.info('Loaded emojis.');
  stdin
    ..echoMode = false
    ..lineMode = false;
  rootLogger.info('Configured stdin.');
  final mainLoop =
      MainLoop(speechEngine: engine, options: options, emojis: emojiList);
  await mainLoop.run();
}
