/// Provides emoji-related classes.
import 'package:json_annotation/json_annotation.dart';

part 'emojis.g.dart';

/// A single emoji.
@JsonSerializable()
class Emoji {
  /// Create an instance.
  const Emoji({
    required this.name,
    required this.characters,
    required this.categoryName,
    required this.subcategoryName,
    required this.keywords,
    required this.ttsDescription,
    required this.qualification,
  });

  /// Create an instance from a JSON object.
  factory Emoji.fromJson(Map<String, dynamic> json) => _$EmojiFromJson(json);

  /// The characters that make up this emoji.
  final String characters;

  /// The name of this emoji.
  final String name;

  /// The name of the main category this emoji is part of.
  @JsonKey(name: 'category_name')
  final String categoryName;

  /// The subcategory this emoji is part of.
  @JsonKey(name: 'subcategory_name')
  final String subcategoryName;

  /// The keywords that will find this emoji.
  @JsonKey(name: 'en_keywords')
  final List<String> keywords;

  /// The description for use in text-to-speech.
  @JsonKey(name: 'en_tts_description')
  final String? ttsDescription;

  /// Get the description for this emoji.
  ///
  /// If [ttsDescription] is `null`, then [name] will be returned.
  String get description => ttsDescription ?? name;

  /// How this emoji is qualified.
  final String qualification;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$EmojiToJson(this);
}

/// A subcategory which holds [Emoji] instances.
class EmojiSubcategory {
  /// Create an instance.
  const EmojiSubcategory({required this.name, required this.emojis});

  /// THe name of this subcategory.
  final String name;

  /// The list of emojis contained within this subcategory.
  final List<Emoji> emojis;
}

/// A category which holds several [EmojiSubcategory] instances.
class EmojiCategory {
  /// Create an instance.
  const EmojiCategory({required this.name, required this.subcategories});

  /// The name of this category.
  final String name;

  /// The list of subcategories held by this category.
  final List<EmojiSubcategory> subcategories;
}

/// A class to hold [EmojiCategory] instances, as well as name conversions.
class EmojiList {
  /// Create an instance.
  const EmojiList({required this.conversions, required this.categories});

  /// The conversions to use.
  final Map<String, String> conversions;

  /// The list of emoji categories present.
  final List<EmojiCategory> categories;
}
