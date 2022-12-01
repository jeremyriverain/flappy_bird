import 'package:flame/game.dart';
import 'package:flappy_bird/background.dart';

class FlappyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    add(Background());
  }
}
