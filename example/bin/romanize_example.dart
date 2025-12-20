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

void _multiLanguages() {
  // from home nct u
  final multiLanguagesText = '''
Ooh, yeah-yeah-yeah
I remember like it's yesterday, oh-no
외로움에 힘들던 그때 oh-ooh
낯설기만 하던 이 공기도
두렵기만 하던 이 떨림도
Now I know
그 어렸던 마음까지 모두
추억이 되게 해준 너
Cause of us I'm feeling strong again
서로 믿어줄 때면
이곳에 날 당연하게 해
When we shine bright
I'm alive in the CT 날 노래해
이 조명 아래 서로를 바라보면
나도 몰래 웃게 돼 다 잊게 돼 yeah
Cause I'm not alone
내게 따듯한 집이 돼준 너
어제와 지금의 나 또 다가올 내일 우리
It all starts from home
彩虹是和你再见的誓言
飘过初雪到仲夏的夜
直到和你眼神交会
拥抱让我遗落寂寞 ooh
随时能和你连结 为你回应
見つけたよ ココロが安らぐ
My home, my own (My own)
映照着自己 感受到笑意都一往如初
Once again (Ooh)
僕ら強くなれる
活成彼此的阳光
我的存在自然而耀眼
When we shine bright
I'm alive in the CT 날 노래해
이 조명 아래 서로를 바라보면
나도 몰래 웃게 돼 다 잊게 돼 yeah
Cause I'm not alone
내게 따듯한 집이 돼준 너
어제와 지금의 나 또 다가올 내일 우리
It all starts from home
이젠 길을 잃을 두려움도
겁내기 바빴던 날들도
Now It's all gone and I
Found a reason to be myself
Know that you are not alone anymore
When we shine bright
I'm alive in the CT 날 노래해
이 조명 아래 서로를 바라보면
나도 몰래 웃게 돼 다 잊게 돼 yeah
Cause I'm not alone
내게 따듯한 집이 돼준 너 (어제와 지금의 나)
어제와 지금의 나 또 다가올 내일 우리
It all starts from home
Na-na-na, na-na-na, na-na-na
From home (From home)
Na-na-na, na-na-na, from home
Yeah-yeah-yeah
Na-na-na (Na-na-na)
Na-na-na (Na-na-na)
Na-na-na
From home
And we start from here our home
''';
  final multiLanguagesOutput = TextRomanizer.romanize(multiLanguagesText);
  print('Multi Languages Romanization: \n$multiLanguagesOutput');
}
