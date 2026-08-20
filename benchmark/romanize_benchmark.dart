// Run the benchmark
// dart run benchmark_harness:bench --flavor aot --target=benchmark/romanize_benchmark.dart

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:romanize/romanize.dart';

/// Benchmark base that reports a single [BenchmarkBase.run] call.
///
/// The default [BenchmarkBase.exercise] invokes [BenchmarkBase.run] ten times,
/// so `report()` emits microseconds per ten runs rather than per run.
/// Overriding [exercise] keeps the reported number as per-call latency.
abstract class RomanizeBenchmark extends BenchmarkBase {
  RomanizeBenchmark(super.name);

  @override
  void exercise() => run();
}

/// Benchmark for Korean romanization
class KoreanRomanizeBenchmark extends RomanizeBenchmark {
  KoreanRomanizeBenchmark() : super('KoreanRomanize');

  static const koreanText = '로렘 입숨은 인쇄 및 조판 업계의 표준 더미 텍스트입니다.';
  static const koreanTextLong = '''
로렘 입숨은 인쇄 및 조판 업계의 표준 더미 텍스트입니다.
로렘 입숨은 1500년대부터 업계의 표준 더미 텍스트로 사용되어 왔습니다.
당시 한 무명의 인쇄업자가 활자 견본을 만들기 위해 활자 갤리를 가져와 뒤섞었습니다.
그것은 5세기뿐만 아니라 전자 조판으로의 도약까지도 본질적으로 변함없이 살아남았습니다.
1960년대에 로렘 입숨 구절이 담긴 레트라셋 시트가 출시되면서 대중화되었고, 최근에는 로렘 입숨 버전을 포함한 알더스 페이지메이커와 같은 탁상 출판 소프트웨어를 통해 널리 알려졌습니다.
''';

  @override
  void run() {
    // Use longer text for more accurate measurement
    TextRomanizer.romanize(koreanTextLong);
  }
}

/// Benchmark for Japanese romanization
class JapaneseRomanizeBenchmark extends RomanizeBenchmark {
  JapaneseRomanizeBenchmark() : super('JapaneseRomanize');

  static const japaneseText = 'Lorem Ipsumは、印刷および組版業界の標準的なダミーテキストです。';
  static const japaneseTextLong = '''
Lorem Ipsumは、印刷および組版業界の標準的なダミーテキストです。
Lorem Ipsumは1500年代から業界の標準的なダミーテキストであり続けてきました。
当時、無名の印刷業者が活字のゲラを取り、活字見本帳を作るためにそれを並べ替えました。
それは5世紀を生き延びただけでなく、電子組版への飛躍も経て、本質的に変わらず残っています。
1960年代にLorem Ipsumの一節を含むレトラセットのシートが発売されたことで広く知られるようになり、さらに最近ではLorem Ipsumのバージョンを含むAldus PageMakerのようなデスクトップパブリッシングソフトウェアによって普及しました。
''';

  @override
  void run() {
    TextRomanizer.romanize(japaneseTextLong);
  }
}

/// Benchmark for Chinese romanization
class ChineseRomanizeBenchmark extends RomanizeBenchmark {
  ChineseRomanizeBenchmark() : super('ChineseRomanize');

  static const chineseText = 'Lorem Ipsum 是印刷和排版行业的虚拟文本。';
  static const chineseTextLong = '''
Lorem Ipsum 是印刷和排版行业的虚拟文本。
自 1500 年代以来，Lorem Ipsum 一直是行业的标准虚拟文本，当时一位不知名的印刷工取来一排活字并将其打乱以制作字体样本书。
它不仅经历了五个世纪，还跨入了电子排版时代，本质上保持不变。
它在 20 世纪 60 年代随着包含 Lorem Ipsum 段落的 Letraset 纸张的发布而普及，最近又通过 Aldus PageMaker 等包含 Lorem Ipsum 版本的桌面出版软件而普及。
''';

  @override
  void run() {
    TextRomanizer.romanize(chineseTextLong);
  }
}

/// Benchmark for Cyrillic romanization
class CyrillicRomanizeBenchmark extends RomanizeBenchmark {
  CyrillicRomanizeBenchmark() : super('CyrillicRomanize');

  static const cyrillicText =
      'Lorem Ipsum - это текст-"рыба", часто используемый в печати и вэб-дизайне.';
  static const cyrillicTextLong = '''
Lorem Ipsum - это текст-"рыба", часто используемый в печати и вэб-дизайне.
Lorem Ipsum является стандартной "рыбой" для текстов на латинице с начала XVI века.
В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов.
Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн.
Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum.
''';

  @override
  void run() {
    TextRomanizer.romanize(cyrillicTextLong);
  }
}

/// Benchmark for Arabic romanization
class ArabicRomanizeBenchmark extends RomanizeBenchmark {
  ArabicRomanizeBenchmark() : super('ArabicRomanize');

  static const arabicText =
      'لوريم إيبسوم هو ببساطة نص شكلي يُستخدم في صناعة الطباعة والتنضيد.';
  static const arabicTextLong = '''
لوريم إيبسوم هو ببساطة نص شكلي يُستخدم في صناعة الطباعة والتنضيد.
لقد كان لوريم إيبسوم هو النص الشكلي القياسي في هذه الصناعة منذ القرن السادس عشر، عندما أخذ أحد الطابعين المجهولين رصاصة من الحروف وقام بخلطها لصنع كتاب عينة للخطوط.
لقد نجا ليس فقط لخمسة قرون، بل وقفز أيضًا إلى التنضيد الإلكتروني، وظل دون تغيير جوهري.
وقد ذاع صيته في ستينيات القرن العشرين مع إصدار أوراق ليتراسيت التي تحتوي على مقاطع من لوريم إيبسوم، ومؤخرًا مع برامج النشر المكتبي مثل ألدوس بيج ميكر التي تضم نسخًا من لوريم إيبسوم.
''';

  @override
  void run() {
    TextRomanizer.romanize(arabicTextLong);
  }
}

/// Benchmark for Hebrew romanization
class HebrewRomanizeBenchmark extends RomanizeBenchmark {
  HebrewRomanizeBenchmark() : super('HebrewRomanize');

  static const hebrewText =
      'לורם איפסום הוא פשוט טקסט דמה של תעשיית הדפוס והסידור.';
  static const hebrewTextLong = '''
לורם איפסום הוא פשוט טקסט דמה של תעשיית הדפוס והסידור.
לורם איפסום היה טקסט הדמה הסטנדרטי של התעשייה מאז שנות ה-1500, כאשר מדפיס אלמוני לקח מגש של אותיות וערבב אותו כדי ליצור ספר דוגמה של גופנים.
הוא שרד לא רק חמש מאות שנים, אלא גם את הקפיצה לסידור אלקטרוני, כשהוא נותר ללא שינוי מהותי.
הוא הפך לפופולרי בשנות ה-60 עם הוצאת גיליונות Letraset שהכילו קטעי לורם איפסום, ולאחרונה עם תוכנות הוצאה לאור שולחנית כמו Aldus PageMaker הכוללות גרסאות של לורם איפסום.
''';

  @override
  void run() {
    TextRomanizer.romanize(hebrewTextLong);
  }
}

/// Benchmark for Greek romanization
class GreekRomanizeBenchmark extends RomanizeBenchmark {
  GreekRomanizeBenchmark() : super('GreekRomanize');

  static const greekText =
      'Το Lorem Ipsum είναι απλά ένα κείμενο χωρίς νόημα για τους επαγγελματίες της τυπογραφίας και στοιχειοθεσίας.';
  static const greekTextLong = '''
Το Lorem Ipsum είναι απλά ένα κείμενο χωρίς νόημα για τους επαγγελματίες της τυπογραφίας και στοιχειοθεσίας.
Το Lorem Ipsum είναι το επαγγελματικό πρότυπο όσον αφορά το κείμενο χωρίς νόημα, από τον 15ο αιώνα, όταν ένας ανώνυμος τυπογράφος πήρε ένα δοκίμιο και ανακάτεψε τις λέξεις για να δημιουργήσει ένα δείγμα βιβλίου.
Όχι μόνο επιβίωσε πέντε αιώνες, αλλά κυριάρχησε στην ηλεκτρονική στοιχειοθεσία, παραμένοντας με κάθε τρόπο αναλλοίωτο.
Έγινε δημοφιλές τη δεκαετία του '60 με την έκδοση των δειγμάτων της Letraset όπου περιελάμβαναν αποσπάσματα του Lorem Ipsum, και πιο πρόσφατα με το λογισμικό ηλεκτρονικής σελιδοποίησης όπως το Aldus PageMaker που περιείχαν εκδοχές του Lorem Ipsum.
''';

  @override
  void run() {
    TextRomanizer.romanize(greekTextLong);
  }
}

/// Benchmark for multi-language text romanization
class MultiLanguageRomanizeBenchmark extends RomanizeBenchmark {
  MultiLanguageRomanizeBenchmark() : super('MultiLanguageRomanize');

  static const multiLanguageText = '안녕 Hello こんにちは 你好 Привет مرحبا שָׁלוֹם';
  static const multiLanguageTextLong = '''
안녕하세요 Hello こんにちは 你好世界 Привет мир مرحبا بكم שָׁלוֹם עוֹלָם
Korean English Japanese Chinese Cyrillic Arabic Hebrew
한국어 영어 日本語 中文 Кириллица العربية עִבְרִית
''';

  @override
  void run() {
    TextRomanizer.romanize(multiLanguageTextLong);
  }
}

/// Benchmark for language detection
class LanguageDetectionBenchmark extends RomanizeBenchmark {
  LanguageDetectionBenchmark() : super('LanguageDetection');

  static const testTexts = [
    '안녕하세요',
    'こんにちは',
    '你好',
    'Привет',
    'مرحبا',
    'שָׁלוֹם',
  ];

  @override
  void run() {
    for (final text in testTexts) {
      TextRomanizer.detectLanguage(text);
    }
  }
}

/// Benchmark for direct romanizer usage (no detection overhead)
class DirectRomanizerBenchmark extends RomanizeBenchmark {
  DirectRomanizerBenchmark() : super('DirectRomanizer');

  late final HangulRomanizer hangulRomanizer;
  late final JapaneseRomanizer japaneseRomanizer;
  late final ChineseRomanizer chineseRomanizer;
  late final CyrillicRomanizer cyrillicRomanizer;
  late final ArabicRomanizer arabicRomanizer;
  late final HebrewRomanizer hebrewRomanizer;

  @override
  void setup() {
    hangulRomanizer = HangulRomanizer();
    japaneseRomanizer = JapaneseRomanizer();
    chineseRomanizer = ChineseRomanizer();
    cyrillicRomanizer = CyrillicRomanizer();
    arabicRomanizer = ArabicRomanizer();
    hebrewRomanizer = HebrewRomanizer();
  }

  @override
  void run() {
    hangulRomanizer.romanize(KoreanRomanizeBenchmark.koreanTextLong);
    japaneseRomanizer.romanize(JapaneseRomanizeBenchmark.japaneseTextLong);
    chineseRomanizer.romanize(ChineseRomanizeBenchmark.chineseTextLong);
    cyrillicRomanizer.romanize(CyrillicRomanizeBenchmark.cyrillicTextLong);
    arabicRomanizer.romanize(ArabicRomanizeBenchmark.arabicTextLong);
    hebrewRomanizer.romanize(HebrewRomanizeBenchmark.hebrewTextLong);
  }
}

/// Benchmark for long text romanization
class LongTextRomanizeBenchmark extends RomanizeBenchmark {
  LongTextRomanizeBenchmark() : super('LongTextRomanize');

  static const longText =
      '''
${KoreanRomanizeBenchmark.koreanTextLong}
${JapaneseRomanizeBenchmark.japaneseTextLong}
${ChineseRomanizeBenchmark.chineseTextLong}
${CyrillicRomanizeBenchmark.cyrillicTextLong}
${ArabicRomanizeBenchmark.arabicTextLong}
${HebrewRomanizeBenchmark.hebrewTextLong}
${GreekRomanizeBenchmark.greekTextLong}
''';

  @override
  void run() {
    TextRomanizer.romanize(longText);
  }
}

class StressTestRomanizeBenchmark extends RomanizeBenchmark {
  StressTestRomanizeBenchmark() : super('StressTestRomanize');

  static const stressTestText = '''
Mixed Script Stress Test:
-------------------------
1. CJK Ambiguity (Should detect Chinese vs Japanese context):
   中文 (Chinese) vs 日本語 (Japanese)
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

   End of Stress Test.
''';

  @override
  void run() {
    TextRomanizer.romanize(stressTestText);
  }
}

void main() async {
  await TextRomanizer.ensureInitialized();

  // Individual language benchmarks
  KoreanRomanizeBenchmark().report();
  JapaneseRomanizeBenchmark().report();
  ChineseRomanizeBenchmark().report();
  CyrillicRomanizeBenchmark().report();
  ArabicRomanizeBenchmark().report();
  HebrewRomanizeBenchmark().report();
  GreekRomanizeBenchmark().report();

  // Multi-language benchmark
  MultiLanguageRomanizeBenchmark().report();

  // Language detection benchmark
  LanguageDetectionBenchmark().report();

  // Direct romanizer usage (no detection overhead)
  DirectRomanizerBenchmark().report();

  // Long text benchmark
  LongTextRomanizeBenchmark().report();

  // Stress test benchmark
  StressTestRomanizeBenchmark().report();
}
