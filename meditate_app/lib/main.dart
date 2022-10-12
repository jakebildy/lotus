import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/pages/begin_meditation_page.dart';
import 'package:meditate_app/pages/countdown_page.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/loading_page.dart';
import 'package:meditate_app/pages/shellevate.dart';
import 'package:meditate_app/services/appsflyer_service.dart';
import 'package:meditate_app/services/push_notification_service.dart';

Future<void> main() async {
  try {
    await GetStorage.init();
  } catch (error) {
    print("uh oh! stinky");
    print(error);
  }
  Get.put(SaveController());
  Get.put(PushNotificationService());
  Get.put(AppsflyerService());
  Get.put(AuthController());
  runApp(const MyApp());
  SystemChannels.lifecycle.setMessageHandler((msg) {
    switch (msg) {
      case 'AppLifecycleState.paused':
        {
          print(msg);
        }
        break;
      case 'AppLifecycleState.resumed':
        {
          print(msg);
          SaveController save = Get.find();
          save.loadData();
          FollowController follow = Get.find();
          follow.fetchFollows();
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
    AuthController auth = Get.find();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meditate',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.dark(),
      home: Shellevate(),
    );
  }
}
