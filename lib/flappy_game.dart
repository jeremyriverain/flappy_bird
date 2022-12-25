import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:flappy_bird/background.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/floor.dart';
import 'package:flappy_bird/init_screen.dart';
import 'package:flappy_bird/pipes.dart';

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  List<Floor> floorComponents = [];

  final List<Pipes> pipes = [];

  Bird bird = Bird();

  Timer? timer;

  InitScreen initScreen = InitScreen();

  bool isPlaying = false;

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
    isPlaying = true;
  }

  @override
  void update(double dt) {
    _updateFloorComponents();
    removeAll(pipes.where((element) => element.hasDisappeared == true));
    pipes.removeWhere((element) => element.hasDisappeared == true);

    super.update(dt);
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
  void onTap() {
    if (isPlaying == true) {
      bird.onTap();
      return;
    }
    onRestartGame();
  }
}
