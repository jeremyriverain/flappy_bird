import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/constants.dart';
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
    size = Vector2(widthBird, 35);

    x = distanceFromLeftBird;
    y = gameRef.size[1] / 2;

    priority = 1;

    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isJumping == true) {
      FlameAudio.play('wing.wav');
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
  void onCollision(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    await gameRef.onGameOver();
    super.onCollision(intersectionPoints, other);
  }
}
