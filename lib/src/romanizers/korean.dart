import 'package:romanize/romanize.dart';

class KoreanRomanizer extends Romanizer {
  const KoreanRomanizer() : super(language: 'korean');

  // Maps to standard Jamo initials (0-18)
  static const _initials = [
    'g',
    'kk',
    'n',
    'd',
    'tt',
    'r',
    'm',
    'b',
    'pp',
    's',
    'ss',
    '',
    'j',
    'jj',
    'ch',
    'k',
    't',
    'p',
    'h',
  ];

  // Maps to standard Jamo medials (0-20)
  static const _medials = [
    'a',
    'ae',
    'ya',
    'yae',
    'eo',
    'e',
    'yeo',
    'ye',
    'o',
    'wa',
    'wae',
    'oe',
    'yo',
    'u',
    'wo',
    'we',
    'wi',
    'yu',
    'eu',
    'ui',
    'i',
  ];

  // Maps to standard Jamo finals (0-27). Index 0 is "no final".
  static const _finals = [
    '',
    'k',
    'k',
    'ks',
    'n',
    'nj',
    'nh',
    't',
    'l',
    'lg',
    'lm',
    'lb',
    'ls',
    'lt',
    'lp',
    'lh',
    'm',
    'p',
    'bs',
    't',
    'ss',
    'ng',
    't',
    'ch',
    'k',
    't',
    'p',
    'h',
  ];

  // Constants for Hangul Unicode Math
  static const _baseCode = 0xAC00; // '가'
  static const _limitCode = 0xD7A3; // End of Hangul Syllables
  static const _finalCount = 28;
  static const _medialCount = 21;
  static const _itemsPerInitial = _medialCount * _finalCount; // 588

  // Fallback map for Standalone Jamo (e.g., just 'ㄱ' without a vowel)
  static const _standaloneJamo = <int, String>{
    // Initials (Consonants)
    0x3131: 'g', 0x3132: 'kk', 0x3134: 'n', 0x3137: 'd', 0x3138: 'tt',
    0x3139: 'r', 0x3141: 'm', 0x3142: 'b', 0x3143: 'pp', 0x3145: 's',
    0x3146: 'ss', 0x3147: '', 0x3148: 'j', 0x3149: 'jj', 0x314A: 'ch',
    0x314B: 'k', 0x314C: 't', 0x314D: 'p', 0x314E: 'h',
    // Medials (Vowels)
    0x314F: 'a', 0x3150: 'ae', 0x3151: 'ya', 0x3152: 'yae', 0x3153: 'eo',
    0x3154: 'e', 0x3155: 'yeo', 0x3156: 'ye', 0x3157: 'o', 0x3158: 'wa',
    0x3159: 'wae', 0x315A: 'oe', 0x315B: 'yo', 0x315C: 'u', 0x315D: 'wo',
    0x315E: 'we', 0x315F: 'wi', 0x3160: 'yu', 0x3161: 'eu', 0x3162: 'ui',
    0x3163: 'i',
  };

  @override
  String romanize(String input) {
    if (input.isEmpty) return input;

    final buffer = StringBuffer();

    final len = input.length;
    for (int i = 0; i < len; i++) {
      final charCode = input.codeUnitAt(i);

      // Check if it's a Hangul Syllable (Most common case)
      if (charCode >= _baseCode && charCode <= _limitCode) {
        final offset = charCode - _baseCode;

        final initialIdx = offset ~/ _itemsPerInitial;
        final medialIdx = (offset % _itemsPerInitial) ~/ _finalCount;
        final finalIdx = offset % _finalCount;

        buffer.write(_initials[initialIdx]);
        buffer.write(_medials[medialIdx]);
        buffer.write(_finals[finalIdx]);
      }
      // Handle Standalone Jamo (Rare, but supported)
      else if (_standaloneJamo.containsKey(charCode)) {
        buffer.write(_standaloneJamo[charCode]);
      }
      // Pass through everything else (Numbers, Punctuation)
      else {
        buffer.writeCharCode(charCode);
      }
    }

    return buffer.toString();
  }

  /// Validates if the input string is a valid Korean string.
  @override
  bool isValid(String input) {
    if (input.isEmpty) return false;
    return RegExp(r'[\uAC00-\uD7AF]').hasMatch(input);
  }
}
