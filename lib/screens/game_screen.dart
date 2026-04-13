import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/plane_escape_game.dart';
import '../game/overlays/game_over_overlay.dart';
import '../game/overlays/pause_button_overlay.dart';
import '../game/overlays/pause_menu_overlay.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<PlaneEscapeGame>.controlled(
        gameFactory: PlaneEscapeGame.new,
        overlayBuilderMap: {
          'PauseButton': (context, game) => PauseButtonOverlay(game: game),
          'PauseMenu': (context, game) => PauseMenuOverlay(game: game),
          'GameOver': (context, game) => GameOverOverlay(game: game),
        },
        initialActiveOverlays: const ['PauseButton'],
      ),
    );
  }
}
