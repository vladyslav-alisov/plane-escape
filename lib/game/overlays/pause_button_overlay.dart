import 'package:flutter/material.dart';
import '../plane_escape_game.dart';

class PauseButtonOverlay extends StatelessWidget {
  final PlaneEscapeGame game;

  const PauseButtonOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
            icon: const Icon(Icons.pause, color: Colors.white, size: 36),
            onPressed: () {
              game.pauseGame();
            },
          ),
        ),
      ),
    );
  }
}
