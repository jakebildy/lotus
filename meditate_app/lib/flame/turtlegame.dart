import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:meditate_app/flame/components/turtle_world.dart';

class TurtleGame extends FlameGame with HasTappables {
  late Sprite background;
  TurtleWorld _turtleWorld = TurtleWorld();
  Square player = Square(Vector2(400, 400));

  @override
  Future<void> onLoad() async {
    await add(_turtleWorld);
    add(player);
    camera.followComponent(player);
  }

  @override
  void onTapUp(int id, TapUpInfo info) {
    super.onTapUp(id, info);
    if (!info.handled) {
      final touchPoint = info.eventPosition.game;
      //add(Square(touchPoint));
      player.angle = math.atan2(touchPoint.x - player.position.x,
          -1 * (touchPoint.y - player.position.y));
      player.add(
        MoveByEffect(
            Vector2(touchPoint.x - player.position.x,
                touchPoint.y - player.position.y),
            EffectController(duration: 1)),
      );
    }
  }
}

class Square extends SpriteComponent with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 200.0;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  Square(Vector2 position) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    // angle += speed * dt;
    // angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('turtle_basic.png');
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
  }

  // @override
  // bool onTapUp(TapUpInfo info) {
  //   removeFromParent();
  //   info.handled = true;
  //   return true;
  // }
}

class TurtleGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: add UI overlay on top via Stack
    return GameWidget.controlled(gameFactory: TurtleGame.new);
  }
}
