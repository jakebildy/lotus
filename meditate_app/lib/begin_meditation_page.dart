import 'package:audioplayers/audioplayers.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/countdown_page.dart';

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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(height: 200),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,285),
                  child: Container(
                    height: 150,
                    child: Image.asset("assets/bonsai_circle.png")),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,100,0,0),
                  child: Container(
                    height: 400,
                    width: 240,
                    child: DurationPicker(
                      duration: _duration,
                      baseUnit: BaseUnit.minute,
                      onChange: (val) {
                    setState(() => _duration = val);
                      },
                      snapToMins: 5.0,
                    ),
                  ),
                ),
              ],
            ),
         
            _duration == NO_TIME ? 
            Container(
              height: 50,
              child: const Text("How long will you meditate for?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))) :
            GestureDetector(
              onTap: (() {
                HapticFeedback.heavyImpact();
                AudioPlayer().play(AssetSource('sounds/old-gong.m4a'));
                Get.to(CountdownPage(time: _duration), transition: Transition.downToUp);
              }),
              child: Hero(
                tag: "PLAY_BUTTON",
                child: const Icon(Icons.play_arrow, size: 50,)))
          ],
        ),
      ),
    );
  }
}