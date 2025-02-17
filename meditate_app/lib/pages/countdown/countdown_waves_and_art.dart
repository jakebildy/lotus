import 'package:flutter/material.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/util/ambiences.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class CountdownWavesAndArt extends StatelessWidget {
  final String ambience;
  const CountdownWavesAndArt({super.key, required this.ambience});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WaveWidget(
          config: CustomConfig(
            colors: [
              const Color.fromRGBO(0, 105, 147, 0.22),
              const Color(0x3300BBF9),
            ],
            durations: [
              10000,
              12000,
            ],
            heightPercentages: MediaQuery.of(context).size.height < 670
                ? [
                    0.44,
                    0.45,
                  ]
                : [
                    0.54,
                    0.55,
                  ],
          ),
          backgroundColor: Colors.transparent,
          size: const Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
        AMBIENCES.where((element) => element.name == ambience).first.setting ==
                "Night"
            ? Opacity(
                opacity: 0.2,
                child: Image.asset(
                  "assets/stars.jpg",
                  height: MediaQuery.of(context).size.height < 670 ? 400 : 500,
                  fit: BoxFit.cover,
                ),
              )
            : Container(),
        AMBIENCES.where((element) => element.name == ambience).first.setting ==
                "Jungle"
            ? Image.asset(
                "assets/jungle_top.png",
                height: 300,
                fit: BoxFit.cover,
              )
            : Container(),
        Center(
          child: Stack(alignment: Alignment.bottomCenter, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 60,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
              child: Image.asset("assets/lotus2.png"),
            ),
          ]),
        ),
        AMBIENCES.where((element) => element.name == ambience).first.setting ==
                "Rain"
            ? Opacity(
                opacity: 0.5,
                child: Image.asset(
                  "assets/images/rainy_overlay.gif",
                  height: 1000,
                  fit: BoxFit.cover,
                ),
              )
            : Container(),
        AMBIENCES.where((element) => element.name == ambience).first.setting ==
                "Underwater"
            ? Stack(
                children: [
                  Image.asset(
                    "assets/ocean_background.jpeg",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      "assets/images/game/water_2.gif",
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                      child: FloatingBubbles.alwaysRepeating(
                    noOfBubbles: 20,
                    colorsOfBubbles: [
                      Colors.white.withAlpha(30),
                    ],
                    sizeFactor: 0.03,
                    opacity: 70,
                    paintingStyle: PaintingStyle.fill,
                    strokeWidth: 1,
                    shape: BubbleShape
                        .circle, // circle is the default. No need to explicitly mention if its a circle.
                  )),
                ],
              )
            : Container(),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AMBIENCES
                            .where((element) => element.name == ambience)
                            .first
                            .setting ==
                        "Jungle" ||
                    AMBIENCES
                            .where((element) => element.name == ambience)
                            .first
                            .setting ==
                        "Forest"
                ? Image.asset(
                    "assets/jungle_bottom.png",
                    height: 230,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}
