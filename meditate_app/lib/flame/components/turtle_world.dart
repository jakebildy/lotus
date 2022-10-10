import 'package:flame/components.dart';

class TurtleWorld extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('game_background.jpeg');
    size = sprite!.originalSize;
  }
}
