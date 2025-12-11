# romanize

A Dart package for converting text to Romanized form.

## Features

- 🌏 **Multi-language support**: Korean, Japanese, and Arabic
- 🔍 **Auto-detection**: Automatically detects the language of input text
- 🎯 **Language-specific**: Use specific romanizers for each language
- 📦 **Lightweight**: Minimal dependencies, fast performance
- 🎤 **Karaoke-ready**: Perfect for karaoke applications and lyric display

## Installation

Add `romanize` to your `pubspec.yaml`:

```yaml
dependencies:
  romanize: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Auto-detect Language

The simplest way to use `romanize` is to let it automatically detect the language:

```dart
import 'package:romanize/romanize.dart';

void main() {
  final text = '안녕하세요';
  final romanized = TextRomanizer.romanize(text);
  print(romanized); // annyeonghaseyo
}
```

### Specify Language

You can also specify the language explicitly:

```dart
import 'package:romanize/romanize.dart';

void main() {
  // Korean
  final koreanText = '천사 같은 "Hi" 끝엔 악마 같은 "Bye"';
  final koreanRomanizer = TextRomanizer.forLanguage('korean');
  print(koreanRomanizer.romanize(koreanText));

  // Japanese
  final japaneseText = '苦しい どっちが you smart';
  final japaneseRomanizer = TextRomanizer.forLanguage('japanese');
  print(japaneseRomanizer.romanize(japaneseText));

  // Arabic
  final arabicText = 'أنا العربي ولد الغابة';
  final arabicRomanizer = TextRomanizer.forLanguage('arabic');
  print(arabicRomanizer.romanize(arabicText));
}
```

### Safe Language Detection

Use `forLanguageOrNull` to safely get a romanizer without throwing an error:

```dart
final romanizer = TextRomanizer.forLanguageOrNull('korean');
if (romanizer != null) {
  print(romanizer.romanize(text));
}
```

## Supported Languages

- **Korean** (한국어) - Using `korean_romanization_converter`
- **Japanese** (日本語) - Using `kana_kit` for Kana conversion
- **Arabic** (العربية) - Using `arabic_roman_conv`

## API Reference

### `TextRomanizer`

Main class for romanizing text.

#### Static Methods

- `romanize(String input)` - Automatically detects language and romanizes the input
- `forLanguage(String language)` - Returns a `Romanizer` for the specified language
- `forLanguageOrNull(String? language)` - Returns a `Romanizer?` for the specified language, or `null` if not found

### `Romanizer`

Interface for language-specific romanizers.

- `language` - The language name (e.g., 'korean', 'japanese', 'arabic')
- `isValid(String input)` - Checks if the input is valid for this romanizer
- `romanize(String input)` - Converts the input to Romanized form

## Example

See the [example](example/romanize_example.dart) directory for a complete example.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
