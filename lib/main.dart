import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/flappy_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setOrientation(DeviceOrientation.portraitUp);
  final Game game = FlappyGame();

  runApp(GameWidget(game: game));
}
