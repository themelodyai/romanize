library;

import 'package:romanize/src/romanize_base.dart';
import 'package:romanize/src/romanizers/japanese.dart';
import 'package:romanize/src/romanizers/korean.dart';

export 'src/romanize_base.dart';

class TextRomanizer {
  static const romanizers = <Romanizer>[KoreanRomanizer(), JapaneseRomanizer()];

  static String romanize(String input) {
    for (final romanizer in romanizers) {
      if (romanizer.isValid(input)) {
        return romanizer.romanize(input);
      }
    }
    throw ArgumentError('No valid Romanizer found for the input: $input');
  }

  static Romanizer forLanguage(String language) {
    return romanizers.firstWhere(
      (romanizer) => romanizer.language.toLowerCase() == language.toLowerCase(),
      orElse: () => throw UnimplementedError(
        'No Romanizer found for the language: $language',
      ),
    );
  }

  static Romanizer? forLanguageOrNull(String? language) {
    if (language == null) return null;
    try {
      return romanizers.firstWhere(
        (romanizer) =>
            romanizer.language.toLowerCase() == language.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
