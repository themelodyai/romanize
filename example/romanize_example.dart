import 'package:romanize/romanize.dart';

void main() {
  final koreanText = '''
Yeah, yeah, yeah
BLACKPINK in your area
Yeah, yeah, yeah
천사 같은 "Hi" 끝엔 악마 같은 "Bye"
매번 미칠듯한 high 뒤엔 뱉어야 하는 price
이건 답이 없는 test
매번 속더라도 yes
딱한 감정의 노예
얼어 죽을 사랑해 yeah
''';
  final koreanOutput = TextRomanizer.forLanguage('korean').romanize(koreanText);
  print('Korean Romanization: \n$koreanOutput');

  final japaneseText = '''
Look at me, look at you
苦しい どっちが you smart (you smart)
誰? You are
両目 涙 赤にしたら so sorry (sorry)
誰? You are
どうして 泣かないようにしても
いっそのこと目を伏せ
この愛 トドメ刺すきっと''';

  final japaneseOutput = TextRomanizer.forLanguage(
    'japanese',
  ).romanize(japaneseText);
  print('Japanese Romanization: \n$japaneseOutput');

  final arabicText = '''
أنا العربي ولد الغابة والحجل، دلالي
دلالي، دلالي
دنا، دنا، دنا، دنا، دنا، دنا ودنا ودنا دايني دلالي
قيلوني دلالي
''';

  final arabicOutput = TextRomanizer.forLanguage('arabic').romanize(arabicText);
  print('Arabic Romanization: \n$arabicOutput');
}
