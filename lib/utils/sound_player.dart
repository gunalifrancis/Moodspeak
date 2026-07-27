import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  static final AudioPlayer _player = AudioPlayer();

  static Future play(String file) async {
    try {
      await _player.stop(); // prevent overlap
      await _player.play(AssetSource("sounds/$file"));
    } catch (e) {
      print("Sound error: $e");
    }
  }
}
