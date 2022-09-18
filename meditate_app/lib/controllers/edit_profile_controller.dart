import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:meditate_app/models/user.dart';

class EditProfileController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();

  AuthController auth = Get.find();

  EditProfileController() {
    name.text = auth.user.value.fullName;
    username.text = auth.user.value.username;
  }

  Future<void> updateUser() async {
    User user = await Api.user.updateUser(name.text);
    auth.setUser(user);
  }

  Future<void> changeProfilePhoto() async {
    print("whos joe");
    AuthController authController = Get.find();
    await authController.changeProfilePic();
    print("joe mama");
  }
}
