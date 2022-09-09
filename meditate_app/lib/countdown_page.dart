import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/streak_count_page.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key, required this.time}) : super(key: key);

  final Duration time;

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> with TickerProviderStateMixin {
  final CountDownController _controller = CountDownController();
  bool isPaused = false;
  bool isEnded = false;

  late AnimationController _playPauseController;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
     _playPauseController =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _playPauseController.forward();

    SaveController saveController = Get.find();

    audioPlayer = new AudioPlayer();
    if (saveController.ambienceOn.value) {
        audioPlayer.setReleaseMode(ReleaseMode.loop);
        audioPlayer.setVolume(1);
        audioPlayer.play(AssetSource('sounds/water_sounds.wav'));
    }

    super.initState();
  }

  // Dispose the controller
  @override
  void dispose() {
    _playPauseController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
         var brightness = SchedulerBinding.instance.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      
    return Stack(
              children: [
          Container(
  width: MediaQuery.of(context).size.width,
  height:  MediaQuery.of(context).size.height,
  decoration: BoxDecoration(
    // image: DecorationImage(
    //   fit: BoxFit.cover,
    //   image: AssetImage("assets/water_vibes.webp"),
    // ),
  ),
),

        Scaffold(
          
        // backgroundColor: isDarkMode ? Colors.black : Color(0xff87CEEB),
          body: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff87CEEB),
                                  Color(0xff87CEEB),
                                  
                    Color.fromARGB(255, 25,178,238),
                    Color.fromARGB(255, 183, 163, 211),
                               Color.fromARGB(255, 247, 190, 221),
                     Color.fromARGB(255, 247, 244, 186),
                     Color(0xff87CEEB),
                       Color.fromARGB(255, 25,178,238),
                       
                  ],
                )),
            child: Stack(
              children: [
                  // Padding(
                  //       padding: EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height/2,0,0),
                  //       child: Container(height: 500, color: Color(0xff8006994), width: MediaQuery.of(context).size.width,),
                  //     ),
                  WaveWidget(
                              config: CustomConfig(
                                colors: [
                  
                                  Color(0x338006994),
                                  Color(0x3300BBF9),
                                ],
                                durations: [
                                  10000,
                                  12000,
                                  
                                ],
                                heightPercentages: [
                                  0.54,
                                  0.55,
                    
                                ],
                              ),
                              backgroundColor: Colors.transparent,
                              size: Size(double.infinity, double.infinity),
                              waveAmplitude: 0,
                            ),
                          
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height - 200,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,0,80),
                            child: Image.asset("assets/lotus2.png"),
                          ),
                          Padding(
                               padding: const EdgeInsets.fromLTRB(0,0,0,400),
                            child: CircularCountDownTimer(
                              // Countdown duration in Seconds.
                              duration: widget.time.inSeconds,
                              initialDuration: 0,
                              controller: _controller,
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 2,
                              ringColor: Colors.black12,
                              ringGradient: null,
                              fillColor: Colors.white,
                              fillGradient: null,
                              backgroundColor: Colors.black38,
                              backgroundGradient: null,
                              strokeWidth: 10.0,
                              strokeCap: StrokeCap.round,
                              textStyle: TextStyle(
                                fontSize: widget.time > const Duration (hours: 1) ? 30 : 50.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              
                              ),
                            
                              // Format for the Countdown Text.
                              textFormat: widget.time > const Duration (hours: 1) ? CountdownTextFormat.HH_MM_SS : CountdownTextFormat.MM_SS,
                              isReverse: true,
                              isReverseAnimation: true,
                              isTimerTextShown: true,
                            
                              // Handles the timer start.
                              autoStart: true,
                            
                              // This Callback will execute when the Countdown Starts.
                              onStart: () {
                                // Here, do whatever you want
                                debugPrint('Countdown Started');
                                  isEnded = false;
                              },
                            
                              // This Callback will execute when the Countdown Ends.
                              onComplete: () {
                                // Here, do whatever you want
                                  isEnded = true;
                                debugPrint('Countdown Ended');
                                audioPlayer.dispose();
                                AudioPlayer().play(AssetSource('sounds/tibetan_chime.wav'));
                                SaveController saveController = Get.find();
                            
                                //Save the streak day
                                DateTime now = new DateTime.now();
                                DateTime date = new DateTime(now.year, now.month, now.day);
                             
                                String streakValue = saveController.getValue("streak");
                                if (streakValue == "") {
                                  print("Streak value is empty.");
                                  saveController.updateStreak(1);
                                } else {
                                  int numDays = DateTime.parse(saveController.getValue("last_meditated")).difference(date).inDays.abs();
                                  if (numDays == 1) {
                                    saveController.updateStreak(int.parse(streakValue) + 1);
                                     print("Streak value is updated to ${int.parse(streakValue) + 1}.");
                                     saveController.updateGems(saveController.gems.value + 5);
                                  } else if (numDays > 1) {
                                      saveController.updateStreak(1);
                                       print("Streak value is set to 1. NumDays was > 1.");
                                  } else {
                                    print("You already meditated today. Not updating streak!");
                                  }
                                }
                            
                                //update total meditation amount
                                String totalAmount = saveController.getValue("total_minutes");
                                if (totalAmount == "") { 
                                  saveController.updateTotalAmount(widget.time.inMinutes, widget.time.inMinutes);
                                } else {
                                   saveController.updateTotalAmount(int.parse(totalAmount) + widget.time.inMinutes, widget.time.inMinutes);
                                }
                                 saveController.updateGems(saveController.gems.value + widget.time.inMinutes);
                            
                                print("saving last_meditated to ${date.toIso8601String()}");
                                saveController.saveValue("last_meditated", date.toIso8601String());
                                
                                Get.to(StreakCountPage(gemsAmount: widget.time.inMinutes + 5,));
                              },
                            
                              // This Callback will execute when the Countdown Changes.
                              onChange: (String timeStamp) {
                                // Here, do whatever you want
                               // debugPrint('Countdown Changed $timeStamp');
                              },
                            ),
                          ),


                           Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,0,100),
                             child: IconButton(
                      iconSize: 50,
                      onPressed: () {
                        if (isEnded) {
                             print("Restarting countdown...");
                             HapticFeedback.mediumImpact();
                          _playPauseController.forward();
                          _controller.restart(duration: widget.time.inSeconds);
                        } 
                        else if (isPaused) {
                              print("Resuming countdown...");
                              _controller.resume();
                              audioPlayer.resume();
                              HapticFeedback.mediumImpact();
                              _playPauseController.forward();
                              isPaused = false;
                        } else {
                          print("Pausing countdown...");
                          _controller.pause();
                          audioPlayer.pause();
                          HapticFeedback.mediumImpact();
                          _playPauseController.reverse();
                          isPaused = true;
                        }
                         setState(() {});
                      }, 
                      // icon: Icon(isPaused || isEnded ? Icons.play_arrow : 
                      //             Icons.pause)
                      icon:  Hero(
                        tag: "PLAY_BUTTON",
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: _playPauseController,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                           ),
                    Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,30),
                      child: isPaused ? Padding(
                        padding: const EdgeInsets.fromLTRB(0,10,0,20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            color: Color.fromARGB(255, 16, 77, 127),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10),
                              child: Text("End Session", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                            )),
                        ),
                      ) : Container(),
                    )
                        ],
                      ),
                    ),

                    
                  ],
                ),
              ],
            ),
          ),
         
        ),
      ],
    );
  }

}