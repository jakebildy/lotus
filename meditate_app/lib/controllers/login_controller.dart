// Import package

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/api/index.dart' as Api;

class LoginController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final Rx<String> warningMessage = "".obs;
  final Rx<bool> isLoading = false.obs;

  // Login
  void login() async {
    try {
      final String _email = "${email.text}";
      final User user = await Api.auth.login(
        _email,
        password.text,
      );
      print(user);
      AuthController authController = Get.find();
      authController.setUser(user);
      Get.offAll(AppPages());
    } catch (error, trace) {
      print("error signing up");
      print(error);
      print(trace);
      warningMessage.value = error.toString();
    }
    update();
  }
}
