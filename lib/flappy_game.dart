import 'package:flame/game.dart';

import 'package:flappy_bird/background.dart';
import 'package:flappy_bird/floor.dart';

class FlappyGame extends FlameGame {
  List<Floor> floorComponents = [];

  @override
  Future<void> onLoad() async {
    add(Background());

    _initFloorComponents();
  }

  @override
  void update(double dt) {
    final hiddenFloorComponents =
        floorComponents.where((element) => element.hasDisappeared == true);
    if (hiddenFloorComponents.length == 2) {
      _initFloorComponents();
    }
    super.update(dt);
  }

  _initFloorComponents() {
    removeAll(floorComponents);
    floorComponents = [
      Floor(initialLeftPosition: 0),
      Floor(initialLeftPosition: size[0]),
    ];
    for (var floorComponent in floorComponents) {
      add(floorComponent);
    }
  }
}
