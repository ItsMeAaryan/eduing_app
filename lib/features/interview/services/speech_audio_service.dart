import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechAudioService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;

  bool get isAvailable => _isAvailable;

  Future<bool> initialize() async {
    try {
      _isAvailable = await _speech.initialize(
        onError: (val) {},
        onStatus: (val) {},
      );
      return _isAvailable;
    } catch (_) {
      _isAvailable = false;
      return false;
    }
  }

  Future<void> startListening({
    required Function(String text) onResult,
  }) async {
    if (!_isAvailable) {
      final initOk = await initialize();
      if (!initOk) throw Exception('Speech recognition unavailable on this device. Use manual text input.');
    }

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }
}
