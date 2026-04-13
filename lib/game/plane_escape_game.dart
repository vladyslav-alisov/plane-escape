import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'components/player_plane.dart';
import 'components/obstacle.dart';
import 'constants.dart';
import '../services/high_score_service.dart';

class PlaneEscapeGame extends FlameGame with HasCollisionDetection, PanDetector {
  final HighScoreService _scoreService = HighScoreService();
  late PlayerPlane player;
  Timer? _spawnTimer;
  double score = 0;
  bool isGameOver = false;
  late TextComponent scoreText;
  final Random _random = Random();

  @override
  Color backgroundColor() => const Color(0xFF1E1E1E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    final background = await loadParallaxComponent(
      [ParallaxImageData('game_background.png')],
      baseVelocity: Vector2(0, -200), // Negative Y moves the image DOWN in Flame Parallax
      repeat: ImageRepeat.repeat,
      fill: LayerFill.width,
    );
    background.priority = -1;
    add(background);

    _spawnTimer = Timer(
      GameConstants.obstacleSpawnInterval,
      onTick: _spawnObstacle,
      repeat: true,
    );
    _setupGame();
  }

  void _setupGame() {
    isGameOver = false;
    score = 0;
    
    // Clear existing components if resetting
    children.whereType<PlayerPlane>().forEach((p) => p.removeFromParent());
    children.whereType<Obstacle>().forEach((o) => o.removeFromParent());
    children.whereType<TextComponent>().forEach((t) => t.removeFromParent());

    player = PlayerPlane();
    add(player);

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(size.x / 2, 50),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);

    _spawnTimer?.start();
  }

  void _spawnObstacle() {
    if (isGameOver) return;
    
    // Spawn horizontally constrained within screen boundaries
    double maxX = size.x - GameConstants.obstacleWidth;
    double spawnX = GameConstants.obstacleWidth / 2 + _random.nextDouble() * maxX;

    add(Obstacle(position: Vector2(spawnX, -100)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isGameOver) {
      _spawnTimer?.update(dt);
      score += dt;
      scoreText.text = 'Score: ${(score).toInt()}';
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (isGameOver) return;
    
    // Move player horizontally, constraining to screen
    double newX = player.position.x + info.delta.global.x;
    
    // Keep player fully on screen
    double halfWidth = GameConstants.playerSize / 2;
    if (newX < halfWidth) newX = halfWidth;
    if (newX > size.x - halfWidth) newX = size.x - halfWidth;
    
    player.position.x = newX;
  }

  void gameOver() {
    isGameOver = true;
    _spawnTimer?.pause();
    _scoreService.saveHighScore(score);
    pauseEngine();
    overlays.remove('PauseButton');
    overlays.add('GameOver');
  }

  void resetGame() {
    overlays.remove('GameOver');
    overlays.add('PauseButton');
    resumeEngine();
    _setupGame();
  }

  void pauseGame() {
    pauseEngine();
    overlays.remove('PauseButton');
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    overlays.remove('PauseMenu');
    overlays.add('PauseButton');
    resumeEngine();
  }
}
