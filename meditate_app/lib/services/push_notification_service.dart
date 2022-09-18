import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:meditate_app/controllers/auth_controller.dart';

class PushNotificationService extends GetxService {
  late FirebaseMessaging firebaseMessaging;
  late final String? token;
  PushNotificationService() {
    _init();
  }

  void _init() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.instance.requestPermission();
      FirebaseMessaging.onBackgroundMessage(_messageHandler);
      firebaseMessaging = FirebaseMessaging.instance;
      String? _token = await firebaseMessaging.getToken();
      print("🔥💢📞 FireBase Messaging Device Token: $_token");
      token = _token;

      // Get any messages which caused the application to open from
      // a terminated state.
      RemoteMessage? initialMessage =
          await firebaseMessaging.getInitialMessage();

      // If the message also contains a data property with a "type" of "chat",
      // navigate to a chat screen
      if (initialMessage != null) {
        print("Message opened app from closed");
        print(initialMessage.data);
      }

      //Listens for when the app is in the background, and the notification is pressed
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Message opened app");
        print(message.data);
      });
    } catch (error, trace) {
      print("error initializing firebase messaging.");
      print(error);
      print(trace);
    }
  }

  void updateDeviceToken() async {
    try {
      if (token == null)
        return print("💢💢💢 Cannot update a NULL device token!");
      await Api.user.updateDeviceToken(token!);
    } catch (error, trace) {
      print("error updating firebase device token.");
      print(error);
      print(trace);
    }
  }

  Future<void> _messageHandler(RemoteMessage message) async {
    print('background message ${message.notification!.body}');
  }
}
