import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/pages/loading_page.dart';

class Shellevate extends StatelessWidget {
  const Shellevate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();

    return AppPages();
  }
}
