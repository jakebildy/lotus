import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';

/// NetworkStatusController checks if the user is online. It logs in if the connection is restored.
/// {@category Controllers}
class NetworkStatusController extends GetxController {
  RxBool offline = false.obs;

  NetworkStatusController() {
    DataConnectionChecker().onStatusChange.listen(
      (status) async {
        _getNetworkStatus(status);
      },
    );
  }

  void _getNetworkStatus(DataConnectionStatus status) {
    if (status == DataConnectionStatus.connected) {
      offline.value = false;

      //Login if not already logged in
      AuthController authController = Get.find();
      if (authController.user.value == DummyUser) {
        authController.loginFromCookiesRequest();
      }
    } else {
      offline.value = true;
    }
    update();
  }
}
