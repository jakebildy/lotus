import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/countdown_page.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'components/duration_picker.dart';

class BeginMeditationPage extends StatefulWidget {
  const BeginMeditationPage({Key? key}) : super(key: key);

  @override
  State<BeginMeditationPage> createState() => _BeginMeditationPageState();
}

class _BeginMeditationPageState extends State<BeginMeditationPage> {
  
  Duration _duration = const Duration(hours: 0, minutes: 5);
  Duration NO_TIME = const Duration(hours: 0, minutes: 0);
      
  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();

    return Obx(
      () =>  Scaffold(
        backgroundColor:Color.fromARGB(255, 47, 111, 129),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
                            Padding(
                        padding: EdgeInsets.all(0),
                      //  padding: const EdgeInsets.fromLTRB(20,20,20,38),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: 380,
                            
                            child: Image.asset("assets/ocean_background.jpeg", fit: BoxFit.fill,)),
                        ),
                    ),
            
                            
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
    
                  
      
                  Stack(
                    alignment: Alignment.center,
                    children: [
    
             
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,38),
                        child: Container(
                          height: 360,
                          child: Image.asset("assets/turtle_timer.png")),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        child: Container(
                          height: 400,
                          width: 240,
                          child: DurationPicker(
                            duration: _duration,
                            baseUnit: BaseUnit.minute,
                            
                            onChange: (val) {
                              if (_duration != val) {
                               HapticFeedback.lightImpact();
                              }
                                setState(() => _duration = val);
                            },
                            snapToMins: 5.0,
                          ),
                        ),
                      ),
    
                        IgnorePointer(
                          child: Padding(
                          padding: const EdgeInsets.fromLTRB(3,10,0,0),
                          child: Opacity(
                            opacity: 0.15,
                            child: Container(
                              height: 190,
                              width: 190,
                              child: Image.asset("assets/turtle_lines.png", fit: BoxFit.fill,)),
                          ),
                                            ),
                        ),
                    ],
                  ),
               
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:30.0),
                    child: _duration == NO_TIME || _duration < const Duration(minutes:1) ? 
                    Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: const Text("Meditate for at least five minutes to build a habit!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,),
                      )) :
                    GestureDetector(
                      onTap: (() {
                        HapticFeedback.heavyImpact();
                        AudioPlayer().play(AssetSource('sounds/old-gong.m4a'));
                        Get.to(CountdownPage(time: _duration), transition: Transition.circularReveal, duration: Duration(seconds: 1));
                      }),
                      child: Hero(
                        tag: "PLAY_BUTTON",
                        child: const Icon(Icons.play_arrow, size: 50, color: Colors.white,))),
                  ),

                    GestureDetector(
                      onTap: (() {
                        saveController.updateAmbience();
                      }),
                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                           Text(saveController.ambienceOn.value ? "Ambience: ON" : "Ambience: OFF",
                          style: TextStyle( fontSize: 13,  color: Colors.white70, fontWeight: FontWeight.bold ),),
                          Icon(saveController.ambienceOn.value ? Icons.music_note : Icons.music_off, size: 35,),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}