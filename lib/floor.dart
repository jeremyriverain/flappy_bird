import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/flappy_game.dart';
import 'constants.dart' as constants;

class Floor extends SpriteComponent with HasGameRef<FlappyGame> {
  final double initialLeftPosition;
  bool hasDisappeared = false;

  Floor({required this.initialLeftPosition});

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('floor.png');
    x = initialLeftPosition;
    y = gameRef.size[1] * 7 / 8;
    size = Vector2(gameRef.size[0], gameRef.size[1] / 8);
    priority = 1;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position =
        Vector2(position.x - constants.speed * dt, gameRef.size[1] * 7 / 8);
    if (position.x <= -gameRef.size[0]) {
      hasDisappeared = true;
    }
    super.update(dt);
  }
}
