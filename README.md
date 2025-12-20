A powerful Dart package for seamlessly converting multilingual text into its Romanized form.

## Features

- 🌏 **Multi-language support**: Korean, Japanese, Chinese, Cyrillic, and Arabic
- 🔍 **Auto-detection**: Automatically detects the languages present in the input text
- 🛠️ **Flexible & extensible**: Easily create your own custom romanizer for any language or writing system
- 📦 **Lightweight**: Minimal dependencies, fast performance

## Installation

Add `romanize` to your `pubspec.yaml`:

```yaml
dependencies:
  romanize: ^0.0.1
```

Then run:

```bash
dart pub get
```

## Usage

Import the package:

```dart
import 'package:romanize/romanize.dart';
```

### Romanize Text

The `romanize` method automatically detects and romanizes each word separately, making it perfect for multi-language text:

```dart
// Multi-language text - each word is detected and romanized independently
final text = '你好 Hello 안녕';
final romanized = TextRomanizer.romanize(text);
print(romanized); // ni hao Hello annyeong

// Single language text also works
final koreanText = '안녕하세요';
final koreanRomanized = TextRomanizer.romanize(koreanText);
print(koreanRomanized); // annyeonghaseyo
```

It will fail to detect multiple languagues if they are not separated by spaces.

### Detect Language

Detect the first language present in the text:

```dart
final romanizer = TextRomanizer.detectLanguage('안녕하세요');
print(romanizer.language); // korean
```

Or detect all languages present in the text:

```dart
final romanizers = TextRomanizer.detectLanguages('안녕 Hello 你好 Привет мир');
print(romanizers.map((r) => r.language)); // {korean, chinese, cyrillic}
```

### Specify Language

You can also specify the language explicitly using the `forLanguage` method:

```dart
final japaneseText = 'こんにちは';
final japaneseRomanizer = TextRomanizer.forLanguage('japanese');
print(japaneseRomanizer.romanize(japaneseText)); // konnichiwa
```

Or you can instantiate the romanizer directly:

```dart
final chineseText = '你好';
final chineseRomanizer = ChineseRomanizer(toneAnnotation: ToneAnnotation.mark);
print(chineseRomanizer.romanize(chineseText)); // nǐ hǎo
```

Some romanizers have additional options. For example, the `ChineseRomanizer` has the `toneAnnotation` option to specify the tone annotation to use.

### Load resources

Pre initialize the resources:

```dart
await TextRomanizer.ensureInitialized();
```

This initializes all the necessary resources, such as the Japanese and Chinese dictionaries. This operation is expensive and should be done, preferably, on another isolate. On the web platform, prefer server side initialization. 

## Supported Languages

- **Korean** (한국어)
- **Japanese** (日本語) - Using [`kuromoji`](https://pub.dev/packages/kuromoji) for Kanji conversion and [`kana_kit`](https://pub.dev/packages/kana_kit) for Kana and Katakana conversion
- **Chinese** (中文) - Using [`pinyin`](https://pub.dev/packages/pinyin) for Pinyin conversion (Simplified and Traditional)
- **Cyrillic** (Кириллица) - Custom transliteration for Russian, Ukrainian, Serbian, and more
- **Arabic** (العربية) - Custom transliteration based on ISO 233 and DIN 31635
- **Hebrew** (עברית) - Custom transliteration based on ISO 259-2

## API Reference

### `TextRomanizer`

Main class for romanizing text.

#### Static Methods

- `ensureInitialized()` - Ensures that all resources are loaded and initialized.
- `romanize(String input)` - Processes each word separately, auto-detecting and romanizing each word. Perfect for multi-language text.
- `detectLanguage(String input)` - Detects the first matching language and returns the corresponding `Romanizer`. Returns `EmptyRomanizer` if no match is found.
- `detectLanguages(String input)` - Detects all matching languages and returns a `Set<Romanizer>`. Returns empty set if no matches are found.
- `forLanguage(String language)` - Returns a `Romanizer` for the specified language. Throws `UnimplementedError` if not found.
- `forLanguageOrNull(String? language)` - Returns a `Romanizer?` for the specified language, or `null` if not found.
- `supportedLanguages` - Returns a list of all supported language names.

### `Romanizer`

Interface for language-specific romanizers.

- `language` - The language name (e.g., 'korean', 'japanese', 'arabic')
- `isValid(String input)` - Checks if the input is valid for this romanizer
- `romanize(String input)` - Converts the input to Romanized form

## Example

See the [example](example/romanize_example.dart) directory for a complete example.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Creating a Custom Romanizer

To create a custom romanizer for a new language or writing system, you can extend the `Romanizer` class and implement the `romanize` and `isValid` methods.

```dart
class EmojiRomanizer extends Romanizer {
  const EmojiRomanizer() : super(language: 'emoji');

  static const Map<String, String> _transliterationMap = {
    '👋': 'wave',
    '🌍': 'earth',
    '🚀': 'rocket',
    '🎉': 'party',
  };

  @override
  bool isValid(String input) {
    return RegExp(r'[\uD800-\uDBFF][\uDC00-\uDFFF]').hasMatch(input);
  }

  @override
  String romanize(String input) {
    final buffer = StringBuffer();
    for (final char in input.runes) {
      final charString = String.fromCharCode(char);
      if (isValid(charString)) {
        if (_transliterationMap.containsKey(charString)) {
          buffer.write(':${_transliterationMap[charString]}:');
        } else {
          buffer.write(':$charString:');
        }
      } else {
        buffer.write(charString);
      }
    }
    return buffer.toString();
  }
}
```

Then you can use your custom romanizer like this:

```dart
final emojiText = '👋 🌍 🚀 🎉 💜';
final emojiOutput = EmojiRomanizer().romanize(emojiText);
print('Emoji Romanization: \n$emojiOutput'); // :wave: :earth: :rocket: :party: :💜:
```

### Benchmarking

Add your custom romanizer to the benchmark suite in `benchmark/romanize_benchmark.dart` and run the benchmarks. To run benchmarks, use the following command:

```bash
dart run benchmark_harness:bench --flavor aot --target=benchmark/romanize_benchmark.dart
```

The results will be logged to the console.

```
KoreanRomanize(RunTime): 35.53725970192239 us.
JapaneseRomanize(RunTime): 281.2901698691172 us.
ChineseRomanize(RunTime): 1736.711451758341 us.
CyrillicRomanize(RunTime): 59.59739989290177 us.
ArabicRomanize(RunTime): 52.565961208465495 us.
MultiLanguageRomanize(RunTime): 184.99707850343984 us.
LanguageDetection(RunTime): 28.325652046087722 us.
DirectRomanizer(RunTime): 10321.13 us.
LongTextRomanize(RunTime): 16493.885245901638 us.
```
