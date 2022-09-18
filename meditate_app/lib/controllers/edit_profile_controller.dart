import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:meditate_app/models/user.dart';

class EditProfileController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();

  final TextEditingController streetAddress = TextEditingController();
  final TextEditingController apt = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController zipcode = TextEditingController();

  final Rx<String> clothingGender = "All".obs;

  AuthController auth = Get.find();

  EditProfileController() {
    name.text = auth.user.value.fullName;
    username.text = auth.user.value.username;
    streetAddress.text = auth.user.value.streetAddress;
    apt.text = auth.user.value.apt;
    city.text = auth.user.value.city;
    state.text = auth.user.value.state;
    zipcode.text = auth.user.value.zipcode;
    clothingGender.value = auth.user.value.clothingGender;
    if (clothingGender.value == "") {
      clothingGender.value == "All";
    }
  }

  Future<void> updateUser() async {
    User user = await Api.user.updateUser(name.text, streetAddress.text,
        apt.text, city.text, state.text, zipcode.text, clothingGender.value);
    auth.setUser(user);
  }

  Future<void> changeProfilePhoto() async {
    print("whos joe");
    AuthController authController = Get.find();
    await authController.changeProfilePic();
    print("joe mama");
  }
}
