import 'package:flame/game.dart';

import 'package:flappy_bird/background.dart';
import 'package:flappy_bird/floor.dart';

class FlappyGame extends FlameGame {
  List<Floor> floorComponents = [];

  @override
  Future<void> onLoad() async {
    add(Background());

    _loadFloorComponents();
  }

  @override
  void update(double dt) {
    _updateFloorComponents();
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
}
