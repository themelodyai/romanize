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

  @override
  bool isValid(String input) {
    return kanaKit.isMixed(input);
  }

  @override
  String romanize(String input) {
    return kanaKit.toRomaji(input);
  }
}
