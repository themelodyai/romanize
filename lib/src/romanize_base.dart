abstract class Romanizer {
  const Romanizer({required this.language});

  final String language;

  /// Converts a given string to its Romanized form.
  ///
  /// This method takes a string input and returns its Romanized equivalent.
  /// The Romanization process may involve transliteration of characters
  /// from one script to another, depending on the specific rules defined
  /// in the implementation.
  ///
  /// Example:
  /// ```dart
  /// String romanized = Romanizer.romanize("こんにちは");
  /// print(romanized); // Outputs: konnichiwa
  /// ```
  String romanize(String input);

  /// Validates if the input string can be Romanized.
  bool isValid(String input);
}
