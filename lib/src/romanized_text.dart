/// A class representing the romanized text along with its original form and the
/// language used for romanization.
///
/// See also:
///
///  * [TextRomanizer.analyze], which returns a list of [RomanizedText] parts.
class RomanizedText {
  /// The original raw text.
  final String rawText;

  /// The romanizer used to convert the text.
  final String language;

  /// The romanized text.
  final String romanizedText;

  const RomanizedText({
    required this.rawText,
    required this.language,
    required this.romanizedText,
  });
}
