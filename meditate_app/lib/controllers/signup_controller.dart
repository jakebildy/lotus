// Import package

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/api/index.dart' as Api;

class SignupController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final Rx<String> signupWarningMessage = "".obs;
  final Rx<bool> isLoading = false.obs;

  // Signup
  void signup() async {
    try {
      final String _email = "${email.text}";
      final User user = await Api.auth.signup(
        _email,
        password.text,
        fullName.text,
        username.text.toLowerCase().replaceAll(" ", "_"),
      );
      print("signing up user:");
      print(user.email);
      print(user.id);
      AuthController authController = Get.find();
      authController.setUser(user);
      Get.offAll(AppPages());
    } catch (error, trace) {
      print("error signing up");
      print(error);
      print(trace);
      String msg = "";

      if (error.toString().contains("Not a valid email")) {
        msg = error.toString();
      } else if (jsonDecode(error.toString())["message"] != null) {
        msg = jsonDecode(error.toString())["message"];
      } else if (error.toString().contains('"code":11000')) {
        msg = "This username or email is taken";
      } else if (msg.contains("email: Path `email` is required")) {
        msg = "No email address provided";
      } else if (msg.contains("fullName: Path `fullName` is required")) {
        msg = "No name provided";
      } else if (msg.contains("username: Path `username` is required")) {
        msg = "No username provided";
      } else if (msg.contains("password: Path `password` is required")) {
        msg = "No password provided";
      }

      signupWarningMessage.value = msg;
    }
    update();
  }
}
