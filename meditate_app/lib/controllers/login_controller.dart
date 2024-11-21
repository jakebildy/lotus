// Import package

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/api/index.dart' as api;
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/version.dart';

/// LoginController handles user logins
/// {@category Controllers}
class LoginController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final Rx<String> warningMessage = "".obs;
  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isLoggingIn = false.obs;

  // Login
  void login() async {
    try {
      isLoggingIn.value = true;
      final String _email = email.text;
      final User user = await api.auth.login(
        _email,
        password.text,
      );
      logSuccess("Logged in " + user.fullName);
      UserController userController = Get.find();
      userController.setUser(user);

      //Log the event to AppsFlyer
      PostHogService posthog = Get.find();
      posthog.logEvent("LOGIN", {"version": APP_VERSION});

      isLoggingIn.value = false;
      Get.offAll(const AppPages());
    } catch (error, trace) {
      logError("Error signing up " + error.toString());
      logError(trace.toString());
      warningMessage.value = error.toString();
      isLoggingIn.value = false;
    }
    update();
  }
}
