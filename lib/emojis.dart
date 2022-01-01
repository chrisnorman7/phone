/// Provides the [getEmojis] function.
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

import 'src/json/emojis.dart';

/// Returns all emojis.
EmojiList getEmojis() {
  final logger = Logger('Load Emojis');
  final emojiFile = File('unicode/data/all_emojis.json');
  final data = emojiFile.readAsStringSync();
  logger.fine('Loaded emoji data.');
  final json = jsonDecode(data) as List<dynamic>;
  logger.fine('Loaded emoji JSON.');
  final emojiNames = <String, String>{};
  final categories = <String, EmojiCategory>{};
  final subcategories = <String, EmojiSubcategory>{};
  for (final entry in json) {
    final emoji = Emoji.fromJson(entry as Map<String, dynamic>);
    logger.finest('Found emoji ${emoji.description}.');
    emojiNames[emoji.characters] = emoji.description;
    EmojiSubcategory? subcategory = subcategories[emoji.subcategoryName];
    if (subcategory == null) {
      subcategory = EmojiSubcategory(name: emoji.subcategoryName, emojis: []);
      subcategories[subcategory.name] = subcategory;
      logger.finest('Created subcategory ${subcategory.name}.');
    }
    EmojiCategory? category = categories[emoji.categoryName];
    if (category == null) {
      category = EmojiCategory(name: emoji.categoryName, subcategories: []);
      categories[category.name] = category;
      logger.finest('Created category ${category.name}.');
    }
    category.subcategories.add(subcategory);
    subcategory.emojis.add(emoji);
  }
  return EmojiList(
      conversions: emojiNames, categories: categories.values.toList());
}
