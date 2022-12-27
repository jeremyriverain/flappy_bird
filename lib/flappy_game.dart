import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/components.dart' show Anchor;

import 'package:flappy_bird/background.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/constants.dart';
import 'package:flappy_bird/floor.dart';
import 'package:flappy_bird/init_screen.dart';
import 'package:flappy_bird/pipes.dart';
import 'package:flutter/material.dart';

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  List<Floor> floorComponents = [];

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

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.loadAll(['hit.wav', 'point.wav', 'wing.wav']);

    add(ScreenHitbox());
    add(Background());

    _loadFloorComponents();

    add(initScreen);
  }

  onGameOver() {
    isPlaying = false;
    if ((score ?? 0) >= (highScore ?? 0)) {
      highScore = score;
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

  void _loadFloorComponents() {
    floorComponents = [
      Floor(initialLeftPosition: 0),
      Floor(initialLeftPosition: size[0]),
    ];
    for (var floorComponent in floorComponents) {
      add(floorComponent);
    }
  }

  void _updateFloorComponents() {
    floorComponents
        .where((element) => element.hasDisappeared == true)
        .forEach((element) {
      remove(element);
      floorComponents.removeAt(0);
      floorComponents.add(Floor(initialLeftPosition: size[0] - 5));
      add(floorComponents.last);
    });
  }

  @override
  void update(double dt) {
    _updateFloorComponents();
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
    } else if (score != null) {
      textPaint.render(
        canvas,
        "Score: ${score.toString()}",
        Vector2(size[0] / 2, size[1] / 8),
        anchor: Anchor.center,
      );
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
