import 'package:get/get.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/search_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/api/index.dart' as api;
import 'package:meditate_app/services/push_notification_service.dart';
import 'package:meditate_app/pages/signup/signup.dart';
import 'package:meditate_app/util/logger.dart';

User noUser = User(
  id: "-1",
  email: "...",
  fullName: "Loading User",
  username: "null",
  createdAt: DateTime.now(),
  lastMeditated: DateTime.now(),
  meditationTimesAsOf: DateTime.now(),
  meditationHistory: {},
);

/// UserController manages the current user. It handles syncing local storage
/// {@category Controllers}
class UserController extends GetxController {
  final PushNotificationService pushNotificationService = Get.find();
  final NetworkStatusController networkStatusController = Get.find();

  final Rx<User> databaseUser = noUser.obs;
  final Rx<User> localStorageUser = noUser.obs;

  Rx<User> get user =>
      networkStatusController.offline.value ? localStorageUser : databaseUser;

  /// Returns if the user is logged in or not.
  bool get isAuthenticated => user.value.id != noUser.id;

  final Rx<String> displayName = "".obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingPageNotDone = false.obs;

  @override
  void onInit() {
    super.onInit();
    loginFromCookiesRequest();

    databaseUser.listen((User user) {
      logSuccess("🔥AUTH: User value has been set ${user.username}");
      pushNotificationService.updateDeviceToken();
      Get.put(FollowController());
      Get.put(SearchController());
    });
  }

  Future<void> setUser(User newUser) async {
    // user.value = newUser;
    // try {
    //   // TODO: await saveController.saveCookies(api.cookies);
    // } catch (error, trace) {
    //   logError("Failed to set user " + error.toString());
    //   logError(trace.toString());
    // }
    // update();
  }

  /// Triggered when user goes offline to online
  Future<void> syncData() async {}

  /// On Success: set user, isAuthenticated to true and go to main page.
  /// On fail: user is not logged in - do nothing
  void loginFromCookiesRequest() async {
    try {
      isLoading.value = true;
      update();
      // TODO: String cookies = saveController.getCookies();
      // api.setCookies(cookies);
      databaseUser.value = await api.user.me();
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
  }

  void refreshUser() async {
    try {
      databaseUser.value = await api.user.me();
    } catch (e) {
      logError(e.toString());
    }
    update();
  }

  void logoutRequest() async {
    isLoading.value = false;
    try {
      String message = await api.auth.logout();
      logSuccess(message);
    } catch (error, trace) {
      logError(error.toString());
      logError(trace.toString());
    }
    databaseUser.value = noUser;
    localStorageUser.value = noUser;
    // isAuthenticated.value = false;
    // TODO: saveController.clearCookies();
    Get.offAll(const Signup());

    update();
  }
}
