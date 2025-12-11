import 'package:kana_kit/kana_kit.dart';
import 'package:romanize/romanize.dart';

class JapaneseRomanizer extends Romanizer {
  const JapaneseRomanizer() : super(language: 'japanese');

  static const kanaKit = KanaKit(
    config: KanaKitConfig(
      passRomaji: true,
      passKanji: true,
      upcaseKatakana: false,
    ),
  );

  @override
  bool isValid(String input) {
    // Check for Japanese characters in Unicode ranges:
    // - Hiragana: U+3040–U+309F
    // - Katakana: U+30A0–U+30FF
    // - Kanji: U+4E00–U+9FFF
    // - Full-width Katakana: U+FF66–U+FF9F
    // - Punctuation: U+30FB–U+30FC
    // - Punctuation: U+FF61–U+FF65
    // - Punctuation: U+3000–U+303F
    return RegExp(
      r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFF\uFF66-\uFF9F\u30FB-\u30FC\uFF61-\uFF65\u3000-\u303F]',
    ).hasMatch(input);
  }

  @override
  String romanize(String input) {
    return kanaKit.toRomaji(input);
  }
}
