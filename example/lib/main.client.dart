library;

import 'dart:async';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:jaspr/client.dart';
import 'package:romanize/romanize.dart';

import 'app.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
Future<List<Object?>> romanize(String text) async {
  await TextRomanizer.ensureInitialized();
  if (text.isEmpty) {
    return <Map<String, String>>[];
  }
  return TextRomanizer.analyze(text).map<Map<String, String>>((text) {
    return {
      'rawText': text.rawText,
      'language': text.language,
      'romanizedText': text.romanizedText,
    };
  }).toList();
}

final service = RomanizationService();
void main() async {
  await service.init();
  // Warm up the isolate.
  service.convert('');

  runApp(App());
}

class RomanizationService {
  late final IsolateManager<List<Object?>, String> _manager;

  Future<void> init() async {
    _manager = IsolateManager.create(
      romanize,
      workerName: 'romanize',
      concurrent: 1,
    );

    await _manager.start();
  }

  Future<List<RomanizedText>> convert(String text) async {
    return (await _manager.compute(text) as List).cast<Map<Object?, Object?>>().map((e) {
      return RomanizedText(
        rawText: e['rawText'] as String,
        language: e['language'] as String,
        romanizedText: e['romanizedText'] as String,
      );
    }).toList();
  }
}
