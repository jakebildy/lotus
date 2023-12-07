// Import package
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditate_app/api/pictures_api.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/search_controller.dart';
import 'package:meditate_app/models/follow.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:meditate_app/pages/shellevate.dart';
import 'package:meditate_app/services/push_notification_service.dart';
import 'package:meditate_app/pages/signup/signup.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:permission_handler/permission_handler.dart';

User DummyUser = User(
  id: "-1",
  email: "...",
  fullName: "Loading User",
  username: "null",
  createdAt: DateTime.now(),
  lastMeditated: DateTime.now(),
  meditationTimesAsOf: DateTime.now(),
  meditationHistory: {},
);

class AuthController extends GetxController {
  final SaveController saveController = Get.find();
  final PushNotificationService pushNotificationService = Get.find();

  // If we are not logged in the user will be null
  // The user may exist but the account is not logged in
  // if the user has not verified phone number
  // Use isAuthenticated to check if user is logged in
  final Rx<User> user = DummyUser.obs;
  bool get isAuthenticated => user.value.id != DummyUser.id;

  final TextEditingController loginUsername = TextEditingController(text: "");
  final TextEditingController loginPassword = TextEditingController(text: "");

  final TextEditingController signupEmail = TextEditingController();
  final TextEditingController signupUsername = TextEditingController();
  final TextEditingController signupPassword = TextEditingController();
  final TextEditingController signupPhoneNumber = TextEditingController();

  final TextEditingController verificationCode = TextEditingController();

  final TextEditingController resetPhone = TextEditingController();
  final TextEditingController resetNewPassword = TextEditingController();
  final TextEditingController resetToken = TextEditingController();

  final Rx<String> countryCode = "+1".obs;

  final Rx<String> signupWarningMessage = "".obs;
  final Rx<String> loginWarningMessage = "".obs;
  final Rx<String> verificationCodeWarningMessage = "".obs;

  final Rx<String> displayName = "".obs;

  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isLoadingPageNotDone = false.obs;
  @override
  void onInit() {
    super.onInit();
    loginFromCookiesRequest();

    user.listen((User user) {
      logSuccess("🔥AUTH: User value has been set ${user.username}");
      pushNotificationService.updateDeviceToken();
      Get.put(FollowController());
      Get.put(SearchController());
      SaveController saveController = Get.find();
      saveController.updateFetchedData(user);
      saveController.uploadLocalData();
    });
  }

  Future<void> setUser(User newUser) async {
    user.value = newUser;
    try {
      await saveController.saveCookies(Api.cookies);
      String cookies = saveController.getCookies();
    } catch (error, trace) {
      logError("Failed to set user " + error.toString());
      logError(trace.toString());
    }
    update();
  }

  // On Success: set user, isAuthenticated to true and go to main page.
  // On fail: user is not logged in - do nothing
  void loginFromCookiesRequest() async {
    try {
      isLoading.value = true;
      update();
      String cookies = saveController.getCookies();
      Api.setCookies(cookies);
      user.value = await Api.user.me();
    } catch (e, stackTrace) {
      logError(e.toString());
      logError(stackTrace.toString());
    }
    waitThenSetLoadingFalse();
    update();
  }

  Future<void> waitThenSetLoadingFalse() async {
    await Future.delayed(const Duration(seconds: 4));
    isLoading.value = false;
    update();
    // Get.offAll(AppPages(),
    //     transition: Transition.fadeIn, duration: Duration(seconds: 2));
  }

  void refreshUser() async {
    try {
      user.value = await Api.user.me();
    } catch (e) {
      logError(e.toString());
    }
    update();
  }

  void logoutRequest() async {
    isLoading.value = false;
    try {
      String message = await Api.auth.logout();
      logSuccess(message);
    } catch (error, trace) {
      logError(error.toString());
      logError(trace.toString());
    }
    user.value = DummyUser;
    // isAuthenticated.value = false;
    saveController.clearCookies();
    Get.offAll(const Signup());

    update();
  }

  Future<Null> _cropImage(image) async {
    try {
      logInfo("Cropping image...");

      File? croppedFile = await (ImageCropper()).cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          androidUiSettings: const AndroidUiSettings(
              toolbarTitle: 'Crop Profile Photo',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              hideBottomControls: true,
              lockAspectRatio: true),
          iosUiSettings: const IOSUiSettings(
            title: 'Crop Profile Photo',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
          ));
      if (croppedFile != null) {
        logInfo("Cropped file is about to be uploaded");
        croppedFile.readAsBytes().then((bytes) {
          String base64 = base64Encode(bytes);
          String fileName = croppedFile.path.split("/").last;

          PicturesApi().setProfilePicture(fileName, base64).then((newUser) {
            logSuccess("Set profile picture successfully");
            user.value = newUser;
            update();
          }).catchError((error) {
            logError("Failed to set profile pic!");
            logError(error);
          });
        });
      }
    } catch (error) {
      logError("Failed to crop image!");
      logError(error.toString());
    }
  }

  Future<void> changeProfilePic() async {
    logInfo("Changing profile pic!");
    // check permission
    try {
      bool _hasPermission = await Permission.photos.request().isGranted;
      // && await Permission.camera.request().isGranted;
      if (_hasPermission) {
        logInfo("We have permissions!");
        ImagePicker()
            .pickImage(
                source: ImageSource.gallery, maxHeight: 500, maxWidth: 500)
            .then((image) {
          //Todo consider increasing image quality
          try {
            _cropImage(image);
          } catch (error) {
            logError("Failed to crop image: " + error.toString());
          }
        }).catchError((error) {
          logError("ERROR Getting Image: ");
          logError(error.toString());
        });
      } else {
        logError("No permission to change photo");
      }
    } catch (error, trace) {
      logError(error.toString());
      logError(trace.toString());
    }
    // ImagePicker().getIma   ge(source: null)
  }

  // Future<void> resetPassword1() async {
  //   final String _number = "${countryCode.value}${resetPhone.text}";
  //   try {
  //     Api.auth.requestResetPasswordToken(_number);
  //     Get.to(Reset2Page());
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> resetPassword2() async {
  //   final String _number = "${countryCode.value}${resetPhone.text}";
  //   try {
  //     await Api.auth
  //         .resetPassword(_number, resetToken.text, resetNewPassword.text);
  //     try {
  //       user.value = await Api.auth.login(
  //           "${countryCode.value}${resetPhone.text}", resetNewPassword.text);
  //       // isAuthenticated.value = true;
  //       saveService.saveCookies(Api.cookies);
  //       // _authenticateLitsocket();
  //       gotoMain();
  //     } catch (e, stackTrace) {
  //       print(e);
  //       //loginWarningMessage.value = e.toString();
  //       print(stackTrace);
  //     }

  //     update();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> _displayChangeNameDialog(BuildContext context) async {
    TextEditingController _textFieldController = new TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change Display Name'),
            content: TextField(
              onChanged: (value) {
                // setState(() {
                //   valueText = value;
                // });
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Enter new name"),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                child:
                    const Text('CANCEL', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (_textFieldController.text != "") {
                    Api.user.changeName(_textFieldController.text);
                    displayName.value = _textFieldController.text;
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> changeName(BuildContext context) async {
    _displayChangeNameDialog(context);
    update();
  }
}
