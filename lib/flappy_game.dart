import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:flappy_bird/background.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/floor.dart';
import 'package:flappy_bird/pipes.dart';

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  List<Floor> floorComponents = [];

  final List<Pipes> pipes = [];

  final Bird bird = Bird();

  @override
  Future<void> onLoad() async {
    add(ScreenHitbox());
    add(Background());

    Timer.periodic(const Duration(seconds: 2), (Timer time) {
      final p = Pipes();
      pipes.add(p);
      add(p);
    });

    _loadFloorComponents();

    add(bird);
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
    bird.onTap();
    super.onTap();
  }
}
