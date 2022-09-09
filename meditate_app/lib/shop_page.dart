import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/streak_count_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = true;
      
    return ListView(children: [
      GestureDetector(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Earn more gems to purchase this!"),
          ));
        },
        child: Padding(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 60,
                  child: Image.asset("assets/streak_freeze.png")),
              ),
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                  Text("Streak Freeze", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(height: 5,),
                  Container(
                    width: 200,
                    child: Text("Save your streak if you miss a day of meditation.")),
                  
                  SizedBox(height: 10,),
                  
                  
                  Row(
                    children: [
                      Container(
                        height: 20,
                        child: Image.asset("assets/gem_icon.png")),
                        SizedBox(width: 5,),
                      Text("70",style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),),
                    ],
                  ),
      
                   SizedBox(height: 10,),
                 
                   Text("0/2 ACTIVE",style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
             
                ],),
              )
              ],
            
            ),
          ),
        ),
      )
    ],);
  }
}