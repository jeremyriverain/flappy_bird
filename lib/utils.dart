import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

void playSound(String sound) {
  try {
    FlameAudio.play(sound);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
