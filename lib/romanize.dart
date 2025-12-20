library;

import 'package:romanize/src/romanize_base.dart';
import 'package:romanize/src/romanizers/arabic.dart';
import 'package:romanize/src/romanizers/chinese.dart';
import 'package:romanize/src/romanizers/cyrillic.dart';
import 'package:romanize/src/romanizers/hebrew.dart';
import 'package:romanize/src/romanizers/japanese.dart';
import 'package:romanize/src/romanizers/korean.dart';

export 'src/romanize_base.dart';
export 'src/romanizers/arabic.dart';
export 'src/romanizers/chinese.dart';
export 'src/romanizers/cyrillic.dart';
export 'src/romanizers/hebrew.dart';
export 'src/romanizers/japanese.dart';
export 'src/romanizers/korean.dart';

/// A utility class for converting text to Romanized form.
///
/// This class provides static methods to automatically detect and romanize
/// text from various languages, or to get language-specific romanizers.
///
/// Example:
/// ```dart
/// // Auto-detect language
/// final romanized = TextRomanizer.romanize('안녕하세요');
/// print(romanized); // annyeonghaseyo
///
/// // Use specific language
/// final romanizer = TextRomanizer.forLanguage('japanese');
/// final result = romanizer.romanize('こんにちは'); // konnichiwa
/// ```
class TextRomanizer {
  const TextRomanizer._();

  /// Ensures that all necessary initializations are done.
  ///
  /// This method is expensive and should be called on another thread if
  /// possible.
  static Future<void> ensureInitialized() async {
    await JapaneseRomanizer.init();
  }

  /// List of all available romanizers.
  ///
  /// The romanizers are checked in order when auto-detecting the language.
  static final Set<Romanizer> romanizers = <Romanizer>{
    HangulRomanizer(),

    // Note: Chinese is placed before Japanese. Pure Kanji (e.g., "東京") will
    // default to Chinese. Mixed Japanese (Kanji + Kana) will be rejected by
    // ChineseRomanizer.isValid and fall through to JapaneseRomanizer.
    ChineseRomanizer(),
    JapaneseRomanizer(),
    CyrillicRomanizer(),
    ArabicRomanizer(),
    HebrewRomanizer(),
  };

  /// Automatically detects the language of the input text.
  ///
  /// This method iterates through all available romanizers and uses the first
  /// one that validates the input as valid for its language.
  ///
  /// Returns an [EmptyRomanizer] if the input is empty or not valid for any
  /// known languages.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = TextRomanizer.detectLanguage('안녕하세요');
  /// print(romanizer.language); // korean
  /// ```
  static Romanizer detectLanguage(
    final String input, [
    Set<Romanizer>? romanizers,
  ]) {
    if (input.isEmpty || !RegExp(r'\S').hasMatch(input)) {
      return const EmptyRomanizer();
    }

    romanizers ??= TextRomanizer.romanizers;

    return romanizers.firstWhere(
      (romanizer) => romanizer.isValid(input),
      orElse: () => const EmptyRomanizer(),
    );
  }

  /// Detects the languages of the input text.
  ///
  /// This method iterates through all available romanizers and returns a set
  /// of valid romanizers for the input text.
  ///
  /// Returns an empty set if the input is empty or not valid for any
  /// known languages.
  ///
  /// Example:
  /// ```dart
  /// final languages = TextRomanizer.detectLanguages('안녕하세요');
  /// print(languages); // {HangulRomanizer()}
  /// ```
  static Set<Romanizer> detectLanguages(String input) {
    if (input.isEmpty || !RegExp(r'\S').hasMatch(input)) {
      return {EmptyRomanizer()};
    }

    return romanizers.where((romanizer) => romanizer.isValid(input)).toSet();
  }

  static final _separatorPattern = RegExp(r'[\s\p{P}_]+');

  /// Romanizes the input text by processing each word separately.
  ///
  /// This method splits the input by spaces and romanizes each word
  /// independently, which is useful for multi-language text where different
  /// words may be in different languages. Each word is auto-detected and
  /// romanized according to its language.
  ///
  /// Example:
  /// ```dart
  /// // Multi-language text
  /// final result = TextRomanizer.romanizeWords('你好 Hello 안녕');
  /// print(result); // ni hao Hello annyeong
  ///
  /// // Single language text
  /// final result2 = TextRomanizer.romanizeWords('你好世界');
  /// print(result2); // ni hao shi jie
  /// ```
  ///
  /// Uses a cache to avoid redundant language detection for repeated words.
  /// This improves performance for long texts.
  static String romanize(String input) {
    final languages = detectLanguages(input);
    if (languages.length == 1) {
      return languages.first.romanize(input);
    }
    final wordCache = <String, Romanizer>{};

    return input.splitMapJoin(
      _separatorPattern,
      // Handle the separators (whitespace and punctuation):
      onMatch: (Match match) => match[0]!,
      // Handle the content (words):
      onNonMatch: (String word) {
        if (word.isEmpty) return '';

        final romanizer = wordCache.putIfAbsent(
          word,
          () => detectLanguage(word, languages),
        );

        return romanizer.romanize(word);
      },
    );
  }

  /// Returns a [Romanizer] for the specified language.
  ///
  /// The language name is case-insensitive. For example, 'Korean', 'korean',
  /// and 'KOREAN' are all valid.
  ///
  /// Throws [UnimplementedError] if no romanizer is found for the language.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = TextRomanizer.forLanguage('japanese');
  /// final result = romanizer.romanize('こんにちは');
  /// ```
  static Romanizer forLanguage(String language) {
    if (language.trim().isEmpty) {
      throw ArgumentError.value(
        language,
        'language',
        'Language name cannot be empty',
      );
    }

    return romanizers.firstWhere(
      (romanizer) =>
          romanizer.language.toLowerCase() == language.toLowerCase().trim(),
      orElse: () => throw UnimplementedError(
        'No Romanizer found for the language: $language. '
        'Supported languages: ${supportedLanguages.join(", ")}',
      ),
    );
  }

  /// Returns a [Romanizer] for the specified language, or `null` if not found.
  ///
  /// This is a safe alternative to [forLanguage] that returns `null` instead
  /// of throwing an exception when the language is not supported.
  ///
  /// Returns `null` if:
  /// - [language] is `null`
  /// - [language] is empty or contains only whitespace
  /// - No romanizer is found for the language
  ///
  /// Example:
  /// ```dart
  /// final romanizer = TextRomanizer.forLanguageOrNull('korean');
  /// if (romanizer != null) {
  ///   print(romanizer.romanize('안녕하세요'));
  /// }
  /// ```
  static Romanizer? forLanguageOrNull(String? language) {
    if (language == null || language.trim().isEmpty) {
      return null;
    }

    final normalizedLanguage = language.toLowerCase().trim();
    for (final romanizer in romanizers) {
      if (romanizer.language.toLowerCase() == normalizedLanguage) {
        return romanizer;
      }
    }
    return null;
  }

  /// Returns a list of all supported language names.
  ///
  /// Example:
  /// ```dart
  /// final languages = TextRomanizer.supportedLanguages;
  /// print(languages); // ['korean', 'japanese']
  /// ```
  static Set<String> get supportedLanguages =>
      romanizers.map((r) => r.language).toSet();
}
