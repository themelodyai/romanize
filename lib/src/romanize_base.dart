/// Abstract base class for language-specific text romanization.
///
/// A [Romanizer] converts text from a specific writing system (such as
/// Japanese, Korean, or Arabic) into its Romanized (Latin script) equivalent.
/// Each implementation handles the specific rules and conventions for
/// transliterating characters from that language.
abstract class Romanizer {
  /// Creates a new [Romanizer] instance.
  const Romanizer({required this.language});

  /// The language name this romanizer supports.
  ///
  /// This should be a lowercase string (e.g., 'japanese', 'korean').
  /// It is used by [TextRomanizer] to identify and select the appropriate
  /// romanizer for a given language.
  final String language;

  /// Converts a given string to its Romanized form.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = JapaneseRomanizer();
  /// final romanized = romanizer.romanize("こんにちは");
  /// print(romanized); // konnichiwa
  /// ```
  String romanize(String input);

  /// Validates if the input string can be processed by this romanizer.
  bool isValid(String input);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Romanizer && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

class EmptyRomanizer extends Romanizer {
  const EmptyRomanizer() : super(language: 'empty');

  @override
  bool isValid(String input) {
    return true;
  }

  @override
  String romanize(String input) {
    return input;
  }
}
