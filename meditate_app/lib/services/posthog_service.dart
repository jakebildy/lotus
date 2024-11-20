import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class PostHogService extends GetxService {
  PostHogService() {
    _init();
  }

  void _init() async {
    WidgetsFlutterBinding.ensureInitialized();

    final config =
        PostHogConfig('phc_hcULVPfgvDYUpSsgy6t69M8PX72L1WPm1NBe8aDZ0DU');
    config.debug = true;
    config.captureApplicationLifecycleEvents = true;
    config.host = 'https://us.i.posthog.com';
    await Posthog().setup(config);
  }

  Future<void> logEvent(
      String eventName, Map<String, Object>? eventValues) async {
    logInfo("Logging event $eventName to PostHog!");
    await Posthog().capture(
      eventName: eventName,
      properties: eventValues,
    );
  }

  Future<void> identifyUser(String username) async {
    await Posthog().identify(userId: username);
  }
}
