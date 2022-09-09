import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/streak_count_page.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();
    bool isDarkMode = true;
    
    return Obx(
     () => Scaffold(
        appBar: AppBar(
          backgroundColor:  Colors.grey[850],
          elevation: 0,
          title: Text("My Stats"),),
        body: ListView(children: [
    
          Column(
                      children: [
                        SizedBox(height: 30,),
                         Text("You've meditated for a total of",
                        style: TextStyle( fontSize: 13,  color: Colors.white70, fontWeight: FontWeight.bold ),),
                        Text("${saveController.totalMinutes} min",
                        style: TextStyle( fontSize: 20,  color:  Colors.white, fontWeight: FontWeight.bold),),
                      ],
                    ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                      color: isDarkMode ? Colors.black12 : Colors.white,
                      border: Border.all(
                          color: isDarkMode ? Colors.white24 : Colors.black26,
                          width: 2,
                        ),
                      borderRadius: BorderRadius.circular(20), 
                      ),
              child: Column(children: [
                SizedBox(height: 10,),
                Text("Last Week", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              ],)
            ),
        ),
    
    
    
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
               height: 260,
               decoration: BoxDecoration(
                       color: isDarkMode ? Colors.black12 : Colors.white,
                       border: Border.all(
                           color: isDarkMode ? Colors.white24 : Colors.black26,
                           width: 2,
                         ),
                       borderRadius: BorderRadius.circular(20), 
                       ),
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                 Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Container(
                     width: 60,
                     child: Image.asset("assets/streak_icon.png")),
                 ),
                 SizedBox(width: 10,),
                 Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children:  [
                     Text("Streak Tier", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                     SizedBox(height: 5,),
                     Container(
                       width: 200,
                       child: Text("Reach new levels by increasing the length of your average meditation. \n\nUnlocks new colors.\n")),
                     
                     SizedBox(height: 10,),
                     
                     Text("Orange: 0-20 Minutes/Day", style: TextStyle(color: Colors.orange),),
                     SizedBox(height: 10,),
                     Text("Yellow: 20-40 Minutes/Day", style: TextStyle(color: Colors.yellow)),
                     SizedBox(height: 10,),
                     Text("White: 40-60 Minutes/Day", style: TextStyle(color: Colors.white)),
                     SizedBox(height: 10,),
                     Text("Blue: 60+ Minutes/Day", style: TextStyle(color: Colors.blue)),
                   ],),
                 )
                 ],
               
               ),
             ),
           )
        ],),
      ),
    );
  }
}