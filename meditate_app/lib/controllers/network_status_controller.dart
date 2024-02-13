import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';

/// NetworkStatusController checks if the user is online. It logs in if the connection is restored.
/// {@category Controllers}
class NetworkStatusController extends GetxController {
  RxBool offline = false.obs;

  NetworkStatusController() {
    DataConnectionChecker().onStatusChange.listen(
      (status) async {
        _getNetworkStatus(status);
        // Wait for User Controller to exist
        // if (Get.find<UserController>().initialized) {}
      },
    );
  }

  Future<void> _getNetworkStatus(DataConnectionStatus status) async {
    if (status == DataConnectionStatus.connected) {
      offline.value = false;

      //Login if not already logged in
      UserController userController = Get.find();
      if (userController.user.value == noUser) {
        await userController.loginFromCookiesRequest();
        await Get.find<UserController>().syncData();
      }
    } else {
      offline.value = true;
      Get.find<SaveController>().updateSelectedAmbience("Water Sounds");
      await Get.find<UserController>().syncData();
    }
    Get.find<UserController>().loadStreak();
    update();
  }
}
