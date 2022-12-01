import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird/flappy_game.dart';

class Background extends ParallaxComponent<FlappyGame> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax([
      ParallaxImageData('background.png'),
    ]);
  }
}
