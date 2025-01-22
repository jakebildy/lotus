import 'package:flame/components.dart';

class SandTile extends SpriteComponent {
  final bool isAboveWater;

  SandTile({
    this.isAboveWater = false,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    if (isAboveWater) {
      sprite = await Sprite.load('game/sand_tile_above_water.png');
      size = Vector2(140, 140);
      // offset position by 10
      position = Vector2(position.x - 20, position.y - 20);
    } else {
      sprite = await Sprite.load('game/sand_tile.png');
      size = Vector2(100, 100);
    }
  }
}
