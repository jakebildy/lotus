import 'dart:math';

import 'package:flame/components.dart';

class SandTile extends SpriteComponent {
  final bool isAboveWater;
  final bool isDeep;

  SandTile({
    this.isAboveWater = false,
    this.isDeep = false,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // if (isAboveWater) {
    //   sprite = await Sprite.load('game/sand_tile_above_water.png');
    //   size = Vector2(140, 140);
    //   // offset position by 10
    //   position = Vector2(position.x - 20, position.y - 20);
    // } else if (isDeep) {
    //   sprite = await Sprite.load('game/sand_tile_deep.png');
    // } else {
    //   sprite = await Sprite.load('game/sand_tile.png');
    // }

    // size = Vector2(140, 140);
    // // offset position by 10
    // position = Vector2(position.x - 20, position.y - 20);

    sprite = await Sprite.load('game/sand_tile_above_water.png');
    size = Vector2(140, 140);
    // offset position by 10
    position = Vector2(position.x - 20, position.y - 20);
  }
}
