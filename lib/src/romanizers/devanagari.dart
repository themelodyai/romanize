import 'package:romanize/romanize.dart';

/// The transliteration system to use for [DevanagariRomanizer].
enum DevanagariSystem {
  /// IAST — International Alphabet of Sanskrit Transliteration.
  ///
  /// Uses diacritics to preserve distinctions between long/short vowels and
  /// retroflex/dental consonants.
  ///
  /// Example: 'भारत' -> 'bhārata'
  iast,

  /// ASCII — plain Latin letters without diacritics.
  ///
  /// Long vowels are doubled (`ā` -> `aa`) and retroflex consonants fall back
  /// to their dental counterparts (`ṭ` -> `t`, `ṣ` -> `sh`).
  ///
  /// Example: 'भारत' -> 'bhaarata'
  ascii,
}

/// A romanizer for the Devanagari script.
///
/// Transliterates Devanagari text (used by Hindi, Marathi, Sanskrit, Nepali,
/// and others) into Latin script using the IAST / ISO 15919 standard.
class DevanagariRomanizer extends Romanizer {
  /// Creates a Devanagari romanizer with the specified [system].
  ///
  /// Defaults to [DevanagariSystem.iast].
  const DevanagariRomanizer({this.system = DevanagariSystem.iast})
    : super(language: RomanizerSystem.devanagari);

  /// The transliteration system to use.
  final DevanagariSystem system;

  // Independent vowels.
  static const Map<String, String> _vowelsIast = {
    'अ': 'a',
    'आ': 'ā',
    'इ': 'i',
    'ई': 'ī',
    'उ': 'u',
    'ऊ': 'ū',
    'ऋ': 'ṛ',
    'ॠ': 'ṝ',
    'ऌ': 'ḷ',
    'ॡ': 'ḹ',
    'ए': 'e',
    'ऐ': 'ai',
    'ओ': 'o',
    'औ': 'au',
  };

  static const Map<String, String> _vowelsAscii = {
    'अ': 'a',
    'आ': 'aa',
    'इ': 'i',
    'ई': 'ii',
    'उ': 'u',
    'ऊ': 'uu',
    'ऋ': 'ri',
    'ॠ': 'rii',
    'ऌ': 'li',
    'ॡ': 'lii',
    'ए': 'e',
    'ऐ': 'ai',
    'ओ': 'o',
    'औ': 'au',
  };

  // Dependent vowel signs (matras). They replace a consonant's inherent 'a'.
  static const Map<String, String> _vowelSignsIast = {
    'ा': 'ā',
    'ि': 'i',
    'ी': 'ī',
    'ु': 'u',
    'ू': 'ū',
    'ृ': 'ṛ',
    'ॄ': 'ṝ',
    'ॢ': 'ḷ',
    'ॣ': 'ḹ',
    'े': 'e',
    'ै': 'ai',
    'ो': 'o',
    'ौ': 'au',
  };

  static const Map<String, String> _vowelSignsAscii = {
    'ा': 'aa',
    'ि': 'i',
    'ी': 'ii',
    'ु': 'u',
    'ू': 'uu',
    'ृ': 'ri',
    'ॄ': 'rii',
    'ॢ': 'li',
    'ॣ': 'lii',
    'े': 'e',
    'ै': 'ai',
    'ो': 'o',
    'ौ': 'au',
  };

  // Consonants without the inherent 'a' (added contextually in [romanize]).
  static const Map<String, String> _consonantsIast = {
    'क': 'k', 'ख': 'kh', 'ग': 'g', 'घ': 'gh', 'ङ': 'ṅ',
    'च': 'c', 'छ': 'ch', 'ज': 'j', 'झ': 'jh', 'ञ': 'ñ',
    'ट': 'ṭ', 'ठ': 'ṭh', 'ड': 'ḍ', 'ढ': 'ḍh', 'ण': 'ṇ',
    'त': 't', 'थ': 'th', 'द': 'd', 'ध': 'dh', 'न': 'n',
    'प': 'p', 'फ': 'ph', 'ब': 'b', 'भ': 'bh', 'म': 'm',
    'य': 'y', 'र': 'r', 'ल': 'l', 'व': 'v',
    'श': 'ś', 'ष': 'ṣ', 'स': 's', 'ह': 'h',
    'ळ': 'ḷ', 'ऱ': 'ṟ', 'ऴ': 'ḻ',
    // Precomposed nukta consonants (Devanagari letters QA..YYA).
    '\u0958': 'q', // क़
    '\u0959': 'x', // ख़
    '\u095A': 'ġ', // ग़
    '\u095B': 'z', // ज़
    '\u095C': 'ṛ', // ड़
    '\u095D': 'ṛh', // ढ़
    '\u095E': 'f', // फ़
    '\u095F': 'ẏ', // य़
  };

  static const Map<String, String> _consonantsAscii = {
    'क': 'k', 'ख': 'kh', 'ग': 'g', 'घ': 'gh', 'ङ': 'ng',
    'च': 'ch', 'छ': 'chh', 'ज': 'j', 'झ': 'jh', 'ञ': 'ny',
    'ट': 't', 'ठ': 'th', 'ड': 'd', 'ढ': 'dh', 'ण': 'n',
    'त': 't', 'थ': 'th', 'द': 'd', 'ध': 'dh', 'न': 'n',
    'प': 'p', 'फ': 'ph', 'ब': 'b', 'भ': 'bh', 'म': 'm',
    'य': 'y', 'र': 'r', 'ल': 'l', 'व': 'v',
    'श': 'sh', 'ष': 'sh', 'स': 's', 'ह': 'h',
    'ळ': 'l', 'ऱ': 'r', 'ऴ': 'l',
    '\u0958': 'q', // क़
    '\u0959': 'x', // ख़
    '\u095A': 'g', // ग़
    '\u095B': 'z', // ज़
    '\u095C': 'r', // ड़
    '\u095D': 'rh', // ढ़
    '\u095E': 'f', // फ़
    '\u095F': 'y', // य़
  };

  // Nukta consonant forms encoded as base consonant + U+093C.
  static const Map<String, String> _nuktaConsonantsIast = {
    'क': 'q',
    'ख': 'x',
    'ग': 'ġ',
    'ज': 'z',
    'ड': 'ṛ',
    'ढ': 'ṛh',
    'फ': 'f',
    'य': 'ẏ',
  };

  static const Map<String, String> _nuktaConsonantsAscii = {
    'क': 'q',
    'ख': 'x',
    'ग': 'g',
    'ज': 'z',
    'ड': 'r',
    'ढ': 'rh',
    'फ': 'f',
    'य': 'y',
  };

  // Marks (anusvara, visarga, candrabindu).
  static const Map<String, String> _marksIast = {
    'ं': 'ṃ', // Anusvara
    'ः': 'ḥ', // Visarga
    'ँ': 'm̐', // Candrabindu
  };

  // ASCII marks: nasal assimilation (e.g. 'संग' -> 'sang') is not applied.
  static const Map<String, String> _marksAscii = {
    'ं': 'n', // Anusvara
    'ः': 'h', // Visarga
    'ँ': 'n', // Candrabindu
  };

  static const Map<String, String> _digits = {
    '०': '0',
    '१': '1',
    '२': '2',
    '३': '3',
    '४': '4',
    '५': '5',
    '६': '6',
    '७': '7',
    '८': '8',
    '९': '9',
  };

  static const int _nuktaMark = 0x093C; // ़
  static const String _virama = '\u094D'; // ्

  static final _devanagariPattern = RegExp(
    r'[\u0900-\u097F\uA8E0-\uA8FF\u1CD0-\u1CFF]',
  );

  @override
  String romanize(String input) {
    if (input.isEmpty) return input;

    final ascii = system == DevanagariSystem.ascii;
    final vowels = ascii ? _vowelsAscii : _vowelsIast;
    final vowelSigns = ascii ? _vowelSignsAscii : _vowelSignsIast;
    final consonants = ascii ? _consonantsAscii : _consonantsIast;
    final nuktaConsonants = ascii
        ? _nuktaConsonantsAscii
        : _nuktaConsonantsIast;
    final marks = ascii ? _marksAscii : _marksIast;

    final buffer = StringBuffer();
    final runes = input.runes.toList();
    var pendingInherentA = false;

    for (int i = 0; i < runes.length; i++) {
      final char = String.fromCharCode(runes[i]);

      // Nukta consonant: base consonant immediately followed by U+093C.
      if (i + 1 < runes.length &&
          runes[i + 1] == _nuktaMark &&
          nuktaConsonants.containsKey(char)) {
        if (pendingInherentA) {
          buffer.write('a');
          pendingInherentA = false;
        }
        buffer.write(nuktaConsonants[char]);
        pendingInherentA = true;
        i++;
        continue;
      }

      // Dependent vowel sign: replaces the consonant's inherent 'a'.
      if (vowelSigns.containsKey(char)) {
        buffer.write(vowelSigns[char]);
        pendingInherentA = false;
        continue;
      }

      // Virama: cancels the inherent 'a'.
      if (char == _virama) {
        pendingInherentA = false;
        continue;
      }

      // Consonant (including precomposed nukta forms).
      if (consonants.containsKey(char)) {
        if (pendingInherentA) {
          buffer.write('a');
          pendingInherentA = false;
        }
        buffer.write(consonants[char]);
        pendingInherentA = true;
        continue;
      }

      // Independent vowel.
      if (vowels.containsKey(char)) {
        if (pendingInherentA) {
          buffer.write('a');
          pendingInherentA = false;
        }
        buffer.write(vowels[char]);
        continue;
      }

      // Marks, digits, punctuation, Latin, or anything else.
      if (pendingInherentA) {
        buffer.write('a');
        pendingInherentA = false;
      }
      buffer.write(marks[char] ?? _digits[char] ?? char);
    }

    if (pendingInherentA) {
      buffer.write('a');
    }

    return buffer.toString();
  }

  @override
  bool isValid(String input) {
    return _devanagariPattern.hasMatch(input);
  }
}
