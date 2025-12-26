library;

import 'package:romanize/src/romanize_base.dart';
import 'package:romanize/src/romanized_text.dart';
import 'package:romanize/src/romanizers/arabic.dart';
import 'package:romanize/src/romanizers/chinese.dart';
import 'package:romanize/src/romanizers/cyrillic.dart';
import 'package:romanize/src/romanizers/hebrew.dart';
import 'package:romanize/src/romanizers/japanese.dart';
import 'package:romanize/src/romanizers/korean.dart';

export 'src/romanize_base.dart';
export 'src/romanized_text.dart';
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
    ArabicRomanizer(),
    CyrillicRomanizer(),
    HangulRomanizer(),
    HebrewRomanizer(),

    // Note: Chinese is placed before Japanese. Pure Kanji (e.g., "東京") will
    // default to Chinese. Mixed Japanese (Kanji + Kana) will be rejected by
    // ChineseRomanizer.isValid and fall through to JapaneseRomanizer.
    ChineseRomanizer(),
    JapaneseRomanizer(),
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
    if (input.isEmpty) {
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

  static final _separatorPattern = RegExp(r'[\s\p{P}\p{S}]+', unicode: true);

  // Matches chunks of text that share the same script system.
  // Grouping Kanji/Kana ensures Japanese sentences stay together.
  static final RegExp _scriptChunkPattern = RegExp(
    r'('
    r'[\p{Script=Han}\p{Script=Hiragana}\p{Script=Katakana}]+|' // CJK (Keep together)
    r'[\p{Script=Hangul}]+|' // Korean
    r'[\p{Script=Arabic}]+|' // Arabic
    r'[\p{Script=Hebrew}]+|' // Hebrew
    r'[\p{Script=Cyrillic}]+|' // Cyrillic
    r'[\p{Script=Latin}]+|' // Latin
    r'[0-9]+' // ASCII Digits
    r')',
    unicode: true,
  );

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
    final wordCache = <String, String>{};

    return input.splitMapJoin(
      _separatorPattern,
      // Handle the separators (whitespace and punctuation):
      onMatch: (Match match) => match[0]!,
      // Handle the content (words):
      onNonMatch: (String word) {
        if (word.isEmpty) return '';
        return wordCache.putIfAbsent(
          word,
          () => detectLanguage(
            word,
            // [detectLanguages] may not return all languages in the set, so
            // check for all languages.
            // languages,
          ).romanize(word),
        );
      },
    );
  }

  /// Analyzes the input text and returns a list of [RomanizedText] parts.
  ///
  /// This method splits the input by spaces and punctuation, romanizing each
  /// word independently while preserving the original structure of the text.
  /// Each word is auto-detected and romanized according to its language.
  ///
  /// Example:
  /// ```dart
  /// // Multi-language text
  /// final result = TextRomanizer.analyze('你好 Hello 안녕');
  /// print(result);
  /// // [
  /// //  RomanizedText(rawText: '你好', language: 'japanese', romanizedText: 'ni hao'),
  /// //  RomanizedText(rawText: 'Hello', language: '', romanizedText: 'Hello'),
  /// //  RomanizedText(rawText: '안녕', language: 'korean', romanizedText: 'annyeong'),
  /// // ]
  /// ```
  ///
  /// Uses a cache to avoid redundant language detection for repeated words.
  /// This improves performance for long texts.
  static List<RomanizedText> analyze(String input) {
    final parts = <RomanizedText>[];
    final wordCache = <String, RomanizedText>{};

    // 1. Outer Split: Handles spaces and punctuation
    input.splitMapJoin(
      _separatorPattern,
      onMatch: (Match match) {
        parts.add(
          RomanizedText(
            rawText: match[0]!,
            language: '',
            romanizedText: match[0]!,
          ),
        );
        return match[0]!;
      },
      onNonMatch: (String word) {
        if (word.isEmpty) return '';

        // 2. Inner Split: Handles mixed scripts (e.g., "abc가나다")
        // We find all "chunks" of consistent script within the word.
        final matches = _scriptChunkPattern.allMatches(word);

        // Track position to handle any un-matched gaps (symbols skipped by regex?)
        int currentPos = 0;

        for (final m in matches) {
          // Handle gap if any (rare, but good for safety)
          if (m.start > currentPos) {
            final gap = word.substring(currentPos, m.start);
            parts.add(
              RomanizedText(rawText: gap, language: '', romanizedText: gap),
            );
          }

          final chunk = m[0]!;
          final romanizedPart = wordCache.putIfAbsent(chunk, () {
            final romanizer = detectLanguage(chunk);
            return RomanizedText(
              rawText: chunk,
              language: romanizer.language,
              romanizedText: romanizer.romanize(chunk),
            );
          });
          parts.add(romanizedPart);

          currentPos = m.end;
        }

        // Handle trailing characters
        if (currentPos < word.length) {
          final tail = word.substring(currentPos);
          parts.add(
            RomanizedText(rawText: tail, language: '', romanizedText: tail),
          );
        }

        return word;
      },
    );

    return parts;
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
  /// final result = romanizer.romanize('こんにちは'); // konnichiwa
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
