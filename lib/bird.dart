import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/constants.dart';
import 'package:flappy_bird/flappy_game.dart';
import 'package:flappy_bird/utils.dart';

const double gravityBird = 0.25;

class Bird extends SpriteAnimationComponent
    with HasGameRef<FlappyGame>, CollisionCallbacks {
  double _fallingMovement = 0;
  bool _isJumping = false;

  @override
  Future<void>? onLoad() async {
    final sprites =
        ['midflap', 'upflap', 'downflap'].map((i) => Sprite.load('$i.png'));

    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.08,
    );
    size = Vector2(widthBird, 35);

    x = distanceFromLeftBird;
    y = gameRef.size[1] / 2;

    priority = 1;

    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (_isJumping == true) {
      playSound('wing.wav');

      _fallingMovement = -6;
      _isJumping = false;
    } else {
      _fallingMovement += gravityBird;
    }
    y += _fallingMovement;
    angle = _fallingMovement * 0.06;

    super.update(dt);
  }

  void onTap() {
    _isJumping = true;
  }

  @override
  void onCollision(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    await gameRef.onGameOver();
    super.onCollision(intersectionPoints, other);
  }
}
