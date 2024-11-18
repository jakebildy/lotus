import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meditate_app/controllers/app_pages_controller.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/cookie_controller.dart';
import 'package:meditate_app/controllers/countdown_controller.dart';
import 'package:meditate_app/controllers/egg_controller.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/game_controller.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/shellevate.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/services/push_notification_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

Future<void> main() async {
  try {
    await GetStorage.init();
  } catch (error) {
    logError("Get Storage is not working:");
    logError(error.toString());
  }

  Get.put(AppPagesController());
  Get.put(PushNotificationService());

  Get.put(SaveController());
  Get.put(CookieController());

  Get.put(NetworkStatusController());
  Get.put(UserController());
  Get.put(AuthController());
  Get.put(PostHogService());
  Get.put(GameController());
  Get.put(EggController());
  Get.put(CountdownController());
  // Get.put(SubscriptionController());

  final AudioContext audioContext = AudioContext(
    iOS: AudioContextIOS(
      defaultToSpeaker: true,
      category: AVAudioSessionCategory.playback,
      options: [
        AVAudioSessionOptions.allowBluetooth,
        AVAudioSessionOptions.mixWithOthers,
      ],
    ),
    android: AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.gain,
    ),
  );
  AudioPlayer.global.setGlobalAudioContext(audioContext);

  runApp(const MyApp());
  SystemChannels.lifecycle.setMessageHandler((msg) {
    switch (msg) {
      case 'AppLifecycleState.paused':
        {
          Get.find<CountdownController>().pauseApp();
          logInfo(msg.toString());
        }
        break;
      case 'AppLifecycleState.resumed':
        {
          Get.find<CountdownController>().resumeApp();
          logInfo(msg.toString());
          // SaveController save = Get.find();
          // save.loadData();
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
      navigatorObservers: [
        // The PosthogObserver records screen views automatically
        PosthogObserver(),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Meditate',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.dark(),
      home: const Shellevate(),
    );
  }
}
