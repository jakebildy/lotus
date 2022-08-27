import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/begin_meditation_page.dart';
import 'package:meditate_app/controllers/save_controller.dart';

import 'shop_page.dart';

class AppPages extends StatefulWidget {
  const AppPages({Key? key}) : super(key: key);

  @override
  State<AppPages> createState() => _AppPagesState();
}

class _AppPagesState extends State<AppPages> {

  int _page = 0;

  @override
  Widget build(BuildContext context) {

    SaveController saveController = Get.find();
    
    return Obx(
      () => Scaffold(
          appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                const Text("🔥",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                const SizedBox(width: 3,),
                Text(saveController.streak.toString(),
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color:  saveController.streak.value == 0 ? Colors.grey :Colors.black),),
                const SizedBox(width: 10,),
               
               ],)
              ),
    
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                const Text("💎",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.grey),),
                const SizedBox(width: 3,),
                const Text("0",
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color:Colors.grey),),
                const SizedBox(width: 10,),
               
               ],)
              ),
            
          ],
        ),
        body: _page == 0 ? const BeginMeditationPage() : const ShopPage(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: ((value) => setState(() {
            _page = value;
          })),
          currentIndex: _page,
          items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.timer), label: "Home"),
               BottomNavigationBarItem(icon: Icon(Icons.store), label: "Shop"),
        ]),
      ),
    );
  }
}