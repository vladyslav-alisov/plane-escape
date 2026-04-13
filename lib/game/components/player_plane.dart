import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../constants.dart';
import '../plane_escape_game.dart';

class PlayerPlane extends SpriteComponent with HasGameReference<PlaneEscapeGame> {
  PlayerPlane()
      : super(
          size: Vector2.all(GameConstants.playerSize * 1.5),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('player_plane.png');
    // Initially place the plane near the bottom of the screen
    position = Vector2(game.size.x / 2, game.size.y - 150);
    // Add hitbox that is smaller than the sprite to avoid corner-clash
    add(RectangleHitbox(
      size: Vector2(size.x * 0.7, size.y * 0.8),
      position: Vector2(size.x * 0.15, size.y * 0.1),
    ));
  }
}
