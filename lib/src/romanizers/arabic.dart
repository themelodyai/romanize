import 'package:romanize/romanize.dart';

/// Specifies the romanization system to use for Arabic.
enum ArabicSystem {
  /// The ALA-LC (American Library Association – Library of Congress) romanization.
  ///
  /// This is a common academic standard that uses digraphs (e.g., 'sh', 'th', 'kh')
  /// and is generally easier for English speakers to read.
  ///
  /// Example: 'شمس' -> 'shams'
  alaLc,

  /// The DIN 31635 standard (Deutsches Institut für Normung).
  ///
  /// This system provides a strict 1-to-1 mapping using diacritics (e.g., 'š', 'ṯ', 'ḫ').
  /// It is widely used in Arabic studies and Germany.
  ///
  /// Example: 'شمس' -> 'šams'
  din31635,

  /// The Buckwalter Transliteration.
  ///
  /// A strict 1-to-1 mapping using only ASCII characters. It is heavily used
  /// in Natural Language Processing (NLP) and data storage.
  ///
  /// Example: 'شمس' -> '$ms'
  buckwalter,
}

/// A romanizer for Arabic script.
///
/// Supports transliteration of Arabic characters into Latin script using
/// various standards (ALA-LC, DIN 31635, Buckwalter).
class ArabicRomanizer extends Romanizer {
  /// Creates an Arabic romanizer with the specified [system].
  ///
  /// Defaults to [ArabicSystem.alaLc].
  const ArabicRomanizer({this.system = ArabicSystem.alaLc})
    : super(language: 'arabic');

  final ArabicSystem system;

  // --- Mappings ---

  // ALA-LC (Base/Current)
  static const Map<String, String> _alaLcMap = {
    // Note: 'ا' (Alef) is handled dynamically in the romanize method
    // to distinguish between initial 'a' and medial/final 'ā'.
    // We map it to 'ā' here as the default for lookup if logic falls through.
    'ا': 'ā',
    'أ': 'a', 'إ': 'i', 'آ': 'ā', 'ٱ': 'a',
    'ب': 'b', 'ت': 't', 'ث': 'th', 'ج': 'j', 'ح': 'ḥ', 'خ': 'kh',
    'د': 'd', 'ذ': 'dh', 'ر': 'r', 'ز': 'z', 'س': 's', 'ش': 'sh',
    'ص': 'ṣ', 'ض': 'ḍ', 'ط': 'ṭ', 'ظ': 'ẓ', 'ع': 'ʿ', 'غ': 'gh',
    'ف': 'f', 'ق': 'q', 'ك': 'k', 'ل': 'l', 'م': 'm', 'ن': 'n',
    'ه': 'h', 'ة': 'h', 'و': 'w', 'ؤ': 'u', 'ي': 'y', 'ى': 'ā',
    'ئ': 'i', 'ء': 'ʾ',
    'َ': 'a', 'ُ': 'u', 'ِ': 'i',
    'ً': 'an', 'ٌ': 'un', 'ٍ': 'in',
    'ّ': '', 'ْ': '', 'ٰ': 'ā',
    '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4',
    '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9',
  };

  // DIN 31635 (Uses diacritics for digraphs)
  static const Map<String, String> _din31635Map = {
    'ا': 'ā',
    'أ': 'ʾ',
    'إ': 'ʾ',
    'آ': 'ʾā',
    'ٱ': 'hw',
    'ب': 'b',
    'ت': 't',
    'ث': 'ṯ',
    'ج': 'ǧ',
    'ح': 'ḥ',
    'خ': 'ḫ',
    'د': 'd',
    'ذ': 'ḏ',
    'ر': 'r',
    'ز': 'z',
    'س': 's',
    'ش': 'š',
    'ص': 'ṣ',
    'ض': 'ḍ',
    'ط': 'ṭ',
    'ظ': 'ẓ',
    'ع': 'ʿ',
    'غ': 'ġ',
    'ف': 'f',
    'ق': 'q',
    'ك': 'k',
    'ل': 'l',
    'م': 'm',
    'ن': 'n',
    'ه': 'h',
    'ة': 'h',
    'و': 'w',
    'ؤ': 'u',
    'ي': 'y',
    'ى': 'ā',
    'ئ': 'ʾ',
    'ء': 'ʾ',
    'َ': 'a',
    'ُ': 'u',
    'ِ': 'i',
    'ً': 'an',
    'ٌ': 'un',
    'ٍ': 'in',
    'ّ': '',
    'ْ': '',
    'ٰ': 'ā',
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

  // Buckwalter (ASCII only)
  static const Map<String, String> _buckwalterMap = {
    'ا': 'A',
    'أ': '>',
    'إ': '<',
    'آ': '|',
    'ٱ': '{',
    'ب': 'b',
    'ت': 't',
    'ث': 'v',
    'ج': 'j',
    'ح': 'H',
    'خ': 'x',
    'د': 'd',
    'ذ': '*',
    'ر': 'r',
    'ز': 'z',
    'س': 's',
    'ش': '\$',
    'ص': 'S',
    'ض': 'D',
    'ط': 'T',
    'ظ': 'Z',
    'ع': 'E',
    'غ': 'g',
    'ف': 'f',
    'ق': 'q',
    'ك': 'k',
    'ل': 'l',
    'م': 'm',
    'ن': 'n',
    'ه': 'h',
    'ة': 'p',
    'و': 'w',
    'ؤ': '&',
    'ي': 'y',
    'ى': 'Y',
    'ئ': '}',
    'ء': '\'',
    'َ': 'a',
    'ُ': 'u',
    'ِ': 'i',
    'ً': 'F',
    'ٌ': 'N',
    'ٍ': 'K',
    'ّ': '~',
    'ْ': 'o',
    'ٰ': '`',
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

  @override
  String romanize(String input) {
    final buffer = StringBuffer();
    final map = switch (system) {
      ArabicSystem.alaLc => _alaLcMap,
      ArabicSystem.din31635 => _din31635Map,
      ArabicSystem.buckwalter => _buckwalterMap,
    };

    final runes = input.runes.toList();

    for (int i = 0; i < runes.length; i++) {
      final char = runes[i];
      final charString = String.fromCharCode(char);

      // Special handling for ALA-LC Alef 'ا'
      if (system == ArabicSystem.alaLc && charString == 'ا') {
        final isStartOfWord = i == 0 || _isSeparator(runes[i - 1]);
        if (isStartOfWord) {
          buffer.write('a');
        } else {
          buffer.write('ā');
        }
        continue;
      }

      buffer.write(map[charString] ?? charString);
    }
    return buffer.toString();
  }

  /// Check for whitespace or common punctuation
  bool _isSeparator(int charCode) {
    return charCode == 32 || // Space
        charCode == 10 || // Newline
        charCode == 9 || // Tab
        charCode == 13 || // CR
        charCode == 46 || // .
        charCode == 44 || // ,
        charCode == 1548 || // ، (Arabic comma)
        charCode == 63 || // ?
        charCode == 1567; // ؟ (Arabic Question mark)
  }

  @override
  bool isValid(String input) {
    return _arabicPattern.hasMatch(input);
  }
}
