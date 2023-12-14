import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/game_controller.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/begin_meditation_page.dart';
import 'package:meditate_app/pages/countdown_page.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/shellevate.dart';
import 'package:meditate_app/services/heap_service.dart';
import 'package:meditate_app/services/push_notification_service.dart';
import 'package:meditate_app/util/logger.dart';

Future<void> main() async {
  try {
    await GetStorage.init();
  } catch (error) {
    logError("Get Storage is not working:");
    logError(error.toString());
  }

  Get.put(PushNotificationService());
  Get.put(NetworkStatusController());

  Get.put(SaveController()); //TODO: deprecate

  Get.put(UserController());
  Get.put(AuthController());
  Get.put(HeapService());
  Get.put(GameController());

  runApp(const MyApp());
  SystemChannels.lifecycle.setMessageHandler((msg) {
    switch (msg) {
      case 'AppLifecycleState.paused':
        {
          logInfo(msg.toString());
        }
        break;
      case 'AppLifecycleState.resumed':
        {
          logInfo(msg.toString());
          SaveController save = Get.find();
          save.loadData();
          FollowController follow = Get.find();
          follow.fetchFollows();

          logInfo("Resuming App.");
          // Check if Timer is running
          // If so, update State accordingly
        }
        break;
    }
    return Future.value();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meditate',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.dark(),
      home: const Shellevate(),
    );
  }
}
