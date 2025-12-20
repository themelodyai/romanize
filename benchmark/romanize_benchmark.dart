// Run the benchmark
// dart run benchmark_harness:bench --flavor aot --target=benchmark/romanize_benchmark.dart

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:romanize/romanize.dart';

/// Benchmark for Korean romanization
class KoreanRomanizeBenchmark extends BenchmarkBase {
  KoreanRomanizeBenchmark() : super('KoreanRomanize');

  static const koreanText = '안녕하세요 세계 여러분 반갑습니다';
  static const koreanTextLong = '''
안녕하세요 세계 여러분 반갑습니다
오늘은 좋은 날씨입니다
한국어 텍스트를 로마자로 변환하는 성능을 측정합니다
이것은 더 긴 텍스트로 벤치마크를 수행합니다
''';

  @override
  void run() {
    // Use longer text for more accurate measurement
    TextRomanizer.romanize(koreanTextLong);
  }
}

/// Benchmark for Japanese romanization
class JapaneseRomanizeBenchmark extends BenchmarkBase {
  JapaneseRomanizeBenchmark() : super('JapaneseRomanize');

  static const japaneseText = 'こんにちは世界の皆さん初めまして';
  static const japaneseTextLong = '''
こんにちは世界の皆さん初めまして
今日は良い天気です
日本語のテキストをローマ字に変換するパフォーマンスを測定します
これはより長いテキストでベンチマークを実行します
''';

  @override
  void run() {
    TextRomanizer.romanize(japaneseTextLong);
  }
}

/// Benchmark for Chinese romanization
class ChineseRomanizeBenchmark extends BenchmarkBase {
  ChineseRomanizeBenchmark() : super('ChineseRomanize');

  static const chineseText = '你好世界大家好很高兴见到你们';
  static const chineseTextLong = '''
你好世界大家好很高兴见到你们
今天是好天气
测量将中文文本转换为拼音的性能
这是使用更长文本进行基准测试
''';

  @override
  void run() {
    TextRomanizer.romanize(chineseTextLong);
  }
}

/// Benchmark for Cyrillic romanization
class CyrillicRomanizeBenchmark extends BenchmarkBase {
  CyrillicRomanizeBenchmark() : super('CyrillicRomanize');

  static const cyrillicText = 'Привет мир всем рад вас видеть';
  static const cyrillicTextLong = '''
Привет мир всем рад вас видеть
Сегодня хорошая погода
Измерение производительности преобразования кириллического текста в латиницу
Это выполнение бенчмарка с более длинным текстом
''';

  @override
  void run() {
    TextRomanizer.romanize(cyrillicTextLong);
  }
}

/// Benchmark for Arabic romanization
class ArabicRomanizeBenchmark extends BenchmarkBase {
  ArabicRomanizeBenchmark() : super('ArabicRomanize');

  static const arabicText = 'أنا العربي مرحبا بكم جميعا';
  static const arabicTextLong = '''
أنا العربي مرحبا بكم جميعا
اليوم الطقس جميل
قياس أداء تحويل النص العربي إلى الحروف اللاتينية
هذا تنفيذ معيار مع نص أطول
''';

  @override
  void run() {
    TextRomanizer.romanize(arabicTextLong);
  }
}

/// Benchmark for Hebrew romanization
class HebrewRomanizeBenchmark extends BenchmarkBase {
  HebrewRomanizeBenchmark() : super('HebrewRomanize');

  static const hebrewText = 'שָׁלוֹם עוֹלָם מַה שְּׁלוֹמְכֶם';
  static const hebrewTextLong = '''
שָׁלוֹם עוֹלָם מַה שְּׁלוֹמְכֶם
הַיּוֹם יוֹם יָפֶה
בְּדִיקַת בִּיצוּעִים שֶׁל הֲמָרַת טֶקְסְט עִבְרִי לְאוֹתִיּוֹת לָטִינִיּוֹת
זֶהוּ בִּיצוּעַ בְּדִיקָה עִם טֶקְסְט אָרוֹךְ יוֹתֵר
''';

  @override
  void run() {
    TextRomanizer.romanize(hebrewTextLong);
  }
}

/// Benchmark for multi-language text romanization
class MultiLanguageRomanizeBenchmark extends BenchmarkBase {
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
class LanguageDetectionBenchmark extends BenchmarkBase {
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
class DirectRomanizerBenchmark extends BenchmarkBase {
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
class LongTextRomanizeBenchmark extends BenchmarkBase {
  LongTextRomanizeBenchmark() : super('LongTextRomanize');

  static const longText = '''
안녕하세요 세계 여러분 반갑습니다 오늘은 좋은 날씨입니다
한국어 텍스트를 로마자로 변환하는 성능을 측정합니다
こんにちは世界の皆さん初めまして今日は良い天気です
日本語のテキストをローマ字に変換するパフォーマンスを測定します
你好世界大家好很高兴见到你们今天是好天气
测量将中文文本转换为拼音的性能这是使用更长文本进行基准测试
Привет мир всем рад вас видеть Сегодня хорошая погода
Измерение производительности преобразования кириллического текста в латиницу
أنا العربي مرحبا بكم جميعا اليوم الطقس جميل
قياس أداء تحويل النص العربي إلى الحروف اللاتينية
שָׁלוֹם עוֹלָם מַה שְּׁלוֹמְכֶם הַיּוֹם יוֹם יָפֶה
בְּדִיקַת בִּיצוּעִים שֶׁל הֲמָרַת טֶקְסְט עִבְרִי לְאוֹתִיּוֹת לָטִינִיּוֹת
''';

  @override
  void run() {
    TextRomanizer.romanize(longText);
  }
}

class StressTestRomanizeBenchmark extends BenchmarkBase {
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
