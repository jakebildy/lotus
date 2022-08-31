import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/begin_meditation_page.dart';
import 'package:meditate_app/countdown_page.dart';
import 'package:meditate_app/controllers/save_controller.dart';

Future<void> main() async {
  try {
    await GetStorage.init();
  } catch (error) {
    print("uh oh! stinky");
    print(error);
  }
  Get.put(SaveController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meditate',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const AppPages(),
    );
  }
}

