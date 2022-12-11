import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_bird/flappy_game.dart';
import 'constants.dart' as constants;

class Pipes extends Component with HasGameRef<FlappyGame> {
  bool hasDisappeared = false;
  late final double topPipeHeight;
  late final List<double> topPipeHeights;
  final double pipeWidth = 70;
  late final double initialPipeX;

  final double pipeHeadHeight = 24;
  final spaceBetweenPipes = 180;

  late final SpriteComponent topPipeBody;
  late final SpriteComponent topPipeHead;
  late final SpriteComponent bottomPipeBody;
  late final SpriteComponent bottomPipeHead;

  @override
  Future<void>? onLoad() async {
    topPipeHeights = [
      gameRef.size[1] / 6,
      gameRef.size[1] / 4,
      gameRef.size[1] / 3,
      gameRef.size[1] / 2,
    ];
    topPipeHeight = topPipeHeights[Random().nextInt(4)];
    initialPipeX = gameRef.size[0] + 50;
    topPipeBody = await _getPipeBody()
      ..position = Vector2(initialPipeX, 0);
    topPipeHead = await _getPipeHead()
      ..position = Vector2(initialPipeX - 3, topPipeHeight);

    final double bottomPipeHeadY =
        pipeHeadHeight + topPipeHeight + spaceBetweenPipes;
    bottomPipeHead = await _getPipeHead()
      ..position = Vector2(initialPipeX - 3, bottomPipeHeadY);
    bottomPipeBody = await _getPipeBody()
      ..position = Vector2(initialPipeX, bottomPipeHeadY + pipeHeadHeight)
      ..height = gameRef.size[1] / 2;

    add(topPipeBody);
    add(topPipeHead);
    add(bottomPipeHead);
    add(bottomPipeBody);

    return super.onLoad();
  }

  Future<SpriteComponent> _getPipeBody() async {
    return SpriteComponent(sprite: await Sprite.load('pipe_body.png'))
      ..size = Vector2(pipeWidth, topPipeHeight);
  }

  Future<SpriteComponent> _getPipeHead() async {
    return SpriteComponent(sprite: await Sprite.load('pipe_head.png'))
      ..size = Vector2(pipeWidth + 6, pipeHeadHeight);
  }

  @override
  void update(double dt) {
    final double delta = constants.speed * dt;
    topPipeBody.x -= delta;
    topPipeHead.x -= delta;
    bottomPipeBody.x -= delta;
    bottomPipeHead.x -= delta;

    if (topPipeBody.x <= -100) {
      hasDisappeared = true;
    }
    super.update(dt);
  }
}
