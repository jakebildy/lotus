import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/shake_widget.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/new_gems_page.dart';
import 'package:meditate_app/services/appsflyer_service.dart';

class EggCard extends StatelessWidget {
  final int index;

  EggCard({Key? key, required this.index}) : super(key: key);

  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  Widget build(BuildContext context) {
    SaveController save = Get.find();

    return GestureDetector(
      onTap: () {
        shakeKey.currentState?.shake();
        AudioPlayer egg = new AudioPlayer();
        egg.setVolume(10.0);
        egg.play(AssetSource('audio/egg_crack.wav'));
        egg.dispose();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            key: UniqueKey(),
            backgroundColor: Colors.greenAccent,
            content: Text(
                index == 0
                    ? "Meditate ${(3 - save.hatchProgressEggOne.value).toString()} more day${(3 - save.hatchProgressEggOne.value) > 1 ? "s" : ""} to hatch this egg!"
                    : "Meditate 3 days to hatch this egg!",
                style: TextStyle(fontWeight: FontWeight.bold))));

        //Log the event to AppsFlyer
        AppsflyerService appsflyer = Get.find();
        appsflyer.logEvent("EGG_TAPPED",
            {"more_days": (3 - save.hatchProgressEggOne.value).toString()});
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ShakeWidget(
                  // 4. pass the GlobalKey as an argument
                  key: shakeKey,
                  // 5. configure the animation parameters
                  shakeCount: 3,
                  shakeOffset: 10,
                  shakeDuration: Duration(milliseconds: 500),
                  // 6. Add the child widget that will be animated
                  child: Image.asset(
                    save.hatchProgressEggOne.value == 1 && index == 0
                        ? "assets/egg_crack_1.png"
                        : save.hatchProgressEggOne.value == 2 && index == 0
                            ? "assets/egg_crack_2.png"
                            : "assets/egg.png",
                    height: 60,
                  )),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => Stack(
                  children: [
                    Container(
                      color: Colors.black26,
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      height: 4,
                    ),
                    save.hatchProgressEggOne.value != 0 && index == 0
                        ? Container(
                            color: Colors.greenAccent,
                            width: save.hatchProgressEggOne.value == 0
                                ? 0
                                : save.hatchProgressEggOne.value == 1
                                    ? 30
                                    : 60,
                            height: 4,
                          )
                        : Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
