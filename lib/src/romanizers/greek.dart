import 'package:romanize/romanize.dart';

/// Configuration options for the [GreekRomanizer].
class GreekRomanizerOptions {
  /// Whether to preserve the Greek stress accent (tonos) and diaeresis
  /// in the Romanized output using Latin diacritics.
  ///
  /// If true: 'Καλημέρα' -> 'Kaliméra'
  /// If false: 'Καλημέρα' -> 'Kalimera'
  final bool preserveAccents;

  const GreekRomanizerOptions({this.preserveAccents = false});
}

/// A [Romanizer] implementation for the Greek language.
class GreekRomanizer extends Romanizer {
  /// The configuration options for this romanizer.
  final GreekRomanizerOptions options;

  /// Creates a new [GreekRomanizer] instance.
  const GreekRomanizer({this.options = const GreekRomanizerOptions()})
    : super(language: RomanizerSystem.greek);

  // Standard Greek to Latin character mapping (Accents stripped).
  static const Map<String, String> _baseCharMap = {
    'Α': 'A', 'Β': 'V', 'Γ': 'G', 'Δ': 'D', 'Ε': 'E', 'Ζ': 'Z',
    'Η': 'I', 'Θ': 'Th', 'Ι': 'I', 'Κ': 'K', 'Λ': 'L', 'Μ': 'M',
    'Ν': 'N', 'Ξ': 'X', 'Ο': 'O', 'Π': 'P', 'Ρ': 'R', 'Σ': 'S',
    'Τ': 'T', 'Υ': 'Y', 'Φ': 'F', 'Χ': 'Ch', 'Ψ': 'Ps', 'Ω': 'O',
    'α': 'a', 'β': 'v', 'γ': 'g', 'δ': 'd', 'ε': 'e', 'ζ': 'z',
    'η': 'i', 'θ': 'th', 'ι': 'i', 'κ': 'k', 'λ': 'l', 'μ': 'm',
    'ν': 'n', 'ξ': 'x', 'ο': 'o', 'π': 'p', 'ρ': 'r', 'σ': 's',
    'ς': 's', 'τ': 't', 'υ': 'y', 'φ': 'f', 'χ': 'ch', 'ψ': 'ps',
    'ω': 'o',

    // Tonos and Diaeresis mapped to plain Latin characters
    'Ά': 'A', 'Έ': 'E', 'Ή': 'I', 'Ί': 'I', 'Ό': 'O', 'Ύ': 'Y', 'Ώ': 'O',
    'Ϊ': 'I', 'Ϋ': 'Y',
    'ά': 'a', 'έ': 'e', 'ή': 'i', 'ί': 'i', 'ό': 'o', 'ύ': 'y', 'ώ': 'o',
    'ϊ': 'i', 'ϋ': 'y', 'ΐ': 'i', 'ΰ': 'y',
  };

  // Greek to Latin mapping preserving accents (Acute and Diaeresis).
  static const Map<String, String> _accentedCharMap = {
    'Ά': 'Á',
    'Έ': 'É',
    'Ή': 'Í',
    'Ί': 'Í',
    'Ό': 'Ó',
    'Ύ': 'Ý',
    'Ώ': 'Ó',
    'Ϊ': 'Ï',
    'Ϋ': 'Ÿ',
    'ά': 'á',
    'έ': 'é',
    'ή': 'í',
    'ί': 'í',
    'ό': 'ó',
    'ύ': 'ý',
    'ώ': 'ó',
    'ϊ': 'ï',
    'ϋ': 'ÿ',
    'ΐ': 'ḯ',
    'ΰ': 'ÿ́',
  };

  @override
  bool isValid(String input) {
    return RegExp(r'[\u0370-\u03FF\u1F00-\u1FFF]').hasMatch(input);
  }

  @override
  String romanize(String input) {
    if (!isValid(input)) return input;

    // Determine the target replacement for the "ou" digraph based on options
    final ouLower = options.preserveAccents ? 'oú' : 'ou';
    final ouUpper = options.preserveAccents ? 'Oú' : 'Ou';
    final ouAllUpper = options.preserveAccents ? 'OÚ' : 'OU';

    // Pre-process digraphs to avoid mapping 'υ' to 'y' or 'ý'
    String processed = input
        .replaceAll('ού', ouLower)
        .replaceAll('ου', 'ou')
        .replaceAll('Ού', ouUpper)
        .replaceAll('Ου', 'Ou')
        .replaceAll('ΟΎ', ouAllUpper)
        .replaceAll('ΟΥ', 'OU');

    final buffer = StringBuffer();

    for (int i = 0; i < processed.length; i++) {
      final char = processed[i];

      // If preserveAccents is true, check the accented map first.
      // If it's not an accented character (or if preserveAccents is false),
      // fall back to the base map. If not in the base map, keep original.
      String? mappedChar;
      if (options.preserveAccents) {
        mappedChar = _accentedCharMap[char];
      }
      mappedChar ??= _baseCharMap[char];

      buffer.write(mappedChar ?? char);
    }

    return buffer.toString();
  }
}
