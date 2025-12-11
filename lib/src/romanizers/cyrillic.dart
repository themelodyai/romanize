import 'package:romanize/romanize.dart';

/// A romanizer for Cyrillic script languages.
///
/// Supports transliteration of Cyrillic characters from languages such as
/// Russian, Ukrainian, Bulgarian, Serbian, and others into Latin script.
/// Uses a standard transliteration table based on ISO 9 (GOST 7.79-2000).
class CyrillicRomanizer extends Romanizer {
  const CyrillicRomanizer() : super(language: 'cyrillic');

  /// Transliteration map for Cyrillic to Latin characters.
  ///
  /// Based on ISO 9 standard, covering most common Cyrillic characters
  /// used in Russian, Ukrainian, Bulgarian, Serbian, and other languages.
  static const Map<String, String> _transliterationMap = {
    // Russian alphabet
    'А': 'A', 'а': 'a',
    'Б': 'B', 'б': 'b',
    'В': 'V', 'в': 'v',
    'Г': 'G', 'г': 'g',
    'Д': 'D', 'д': 'd',
    'Е': 'E', 'е': 'e',
    'Ё': 'Yo', 'ё': 'yo',
    'Ж': 'Zh', 'ж': 'zh',
    'З': 'Z', 'з': 'z',
    'И': 'I', 'и': 'i',
    'Й': 'Y', 'й': 'y',
    'К': 'K', 'к': 'k',
    'Л': 'L', 'л': 'l',
    'М': 'M', 'м': 'm',
    'Н': 'N', 'н': 'n',
    'О': 'O', 'о': 'o',
    'П': 'P', 'п': 'p',
    'Р': 'R', 'р': 'r',
    'С': 'S', 'с': 's',
    'Т': 'T', 'т': 't',
    'У': 'U', 'у': 'u',
    'Ф': 'F', 'ф': 'f',
    'Х': 'Kh', 'х': 'kh',
    'Ц': 'Ts', 'ц': 'ts',
    'Ч': 'Ch', 'ч': 'ch',
    'Ш': 'Sh', 'ш': 'sh',
    'Щ': 'Shch', 'щ': 'shch',
    'Ъ': '', 'ъ': '', // Hard sign (usually omitted)
    'Ы': 'Y', 'ы': 'y',
    'Ь': '', 'ь': '', // Soft sign (usually omitted)
    'Э': 'E', 'э': 'e',
    'Ю': 'Yu', 'ю': 'yu',
    'Я': 'Ya', 'я': 'ya',
    // Ukrainian specific
    'Ґ': 'G', 'ґ': 'g',
    'Є': 'Ye', 'є': 'ye',
    'І': 'I', 'і': 'i',
    'Ї': 'Yi', 'ї': 'yi',
    // Serbian/Macedonian
    'Ђ': 'Dj', 'ђ': 'dj',
    'Ј': 'J', 'ј': 'j',
    'Љ': 'Lj', 'љ': 'lj',
    'Њ': 'Nj', 'њ': 'nj',
    'Ћ': 'C', 'ћ': 'c',
    'Џ': 'Dz', 'џ': 'dz',
    // Other Cyrillic characters
    'Ѐ': 'E', 'ѐ': 'e',
    'Ѝ': 'I', 'ѝ': 'i',
    'Ӑ': 'A', 'ӑ': 'a',
    'Ӓ': 'A', 'ӓ': 'a',
    'Ӕ': 'Ae', 'ӕ': 'ae',
    'Ӗ': 'E', 'ӗ': 'e',
    'Ә': 'A', 'ә': 'a',
    'Ӛ': 'A', 'ӛ': 'a',
    'Ӝ': 'Zh', 'ӝ': 'zh',
    'Ӟ': 'Z', 'ӟ': 'z',
    'Ӡ': 'Z', 'ӡ': 'z',
    'Ӣ': 'I', 'ӣ': 'i',
    'Ӥ': 'I', 'ӥ': 'i',
    'Ӧ': 'O', 'ӧ': 'o',
    'Ө': 'O', 'ө': 'o',
    'Ӫ': 'O', 'ӫ': 'o',
    'Ӭ': 'E', 'ӭ': 'e',
    'Ӯ': 'U', 'ӯ': 'u',
    'Ӱ': 'U', 'ӱ': 'u',
    'Ӳ': 'U', 'ӳ': 'u',
    'Ӵ': 'Ch', 'ӵ': 'ch',
    'Ӷ': 'G', 'ӷ': 'g',
    'Ӹ': 'Y', 'ӹ': 'y',
    'Ӻ': 'G', 'ӻ': 'g',
    'Ӽ': 'Kh', 'ӽ': 'kh',
    'Ӿ': 'Kh', 'ӿ': 'kh',
  };

  /// Converts a given Cyrillic string to its Romanized form.
  ///
  /// This method transliterates Cyrillic characters into their Latin
  /// equivalents using a standard transliteration table. Non-Cyrillic
  /// characters (such as Latin letters, numbers, and punctuation) are
  /// preserved as-is.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = CyrillicRomanizer();
  /// final result = romanizer.romanize('Привет мир');
  /// print(result); // Privet mir
  /// ```
  @override
  String romanize(String input) {
    final buffer = StringBuffer();
    for (final char in input.runes) {
      final charString = String.fromCharCode(char);
      if (_transliterationMap.containsKey(charString)) {
        buffer.write(_transliterationMap[charString]);
      } else {
        buffer.write(charString);
      }
    }
    return buffer.toString();
  }

  /// Validates if the input string contains Cyrillic characters.
  ///
  /// Returns `true` if the input contains any Cyrillic characters from
  /// the Unicode Cyrillic blocks.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = CyrillicRomanizer();
  /// print(romanizer.isValid('Привет')); // true
  /// print(romanizer.isValid('Hello')); // false
  /// print(romanizer.isValid('Привет Hello')); // true (mixed content)
  /// ```
  @override
  bool isValid(String input) {
    // Check for Cyrillic characters in various Unicode ranges:
    // - Basic Cyrillic: U+0400–U+04FF
    // - Cyrillic Supplement: U+0500–U+052F
    // - Cyrillic Extended-A: U+2DE0–U+2DFF
    // - Cyrillic Extended-B: U+A640–U+A69F
    // - Cyrillic Extended-C: U+1C80–U+1C8F
    return RegExp(
      r'[\u0400-\u04FF\u0500-\u052F\u2DE0-\u2DFF\uA640-\uA69F\u1C80-\u1C8F]',
    ).hasMatch(input);
  }
}
