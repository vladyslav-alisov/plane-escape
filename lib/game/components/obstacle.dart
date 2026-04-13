import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../constants.dart';
import '../plane_escape_game.dart';
import 'player_plane.dart';

class Obstacle extends SpriteComponent
    with HasGameReference<PlaneEscapeGame>, CollisionCallbacks {
  Obstacle({required Vector2 position})
    : super(
        position: position,
        size: Vector2(
          GameConstants.obstacleWidth * 0.8,
          GameConstants.obstacleHeight * 0.8,
        ),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('enemy_plane.png');
    angle = pi;
    // Add hitbox that is smaller than the sprite to avoid corner-clash
    add(RectangleHitbox(
      size: Vector2(size.x * 0.8, size.y * 0.7),
      position: Vector2(size.x * 0.1, size.y * 0.15),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) return;

    position.y += GameConstants.obstacleFallSpeed * dt;

    if (position.y > game.size.y + size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerPlane) {
      game.gameOver();
    }
  }
}
