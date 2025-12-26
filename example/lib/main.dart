import 'package:romanize/romanize.dart';

void main() async {
  await TextRomanizer.ensureInitialized();
  _korean();
  _japanese();
  _arabic();
  _cyrillic();
  _chinese();
  _hebrew();
  _multiLanguages();
  _analyze();
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
  final koreanOutput = TextRomanizer.romanize(koreanText);
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
  final japaneseOutput = TextRomanizer.romanize(japaneseText);
  print('Japanese Romanization: \n$japaneseOutput');
}

void _arabic() {
  final arabicText = '''
أنا العربي ولد الغابة والحجل، دلالي
دلالي، دلالي
دنا، دنا، دنا، دنا، دنا، دنا ودنا ودنا دايني دلالي
قيلوني دلالي
''';
  final arabicOutput = TextRomanizer.romanize(arabicText);
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
  final cyrillicOutput = TextRomanizer.romanize(cyrillicText);
  print('Cyrillic Romanization: \n$cyrillicOutput');
}

void _chinese() {
  final chineseText = '''
When you lookin' at me, I'm so off my face
就像我們之間心動的感覺
完美瞬間不是簡單的遇見
Ain't it poppin' love, poppin' love, poppin' love, yeah
''';
  final chineseOutput = TextRomanizer.romanize(chineseText);
  print('Chinese Romanization: \n$chineseOutput');
}

void _hebrew() {
  final hebrewText = '''
בכפוף אירועים אל מלא. ויקי שאלות את אחד. הרוח ויקי אל בדף,
 ב אחד לערוך ומהימנה. על סדר בלשנות סוציולוגיה, מה מתוך מדריכים קרן. זאת או
 ברית תרבות פולנית, תיבת חשמל גיאוגרפיה מלא אם. גם ויש מונחים מועמדים גיאוגרפיה,
 שנתי בארגז על מדע, בהבנה העריכהגירסאות גם שכל. על כדי רביעי לחיבור.
''';
  final hebrewOutput = TextRomanizer.romanize(hebrewText);
  print('Hebrew Romanization: \n$hebrewOutput');
}

const multiLanguagesText = '''Mixed Script Stress Test:
-------------------------
1. CJK Ambiguity (Should detect Chinese vs Japanese context):
   中文 (Chinese) vs 日本語 (Japanese will likely fail)
   你好世界 (Hello World - CN) mixed with こんにちは (Hello - JP)
   東京 (Tokyo - JP/CN chars) vs 北京 (Beijing - CN)
   
2. RTL/LTR Alternation (Arabic/Hebrew/English):
   English -> العربية -> English -> עִבְרִית -> English
   Start: مرحبا (Marhaban) -> Middle: שָׁלוֹם (Shalom) -> End.
   Complex: "The letter 'ا' (Alif) and 'א' (Alef) start alphabets."

3. Diacritic Heavy (Vowelization Stress):
   Arabic: كَتَبَ الْوَلَدُ الرِّسَالَةَ (Kataba al-waladu ar-risalata)
   Hebrew: בְּרֵאשִׁית בָּרָא אֱלֹהִים אֵת הַשָּׁמַיִם וְאֵת הָאָרֶץ (Genesis 1:1)
   
4. Cyrillic & Extended Latin:
   Russian: Съешь же ещё этих мягких французских булок, да выпей чаю.
   Mixed: "Privet (Привет) means Hello."

5. Rapid Switching (Tokenization Stress):
   KR:안녕하세요_JP:こんにちは_CN:你好_RU:Привет_AR:مرحبا_HE:שָׁלוֹם
   123٤٥٦(Numbers)abc가나다(Hangul)カキク(Katakana)

6. Long Paragraph (Performance):
   Lorem ipsum dolor sit amet. 但是，如果我们切换到中文。
   Then back to English. そして日本語に切り替えます。
   Suddenly, Cyrillic appears: Внезапно появляется кириллица.
   Followed by Arabic: ويتبع ذلك العربية.
   And finally Hebrew: ולבסוף עברית.
   
   End of Stress Test.''';
void _multiLanguages() {
  final multiLanguagesOutput = TextRomanizer.romanize(multiLanguagesText);
  print('Multi Languages Romanization: \n$multiLanguagesOutput');
}

void _analyze() {
  final output = TextRomanizer.analyze(multiLanguagesText)
      .map(
        (e) {
          return e.romanizedText;
        },
      )
      .join('');
  print('Analyze Romanization: \n$output');
}
