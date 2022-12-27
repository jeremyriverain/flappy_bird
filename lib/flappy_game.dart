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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  final List<Pipes> pipes = [];

  Bird bird = Bird();

  Timer? timer;

  InitScreen initScreen = InitScreen();

  bool isPlaying = false;

  int? score;
  int? highScore;
  TextPaint textPaint = TextPaint(
    style: const TextStyle(fontFamily: 'flappy_bird', fontSize: 45),
  );

  late SharedPreferences prefs;
  final highScoreStorageKey = 'highScore';

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.loadAll(['hit.wav', 'point.wav', 'wing.wav']);
    prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(highScoreStorageKey);

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

    add(initScreen);
  }

  onGameOver() async {
    isPlaying = false;
    if ((score ?? 0) >= (highScore ?? 0)) {
      highScore = score;
      await prefs.setInt(highScoreStorageKey, highScore!);
    }
    FlameAudio.play('hit.wav');
    timer?.cancel();
    remove(bird);
    removeAll(pipes);
    pipes.clear();
    add(initScreen);
  }

  onRestartGame() {
    remove(initScreen);
    timer = Timer.periodic(const Duration(seconds: 2), (Timer time) {
      final p = Pipes();
      pipes.add(p);
      add(p);
    });
    bird = Bird();
    add(bird);
    score = 0;
    isPlaying = true;
  }

  @override
  void update(double dt) {
    removeAll(pipes.where((element) => element.hasDisappeared == true));
    pipes.removeWhere((element) => element.hasDisappeared == true);

    pipes
        .where((element) => element.canUpdateScore && element.fullyInitialized)
        .forEach((element) {
      if ((element.topPipeBody.x + element.topPipeBody.width / 2) <=
          (widthBird + distanceFromLeftBird)) {
        FlameAudio.play('point.wav');
        score = (score ?? 0) + 1;
        element.canUpdateScore = false;
      }
    });

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isPlaying) {
      textPaint.render(
        canvas,
        score.toString(),
        Vector2(size[0] / 2, size[1] / 8),
        anchor: Anchor.center,
      );
      return;
    }
    if (score != null) {
      textPaint.render(
        canvas,
        "Score: ${score.toString()}",
        Vector2(size[0] / 2, size[1] / 8),
        anchor: Anchor.center,
      );
    }
    if (highScore != null) {
      TextPaint(
        style: const TextStyle(fontFamily: 'flappy_bird', fontSize: 30),
      ).render(
        canvas,
        "High score: ${highScore.toString()}",
        Vector2(size[0] / 2, size[1] / 8 + 45),
        anchor: Anchor.center,
      );
    }
  }

  @override
  void onTap() {
    if (isPlaying == true) {
      bird.onTap();
      return;
    }
    onRestartGame();
  }
}
