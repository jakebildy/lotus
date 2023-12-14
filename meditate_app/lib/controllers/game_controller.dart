import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

/// GameController manages the logic for the Flame-based game.
/// {@category Controllers}
class GameController extends GetxController {
  RxInt selectedTurtle = 0.obs;
  RxInt turtleColor = 0.obs;
  BuildContext? localContext;

  void startGame(int turtleID, int turtleColorNew, BuildContext context) {
    selectedTurtle.value = turtleID;
    turtleColor.value = turtleColorNew;
    localContext = context;
    update();
  }
}
