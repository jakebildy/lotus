import 'package:get/get.dart';

/// AppPagesController handles the logic for managing which app page you are on.
/// {@category Controllers}
class AppPagesController extends GetxController {
  RxInt page = 0.obs;

  void switchPage(int newPage) {
    page.value = newPage;
    update();
  }
}
