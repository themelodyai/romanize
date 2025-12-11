import 'package:kana_kit/kana_kit.dart';
import 'package:romanize/romanize.dart';

class JapaneseRomanizer extends Romanizer {
  const JapaneseRomanizer() : super(language: 'japanese');

  static const kanaKit = KanaKit(
    config: KanaKitConfig(
      passRomaji: true,
      passKanji: false,
      upcaseKatakana: false,
    ),
  );

  static final _japanesePattern = RegExp(
    r'[\u3040-\u309F\u30A0-\u30FF\uFF66-\uFF9F]',
  );

  @override
  String romanize(String input) {
    return kanaKit.toRomaji(input);
  }

  @override
  bool isValid(String input) {
    return _japanesePattern.hasMatch(input);
  }
}
