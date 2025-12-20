library;

import 'dart:async';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:jaspr/client.dart';
import 'package:romanize/romanize.dart';

import 'app.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
Future<String> romanize(String text) async {
  await TextRomanizer.ensureInitialized();
  return TextRomanizer.romanize(text);
}

final service = RomanizationService();
void main() async {
  await service.init();

  runApp(App());
}

class RomanizationService {
  late final IsolateManager<String, String> _manager;

  Future<void> init() async {
    _manager = IsolateManager.create(
      romanize,
      workerName: 'romanize',
      concurrent: 1,
    );

    await _manager.start();
  }

  Future<String> convert(String text) async {
    return await _manager.compute(text);
  }
}
