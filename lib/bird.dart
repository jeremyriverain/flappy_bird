import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/flappy_game.dart';

const double gravityBird = 0.25;

class Bird extends SpriteAnimationComponent
    with HasGameRef<FlappyGame>, CollisionCallbacks {
  double fallingMovement = 0;
  bool isJumping = false;

  @override
  Future<void>? onLoad() async {
    final sprites =
        ['midflap', 'upflap', 'downflap'].map((i) => Sprite.load('$i.png'));

    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.08,
    );
    size = Vector2(50, 35);

    x = 50;
    y = gameRef.size[1] / 2;

    priority = 1;

    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isJumping == true) {
      fallingMovement = -6;
      isJumping = false;
    } else {
      fallingMovement += gravityBird;
    }
    y += fallingMovement;
    angle = fallingMovement * 0.06;

    super.update(dt);
  }

  void onTap() {
    isJumping = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print(other);
  }
}
