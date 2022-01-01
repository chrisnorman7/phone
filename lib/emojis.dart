/// Provides the [getEmojiList] class.
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

import 'src/json/emojis.dart';

/// Returns all emojis.
EmojiList getEmojiList() {
  final rootLogger = Logger('Load Emojis');
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
  return EmojiList(
      conversions: emojiNames, categories: categories.values.toList());
}
