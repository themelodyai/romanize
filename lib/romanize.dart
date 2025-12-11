library;

import 'package:romanize/src/romanize_base.dart';
import 'package:romanize/src/romanizers/arabic.dart';
import 'package:romanize/src/romanizers/cyrillic.dart';
import 'package:romanize/src/romanizers/japanese.dart';
import 'package:romanize/src/romanizers/korean.dart';

export 'src/romanize_base.dart';
export 'src/romanizers/arabic.dart';
export 'src/romanizers/cyrillic.dart';
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
  /// List of all available romanizers.
  ///
  /// The romanizers are checked in order when auto-detecting the language.
  static const List<Romanizer> romanizers = <Romanizer>[
    KoreanRomanizer(),
    JapaneseRomanizer(),
    CyrillicRomanizer(),
    ArabicRomanizer(),
  ];

  /// Automatically detects the language and romanizes the input text.
  ///
  /// This method iterates through all available romanizers and uses the first
  /// one that validates the input as valid for its language. Use [forLanguage]
  /// to get a specific romanizer for a language.
  ///
  /// Throws [ArgumentError] if no romanizer can validate the input.
  ///
  /// Example:
  /// ```dart
  /// final result = TextRomanizer.romanize('안녕하세요');
  /// print(result); // annyeonghaseyo
  /// ```
  static String romanize(String input) {
    if (input.trim().isEmpty) {
      return '';
    }

    for (final romanizer in romanizers) {
      if (romanizer.isValid(input)) {
        return romanizer.romanize(input);
      }
    }

    throw ArgumentError.value(
      input,
      'input',
      'No valid Romanizer found for the input. Supported languages: ${supportedLanguages.join(", ")}',
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
  static List<String> get supportedLanguages =>
      romanizers.map((r) => r.language).toList();
}
