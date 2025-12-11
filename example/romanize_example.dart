import 'package:romanize/romanize.dart';

void main() {
  _korean();
  _japanese();
  _arabic();
  _cyrillic();
  _chinese();
}

void _korean() {
  final koreanText = '''
천사 같은 "Hi" 끝엔 악마 같은 "Bye"
매번 미칠듯한 high 뒤엔 뱉어야 하는 price
이건 답이 없는 test
매번 속더라도 yes
딱한 감정의 노예
얼어 죽을 사랑해 yeah
''';
  final koreanOutput = TextRomanizer.forLanguage('korean').romanize(koreanText);
  print('Korean Romanization: \n$koreanOutput');
}

void _japanese() {
  final japaneseText = '''
Look at me, look at you
苦しい どっちが you smart (you smart)
誰? You are
両目 涙 赤にしたら so sorry (sorry)
誰? You are
どうして 泣かないようにしても
いっそのこと目を伏せ
この愛 トドメ刺すきっと
''';
  final japaneseOutput = TextRomanizer.forLanguage(
    'japanese',
  ).romanize(japaneseText);
  print('Japanese Romanization: \n$japaneseOutput');
}

void _arabic() {
  final arabicText = '''
أنا العربي ولد الغابة والحجل، دلالي
دلالي، دلالي
دنا، دنا، دنا، دنا، دنا، دنا ودنا ودنا دايني دلالي
قيلوني دلالي
''';
  final arabicOutput = TextRomanizer.forLanguage('arabic').romanize(arabicText);
  print('Arabic Romanization: \n$arabicOutput');
}

void _cyrillic() {
  final cyrillicText = '''
Lorem Ipsum - это текст-"рыба", часто используемый в печати и вэб-дизайне.
Lorem Ipsum является стандартной "рыбой" для текстов на латинице с начала XVI 
века. В то время некий безымянный печатник создал большую коллекцию размеров и 
форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не 
только успешно пережил без заметных изменений пять веков, но и перешагнул в 
электронный дизайн. Его популяризации в новое время послужили публикация листов 
Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, 
программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых 
используется Lorem Ipsum.
''';
  final cyrillicOutput = TextRomanizer.forLanguage(
    'cyrillic',
  ).romanize(cyrillicText);
  print('Cyrillic Romanization: \n$cyrillicOutput');
}

void _chinese() {
  final chineseText = '''
When you lookin' at me, I'm so off my face
就像我們之間心動的感覺
完美瞬間不是簡單的遇見
Ain't it poppin' love, poppin' love, poppin' love, yeah
''';
  final chineseOutput = TextRomanizer.forLanguage(
    'chinese',
  ).romanize(chineseText);
  print('Chinese Romanization: \n$chineseOutput');
}
