library;

import 'package:jaspr/client.dart';
import 'package:romanize/romanize.dart';

import 'app.dart';

void main() {
  TextRomanizer.ensureInitialized();

  runApp(App());
}
