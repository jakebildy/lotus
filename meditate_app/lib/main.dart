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
import 'package:meditate_app/controllers/subscription_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/shellevate.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/services/push_notification_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_app_badger/flutter_app_badger.dart';

// Add this as a global variable
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: true,
    requestSoundPermission: false,
    // Add these to handle background notifications
    notificationCategories: <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        'badge_update',
        actions: <DarwinNotificationAction>[],
      ),
    ],
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    iOS: initializationSettingsIOS,
  );

  // Initialize once with the notification handler
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) async {
      if (details.payload == 'badge_update') {
        await FlutterAppBadger.updateBadgeCount(1);
        // Reschedule for next day
        await scheduleDailyBadgeUpdate();
      }
    },
  );
}

Future<void> scheduleDailyBadgeUpdate() async {
  // Cancel any existing notifications
  await flutterLocalNotificationsPlugin.cancelAll();

  // Schedule for next midnight
  final now = DateTime.now();
  final nextMidnight = DateTime(now.year, now.month, now.day + 1);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // notification id
    '', // empty title
    '', // empty body
    tz.TZDateTime.from(nextMidnight, tz.local),
    const NotificationDetails(
      iOS: DarwinNotificationDetails(
        badgeNumber: 1,
        presentBadge: true,
        presentSound: false,
        presentAlert: false,
        categoryIdentifier: 'badge_update', // Add this
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
    payload: 'badge_update',
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await initializeNotifications();
  await scheduleDailyBadgeUpdate();

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

  if (!Get.isRegistered<SubscriptionController>()) {
    // If the controller does not exist, create and register it
    Get.put(SubscriptionController());
  }

  if (!Get.isRegistered<FollowController>()) {
    // If the controller does not exist, create and register it
    Get.put(FollowController());
  }

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
          Get.find<CountdownController>().appPaused();
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
      default:
        logInfo(msg!);
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
