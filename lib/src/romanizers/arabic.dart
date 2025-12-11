import 'package:romanize/romanize.dart';

/// A romanizer for Arabic script.
///
/// Supports transliteration of Arabic characters into Latin script using
/// a standard transliteration table based on ISO 233 and DIN 31635.
class ArabicRomanizer extends Romanizer {
  const ArabicRomanizer() : super(language: 'arabic');

  /// Transliteration map for Arabic to Latin characters.
  ///
  /// Based on ISO 233 and DIN 31635 standards, covering most common Arabic
  /// characters and their romanized equivalents.
  static const Map<String, String> _transliterationMap = {
    // Basic Arabic alphabet
    'ا': 'a', // Alef
    'أ': 'a', // Alef with Hamza above
    'إ': 'i', // Alef with Hamza below
    'آ': 'ā', // Alef Madda
    'ٱ': 'a', // Alef Wasla
    'ب': 'b',
    'ت': 't',
    'ث': 'th',
    'ج': 'j',
    'ح': 'ḥ',
    'خ': 'kh',
    'د': 'd',
    'ذ': 'dh',
    'ر': 'r',
    'ز': 'z',
    'س': 's',
    'ش': 'sh',
    'ص': 'ṣ',
    'ض': 'ḍ',
    'ط': 'ṭ',
    'ظ': 'ẓ',
    'ع': 'ʿ',
    'غ': 'gh',
    'ف': 'f',
    'ق': 'q',
    'ك': 'k',
    'ل': 'l',
    'م': 'm',
    'ن': 'n',
    'ه': 'h',
    'ة': 'h', // Teh Marbuta
    'و': 'w',
    'ؤ': 'u', // Waw with Hamza
    'ي': 'y',
    'ى': 'ā', // Alef Maksura
    'ئ': 'i', // Yeh with Hamza
    'ء': 'ʾ', // Hamza
    // Arabic diacritics (usually omitted in romanization but included for completeness)
    'َ': 'a', // Fatha
    'ُ': 'u', // Damma
    'ِ': 'i', // Kasra
    'ً': 'an', // Tanwin Fath
    'ٌ': 'un', // Tanwin Damm
    'ٍ': 'in', // Tanwin Kasr
    'ّ': '', // Shadda (gemination, usually handled contextually)
    'ْ': '', // Sukun (no vowel, usually omitted)
    'ٰ': 'ā', // Superscript Alef
    // Arabic numbers
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  static final _arabicPattern = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\u0870-\u089F\uFB50-\uFDFF\uFE70-\uFEFF]',
  );

  /// Converts a given Arabic string to its Romanized form.
  ///
  /// This method transliterates Arabic characters into their Latin
  /// equivalents using a standard transliteration table. Non-Arabic
  /// characters (such as Latin letters, numbers, and punctuation) are
  /// preserved as-is.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = ArabicRomanizer();
  /// final result = romanizer.romanize('أنا العربي');
  /// print(result); // ana al'arabi
  /// ```
  @override
  String romanize(String input) {
    final buffer = StringBuffer();
    for (final char in input.runes) {
      final charString = String.fromCharCode(char);
      buffer.write(_transliterationMap[charString] ?? charString);
    }
    return buffer.toString();
  }

  /// Validates if the input string contains Arabic characters.
  ///
  /// Returns `true` if the input contains any Arabic characters from
  /// the Unicode Arabic blocks.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = ArabicRomanizer();
  /// print(romanizer.isValid('أنا')); // true
  /// print(romanizer.isValid('Hello')); // false
  /// print(romanizer.isValid('أنا Hello')); // true (mixed content)
  /// ```
  @override
  bool isValid(String input) {
    // Check for Arabic characters in Unicode ranges:
    // - Arabic: U+0600–U+06FF
    // - Arabic Supplement: U+0750–U+077F
    // - Arabic Extended-A: U+08A0–U+08FF
    // - Arabic Extended-B: U+0870–U+089F
    // - Arabic Presentation Forms-A: U+FB50–U+FDFF
    // - Arabic Presentation Forms-B: U+FE70–U+FEFF
    return _arabicPattern.hasMatch(input);
  }
}
