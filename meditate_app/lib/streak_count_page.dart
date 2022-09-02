import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:animated_counter/animated_counter.dart';

class StreakCountPage extends StatefulWidget {
  const StreakCountPage({Key? key}) : super(key: key);

  @override
  State<StreakCountPage> createState() => _StreakCountPageState();
}

class _StreakCountPageState extends State<StreakCountPage> with TickerProviderStateMixin  {

  late int streak;
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    SaveController saveController = Get.find();
    streak = saveController.streak.value - 1 < 0 ? 0 : saveController.streak.value - 1;
   
    increaseCount();
  }

  Future<void> increaseCount() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
       streak+=1;
       opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.white,
      body: Container(
        
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            AnimatedOpacity(
   	          duration: const Duration(milliseconds: 800),
              opacity: opacity,
                child: Container(
                  height: 300,
                  width: 409,
                  child: Image.asset("assets/fire_joypixel.gif")),
              ),

                Container(
                
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(streak.toString(), style: TextStyle(fontSize: 120, color: Colors.orange)),
                )),

                   Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(streak.toString() + " day streak!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )),

                   Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Meditate every day to build your streak", style: TextStyle(fontSize: 14)),
                )),
                SizedBox(height: 50,),
                
                
                GestureDetector(
                  onTap: () {
                   Get.offAll(AppPages());
                  },
                  child: Container(
                    
                    color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 100),
                    child: Text("Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                  )),
                )
            ],
          ),
        )
      ,)
    );
  }
}