## [next]

- `TextRomanizer.analyze`, which analyzes the input text and provides detailed information about detected languages and romanization results for each segment.

## 0.0.2

- Japanese Kanji support added using [`kuromoji`](https://pub.dev/packages/kuromoji).
- Hebrew romanization support added based on ISO 259 / DIN 31636.
- Added support for multiple Arabic romanization systems (ALA-LC, DIN 31635, Buckwalter).
- Improved language detection for mixed CJK (Chinese/Japanese) text by preventing `ChineseRomanizer` from claiming text containing Japanese Kana.

## 0.0.1

- Initial version.
