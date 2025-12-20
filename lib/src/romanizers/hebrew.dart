import 'package:romanize/romanize.dart';

/// A romanizer for Hebrew script.
///
/// Supports transliteration of Hebrew characters into Latin script using
/// a standard transliteration table (aligned with ISO 259 and DIN 31636).
class HebrewRomanizer extends Romanizer {
  const HebrewRomanizer() : super(language: 'hebrew');

  /// Transliteration map for Hebrew to Latin characters.
  ///
  /// Based on ISO 259 / DIN 31636.
  static const Map<String, String> _transliterationMap = {
    // Special combinations
    'וֹ': 'ō', // Holam Male (Vav + Holam)
    'וּ': 'u', // Shuruq (Vav + Dagesh)
    // Consonants
    'א': 'ʾ', // Alef
    'ב': 'b', // Bet
    'ג': 'g', // Gimel
    'ד': 'd', // Dalet
    'ה': 'h', // He
    'ו': 'v', // Vav
    'ז': 'z', // Zayin
    'ח': 'ḥ', // Het
    'ט': 'ṭ', // Tet
    'י': 'y', // Yod
    'כ': 'k', // Kaf
    'ך': 'k', // Final Kaf
    'ל': 'l', // Lamed
    'מ': 'm', // Mem
    'ם': 'm', // Final Mem
    'נ': 'n', // Nun
    'ן': 'n', // Final Nun
    'ס': 's', // Samekh
    'ע': 'ʿ', // Ayin
    'פ': 'p', // Pe
    'ף': 'p', // Final Pe
    'צ': 'ṣ', // Tsadi
    'ץ': 'ṣ', // Final Tsadi
    'ק': 'q', // Qof
    'ר': 'r', // Resh
    'ש': 'sh', // Shin (Base)
    'ת': 't', // Tav
    // Vowels (Niqqud)
    'ַ': 'a', // Patah
    'ָ': 'ā', // Qamats
    'ֶ': 'e', // Segol
    'ֵ': 'ē', // Tsere
    'ִ': 'i', // Hiriq
    'ֹ': 'ō', // Holam
    'ֻ': 'u', // Qibbuts
    'ְ': 'e', // Sheva
    'ֲ': 'a', // Hataf Patah
    'ֱ': 'e', // Hataf Segol
    'ֳ': 'o', // Hataf Qamats
    // Marks/Punctuation
    'ּ': '', // Dagesh
    'ֿ': '', // Rafe
    'ׁ': '', // Shin Dot
    'ׂ': '', // Sin Dot
    '׳': '\'', // Geresh
    '״': '"', // Gershayim
  };

  static final _hebrewPattern = RegExp(r'[\u0590-\u05FF\uFB1D-\uFB4F]');

  /// Converts a given Hebrew string to its Romanized form.
  @override
  String romanize(String input) {
    final buffer = StringBuffer();
    final runes = input.runes.toList();

    for (int i = 0; i < runes.length; i++) {
      final char = runes[i];
      final charString = String.fromCharCode(char);

      // Check for 2-character sequences (ligatures/combinations)
      if (i + 1 < runes.length) {
        final nextChar = runes[i + 1];
        final bigram = charString + String.fromCharCode(nextChar);
        if (_transliterationMap.containsKey(bigram)) {
          buffer.write(_transliterationMap[bigram]);
          i++; // Skip the next character as it was part of the bigram
          continue;
        }
      }

      buffer.write(_transliterationMap[charString] ?? charString);
    }
    return buffer.toString();
  }

  /// Validates if the input string contains Hebrew characters.
  @override
  bool isValid(String input) {
    return _hebrewPattern.hasMatch(input);
  }
}
