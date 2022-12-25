import 'package:flame/components.dart';
import 'package:flappy_bird/flappy_game.dart';

const double widthGameOverScreen = 276;

const double heightGameOverScreen = 400;

class InitScreen extends SpriteComponent with HasGameRef<FlappyGame> {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('message.png');
    position = Vector2(
      gameRef.size[0] / 2 - widthGameOverScreen / 2,
      gameRef.size[1] / 2 - heightGameOverScreen / 2,
    );
    size = Vector2(widthGameOverScreen, heightGameOverScreen);
    priority = 2;
  }
}
