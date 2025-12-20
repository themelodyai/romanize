import 'package:kana_kit/kana_kit.dart';
import 'package:kuromoji/kuromoji.dart';
// ignore: implementation_imports
import 'package:kuromoji/src/tokenizer.dart';
import 'package:romanize/romanize.dart';

class JapaneseRomanizer extends Romanizer {
  JapaneseRomanizer() : super(language: 'japanese');

  static const kanaKit = KanaKit(
    config: KanaKitConfig(
      passRomaji: true,
      passKanji: false,
      upcaseKatakana: false,
    ),
  );

  static final _japanesePattern = RegExp(
    r'[\u3040-\u309F\u30A0-\u30FF\uFF66-\uFF9F\u4E00-\u9FAF]',
  );

  static Tokenizer? _tokenizer;

  /// Initializes the Kuromoji tokenizer with the provided dictionary path.
  /// This must be called before using [romanize] for Kanji support.
  static Future<void> init() async {
    try {
      _tokenizer ??= await TokenizerBuilder().build();
    } catch (_) {}
  }

  /// Romanizes the given Japanese text to Romaji.
  ///
  /// If the Kuromoji tokenizer is initialized, it will use it to convert Kanji
  /// to their readings before romanization.
  ///
  /// Otherwise, it will directly romanize the input assuming it's in Kana.
  @override
  String romanize(String input) {
    if (input.trim().isEmpty) return input;
    if (_tokenizer != null) {
      try {
        final tokens = _tokenizer!.tokenize(
          input
          // Kurumoji has a problem with full stop "。" characters.
          // Replace them with "."
          .replaceAll('。', '.'),
        );
        final buffer = StringBuffer();
        for (final token in tokens) {
          if (token.isEmpty) continue;
          if (token['reading'] != null &&
              token['reading'].isNotEmpty &&
              token['reading'] != '*') {
            buffer.write(kanaKit.toRomaji(token['reading']));
          } else {
            buffer.write(kanaKit.toRomaji(token['surface_form']));
          }
        }
        return buffer.toString();
      } catch (_) {
        // Fallback to direct romanization if tokenization fails
      }
    }
    return kanaKit.toRomaji(input);
  }

  @override
  bool isValid(String input) {
    return _japanesePattern.hasMatch(input);
  }
}
