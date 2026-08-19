import 'package:test/test.dart';
// Note: Adjust this import based on how the package exports the romanizers.
import 'package:romanize/romanize.dart';

void main() {
  group('GreekRomanizer', () {
    late GreekRomanizer romanizer;

    setUp(() {
      romanizer = const GreekRomanizer();
    });

    test('language identifier is "greek"', () {
      expect(romanizer.language, 'greek');
    });

    group('isValid', () {
      test('returns true for Greek text', () {
        expect(romanizer.isValid('Καλημέρα'), isTrue);
        expect(romanizer.isValid('Αθήνα'), isTrue);
        expect(romanizer.isValid('ωμέγα'), isTrue);
      });

      test('returns false for non-Greek text', () {
        expect(romanizer.isValid('Hello World'), isFalse);
        expect(romanizer.isValid('1234567890'), isFalse);
        expect(romanizer.isValid('!@#\$%^&*()'), isFalse);
        expect(romanizer.isValid('Привет'), isFalse); // Cyrillic
      });

      test('returns true for strings containing mixed scripts', () {
        expect(romanizer.isValid('Hello Καλημέρα'), isTrue);
        expect(romanizer.isValid('Version 2.0 (Άλφα)'), isTrue);
      });
    });

    group('romanize', () {
      test('romanizes standard lowercase letters', () {
        expect(
          romanizer.romanize('αβγδεζηθικλμνξοπρστυφχψω'),
          'avgdezithiklmnxoprstyfchpso',
        );
      });

      test('romanizes standard uppercase letters', () {
        expect(
          romanizer.romanize('ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ'),
          'AVGDEZIThIKLMNXOPRSTYFChPsO',
        );
      });

      test('romanizes words with accents (tonos) correctly', () {
        expect(romanizer.romanize('Καλημέρα'), 'Kalimera');
        expect(romanizer.romanize('Αθήνα'), 'Athina');
        expect(romanizer.romanize('άέήίόύώ'), 'aeiioyo');
      });

      test('romanizes words with diaeresis (dialytika) correctly', () {
        expect(romanizer.romanize('Μαΐου'), 'Maiou');
        expect(romanizer.romanize('γαϊδούρι'), 'gaidouri');
      });

      test(
        'handles the "ου" (ou) digraph correctly without mapping to "oy"',
        () {
          expect(romanizer.romanize('ουρανός'), 'ouranos');
          expect(romanizer.romanize('Ουρανός'), 'Ouranos');
          expect(romanizer.romanize('ΟΥΡΑΝΟΣ'), 'OURANOS');
          expect(romanizer.romanize('πού'), 'pou'); // With accent
        },
      );

      test('handles the final sigma (ς) correctly', () {
        expect(romanizer.romanize('σεισμός'), 'seismos');
        expect(romanizer.romanize('πώς'), 'pos');
      });

      test('preserves punctuation, numbers, spaces, and English letters', () {
        expect(
          romanizer.romanize('Γεια σου, World! 123'),
          'Geia sou, World! 123',
        );
        expect(
          romanizer.romanize('email-διεύθυνση: test@παράδειγμα.com'),
          'email-dieythynsi: test@paradeigma.com',
        );
      });

      test('returns input unchanged if it contains no Greek characters', () {
        expect(romanizer.romanize('Hello World!'), 'Hello World!');
        expect(romanizer.romanize('12345'), '12345');
      });
    });
  });

  group('GreekRomanizerOptions - preserveAccents', () {
    late GreekRomanizer accentedRomanizer;

    setUp(() {
      accentedRomanizer = const GreekRomanizer(
        options: GreekRomanizerOptions(preserveAccents: true),
      );
    });

    test('preserves the tonos (stress accent) on standard words', () {
      expect(accentedRomanizer.romanize('Καλημέρα'), 'Kaliméra');
      expect(accentedRomanizer.romanize('Αθήνα'), 'Athína');
      expect(accentedRomanizer.romanize('άέήίόύώ'), 'áéííóýó');
      expect(accentedRomanizer.romanize('ΆΈΉΊΌΎΏ'), 'ÁÉÍÍÓÝÓ');
    });

    test('preserves the dialytika (diaeresis)', () {
      // 'Μαΐου' has BOTH dialytika and tonos on the iota (ΐ)
      expect(accentedRomanizer.romanize('Μαΐου'), 'Maḯou');

      // 'τρόλεϊ' has ONLY dialytika on the iota (ϊ)
      expect(accentedRomanizer.romanize('τρόλεϊ'), 'tróleï');

      // 'γαϊδούρι' has ONLY dialytika on the iota (ϊ), and a tonos on the ou (ού)
      expect(accentedRomanizer.romanize('γαϊδούρι'), 'gaïdoúri');
    });

    test('handles the accented "ού" (ou) digraph correctly', () {
      // Here, the accent moves to the 'u' in 'ou' as per standard convention
      expect(accentedRomanizer.romanize('πού'), 'poú');
      expect(accentedRomanizer.romanize('ακούω'), 'akoúo');
    });

    test('does not affect unaccented characters', () {
      expect(
        accentedRomanizer.romanize('αβγδεζηθικλμνξοπρστυφχψω'),
        'avgdezithiklmnxoprstyfchpso',
      );
    });
  });
}
