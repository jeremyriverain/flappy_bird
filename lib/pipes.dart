import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/flappy_game.dart';
import 'constants.dart' as constants;

class Pipes extends Component with HasGameRef<FlappyGame> {
  bool hasDisappeared = false;
  late final double _topPipeHeight;
  late final List<double> _topPipeHeights;
  final double _pipeWidth = 70;
  late final double _initialPipeX;

  final double _pipeHeadHeight = 24;
  final _spaceBetweenPipes = 180;

  late final SpriteComponent topPipeBody;
  late final SpriteComponent _topPipeHead;
  late final SpriteComponent _bottomPipeBody;
  late final SpriteComponent _bottomPipeHead;
  bool canUpdateScore = true;
  bool fullyInitialized = false;

  @override
  Future<void>? onLoad() async {
    _topPipeHeights = [
      gameRef.size[1] / 6,
      gameRef.size[1] / 4,
      gameRef.size[1] / 3,
      gameRef.size[1] / 2,
    ];
    _topPipeHeight = _topPipeHeights[Random().nextInt(4)];
    _initialPipeX = gameRef.size[0] + 50;
    topPipeBody = await _getPipeBody()
      ..position = Vector2(_initialPipeX, 0);
    _topPipeHead = await _getPipeHead()
      ..position = Vector2(_initialPipeX - 3, _topPipeHeight);

    final double bottomPipeHeadY =
        _pipeHeadHeight + _topPipeHeight + _spaceBetweenPipes;
    _bottomPipeHead = await _getPipeHead()
      ..position = Vector2(_initialPipeX - 3, bottomPipeHeadY);
    _bottomPipeBody = await _getPipeBody()
      ..position = Vector2(_initialPipeX, bottomPipeHeadY + _pipeHeadHeight)
      ..height = gameRef.size[1] / 2;

    add(topPipeBody);
    add(_topPipeHead);
    add(_bottomPipeHead);
    add(_bottomPipeBody);

    super.onLoad();
    fullyInitialized = true;
  }

  Future<SpriteComponent> _getPipeBody() async {
    return SpriteComponent(sprite: await Sprite.load('pipe_body.png'))
      ..size = Vector2(_pipeWidth, _topPipeHeight)
      ..add(
        RectangleHitbox()..collisionType = CollisionType.passive,
      );
  }

  Future<SpriteComponent> _getPipeHead() async {
    return SpriteComponent(sprite: await Sprite.load('pipe_head.png'))
      ..size = Vector2(_pipeWidth + 6, _pipeHeadHeight)
      ..add(
        RectangleHitbox()..collisionType = CollisionType.passive,
      );
  }

  @override
  void update(double dt) {
    final double delta = constants.speed * dt;
    topPipeBody.x -= delta;
    _topPipeHead.x -= delta;
    _bottomPipeBody.x -= delta;
    _bottomPipeHead.x -= delta;

    if (topPipeBody.x <= -100) {
      hasDisappeared = true;
    }
    super.update(dt);
  }
}
