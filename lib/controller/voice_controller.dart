import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'chat_controller.dart';

class VoiceController {
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static bool isListening = false;
  static bool _isInitialized = false;

  ////////////////////////////////////////////////////////////
  /// INITIALIZE SPEECH ENGINE
  ////////////////////////////////////////////////////////////

  static Future<bool> init() async {
    if (_isInitialized) return true;

    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        if (status == "done" || status == "notListening") {
          isListening = false;
        }
      },
      onError: (error) {
        isListening = false;
      },
    );

    return _isInitialized;
  }

  ////////////////////////////////////////////////////////////
  /// START LISTENING
  ////////////////////////////////////////////////////////////

  static Future<void> startListening({
    required Function(String text) onListening,
    required Function(String userText, String aiReply) onComplete,
  }) async {
    if (!_isInitialized) {
      bool ok = await init();
      if (!ok) return;
    }

    if (isListening) return;

    await _speech.listen(
      listenMode: stt.ListenMode.confirmation,
      partialResults: true,
      onResult: (result) async {
        final text = result.recognizedWords;
        onListening(text);

        if (result.finalResult) {
          stopListening();

          final aiReply = await ChatController.sendMessage(text);

          onComplete(text, aiReply);
        }
      },
    );

    isListening = true;
  }

  ////////////////////////////////////////////////////////////
  /// STOP LISTENING
  ////////////////////////////////////////////////////////////

  static Future<void> stopListening() async {
    if (!isListening) return;

    await _speech.stop();
    isListening = false;
  }
}
