import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:animated_counter/animated_counter.dart';

class NewGemsPage extends StatefulWidget {

  final int gemsAmount;

  const NewGemsPage({Key? key, required this.gemsAmount}) : super(key: key);

  @override
  State<NewGemsPage> createState() => _NewGemsPageState();
}

class _NewGemsPageState extends State<NewGemsPage> with TickerProviderStateMixin  {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.white,
      body: Container(
        
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50,0,0,0),
                  child: Container(
                    height: 200,
                    child: Image.asset("assets/gems_chest.png")),
                ),
                            SizedBox(height: 50,),
                Container(
                
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("+" + widget.gemsAmount.toString(), style: TextStyle(fontSize: 120, color: Colors.greenAccent)),
                )),

                   Container(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("You earned " + widget.gemsAmount.toString() + " gems!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )),

                   Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("The longer you meditate, the more gems you'll earn", style: TextStyle(fontSize: 14)),
                )),
                SizedBox(height: 50,),
                
                
                GestureDetector(
                  onTap: () {
                   Get.offAll(AppPages());
                  },
                  child: Container(
                    
                    color: Color.fromARGB(255, 16, 77, 127),
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