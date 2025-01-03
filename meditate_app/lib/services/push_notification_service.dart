import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:meditate_app/api/index.dart' as api;
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/logger.dart';

class PushNotificationService extends GetxService {
  late FirebaseMessaging firebaseMessaging;
  late final String? token;
  PushNotificationService() {
    _init();
  }

  void _init() async {
    try {
      await Firebase.initializeApp();
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission();
      PostHogService posthog = Get.find();

      // Check the authorization status
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // User granted permission
        posthog.logEvent("PUSH_NOTIFICATIONS_ENABLED", {});
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        // User granted provisional permission
        posthog.logEvent("PUSH_NOTIFICATIONS_ENABLED", {});
      } else {
        // User denied or did not respond to the permission request
        posthog.logEvent("PUSH_NOTIFICATIONS_DENIED", {});
      }

      FirebaseMessaging.onBackgroundMessage(_messageHandler);
      firebaseMessaging = FirebaseMessaging.instance;
      String? _token = await firebaseMessaging.getToken();
      logInfo("🔥💢📞 FireBase Messaging Device Token: $_token");
      token = _token;

      // Get any messages which caused the application to open from
      // a terminated state.
      RemoteMessage? initialMessage =
          await firebaseMessaging.getInitialMessage();

      // If the message also contains a data property with a "type" of "chat",
      // navigate to a chat screen
      if (initialMessage != null) {
        logInfo("Message opened app from closed");
        logInfo(initialMessage.data.toString());
      }

      //Listens for when the app is in the background, and the notification is pressed
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        logInfo("Message opened app");
        logInfo(message.data.toString());
      });
    } catch (error, trace) {
      logError("error initializing firebase messaging.");
      logError(error.toString());
      logError(trace.toString());
    }
  }

  void updateDeviceToken() async {
    try {
      if (token == null) {
        return logError("💢💢💢 Cannot update a NULL device token!");
      }
      await api.user.updateDeviceToken(token!);
    } catch (error, trace) {
      logError("error updating firebase device token.");
      logError(error.toString());
      logError(trace.toString());
    }
  }

  Future<void> _messageHandler(RemoteMessage message) async {
    logInfo('background message ${message.notification!.body}');
  }
}
