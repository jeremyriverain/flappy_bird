import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/components.dart' show Anchor, ParallaxComponent;

import 'package:flappy_bird/background.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/constants.dart';
import 'package:flappy_bird/init_screen.dart';
import 'package:flappy_bird/pipes.dart';
import 'package:flappy_bird/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  final List<Pipes> _pipes = [];

  Bird _bird = Bird();

  Timer? _timer;

  bool _isPlaying = false;

  int? _score;
  int? _highScore;
  int _delayBeforeRestarting = 0;

  final TextPaint _textPaint = TextPaint(
    style: const TextStyle(fontFamily: 'flappy_bird', fontSize: 45),
  );

  late SharedPreferences _prefs;
  final _highScoreStorageKey = 'highScore';

  late double _yFloor;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _yFloor = size[1] - (size[0] * 112 / 336); // ratio of floor.png

    await _initCache();
    _prefs = await SharedPreferences.getInstance();
    _highScore = _prefs.getInt(_highScoreStorageKey);

    add(ScreenHitbox());
    add(Background());

    final floorLayer = await loadParallaxLayer(
      ParallaxImageData('floor.png'),
      fill: LayerFill.width,
      alignment: Alignment.bottomLeft,
    );

    final parallax = Parallax(
      [floorLayer],
      baseVelocity: Vector2(speed, 0),
    );

    final parallaxComponent =
        ParallaxComponent(parallax: parallax, priority: 2);
    add(parallaxComponent);

    add(InitScreen());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isPlaying == false) {
      _delayBeforeRestarting--;
      return;
    }
    if (_hasBirdCollidedWithFloor()) {
      onGameOver();
      return;
    }
    removeAll(_pipes.where((element) => element.hasDisappeared == true));
    _pipes.removeWhere((element) => element.hasDisappeared == true);

    _pipes
        .where((element) => element.canUpdateScore && element.fullyInitialized)
        .forEach((element) {
      if ((element.topPipeBody.x + element.topPipeBody.width / 2) <=
          (widthBird + distanceFromLeftBird)) {
        playSound('point.wav');

        _score = (_score ?? 0) + 1;
        element.canUpdateScore = false;
      }
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_isPlaying) {
      _textPaint.render(
        canvas,
        _score.toString(),
        Vector2(size[0] / 2, size[1] / 8),
        anchor: Anchor.center,
      );
      return;
    }
    if (_score != null) {
      _textPaint.render(
        canvas,
        "Score: ${_score.toString()}",
        Vector2(size[0] / 2, size[1] / 8),
        anchor: Anchor.center,
      );
    }
    if (_highScore != null) {
      TextPaint(
        style: const TextStyle(fontFamily: 'flappy_bird', fontSize: 30),
      ).render(
        canvas,
        "High score: ${_highScore.toString()}",
        Vector2(size[0] / 2, size[1] / 8 + 45),
        anchor: Anchor.center,
      );
    }
  }

  @override
  void onTap() {
    super.onTap();
    if (_isPlaying == true) {
      _bird.onTap();
      return;
    }
    if (_delayBeforeRestarting > 0) {
      return;
    }
    _onRestartGame();
  }

  onGameOver() async {
    _isPlaying = false;
    _delayBeforeRestarting = 35;
    if ((_score ?? 0) >= (_highScore ?? 0)) {
      _highScore = _score;
      await _prefs.setInt(_highScoreStorageKey, _highScore!);
    }
    playSound('hit.wav');

    _timer?.cancel();
    remove(_bird);
    removeAll(_pipes);
    _pipes.clear();
    add(InitScreen());
  }

  _onRestartGame() {
    removeWhere((c) => c is InitScreen);
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer time) {
      final p = Pipes();
      _pipes.add(p);
      add(p);
    });
    _bird = Bird();
    add(_bird);
    _score = 0;
    _isPlaying = true;
  }

  bool _hasBirdCollidedWithFloor() {
    return _isPlaying == true && (_bird.y + _bird.height) >= _yFloor;
  }

  Future<void> _initCache() async {
    await FlameAudio.audioCache.loadAll(['hit.wav', 'point.wav', 'wing.wav']);
  }
}
