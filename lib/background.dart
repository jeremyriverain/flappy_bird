import 'package:flame/components.dart';
import 'package:flappy_bird/flappy_game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyGame> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('background.png');
    position = Vector2(0, 0);
    size = Vector2(gameRef.size[0], gameRef.size[1]);
  }
}
