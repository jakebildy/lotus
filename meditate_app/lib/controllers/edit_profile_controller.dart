import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';

/// EditProfileController handles updating user profiles
/// {@category Controllers}
class EditProfileController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();

  AuthController auth = Get.find();
  UserController uC = Get.find();

  EditProfileController() {
    name.text = uC.user.value.fullName;
    username.text = uC.user.value.username;
  }

  Future<void> updateUser() async {
    User user = await Api.user.updateUser(name.text);
    uC.setUser(user);
  }

  Future<void> changeProfilePhoto() async {
    AuthController authController = Get.find();
    await authController.changeProfilePic();
  }
}
