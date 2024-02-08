import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/components/unlocked_turtle.dart';
import 'package:meditate_app/pages/countdown_demo_page.dart';
import 'package:meditate_app/pages/select_ambience_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GetSubscriptionPage extends StatefulWidget {
  const GetSubscriptionPage({super.key});

  @override
  State<GetSubscriptionPage> createState() => _GetSubscriptionPageState();
}

class _GetSubscriptionPageState extends State<GetSubscriptionPage> {
  double opacity = 0;
  @override
  void initState() {
    super.initState();

    increaseOpacity();
  }

  Future<void> increaseOpacity() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff87CEEB),
                Color.fromARGB(255, 100, 162, 200),
                Color.fromARGB(255, 25, 142, 238),
                Color.fromARGB(255, 1, 62, 137),
              ],
            )),
            child: Stack(children: [
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
                sizeFactor: 0.03,
                opacity: 40,
                paintingStyle: PaintingStyle.fill,
                strokeWidth: 1,
                shape: BubbleShape.circle,
                colorsOfBubbles: [
                  Colors.white.withAlpha(30),
                ],
              )),
              Column(
                children: [
                  Expanded(
                    child: AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: opacity,
                      duration: const Duration(milliseconds: 2000),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 50),
                                const Text(
                                  "Premium users are more likely to make meditation a habit!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                64, 255, 255, 255),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Unlock whole new soundscapes to meditate in!",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 20),
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                    autoPlay: true,
                                                    viewportFraction: 0.5,
                                                    height: 400.0),
                                                items: [
                                                  "Rain",
                                                  "Jungle",
                                                  "Prehistoric Sea",
                                                ].map((i) {
                                                  return Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                          height: 400,
                                                          child: OverflowBox(
                                                            maxWidth: 300,
                                                            maxHeight: 690,
                                                            child:
                                                                Transform.scale(
                                                                    scale: 0.5,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      child:
                                                                          Container(
                                                                        height: MediaQuery.of(context)
                                                                            .size
                                                                            .height,
                                                                        child: CountdownDemoPage(
                                                                            ambience:
                                                                                i),
                                                                      ),
                                                                    )),
                                                          ));
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ))),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            64, 255, 255, 255),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Find EXCLUSIVE turtles!",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                              height: 160,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  UnlockedTurtle(
                                                      id: 21, color: 1),
                                                  UnlockedTurtle(
                                                      id: 22, color: 4),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              64, 255, 255, 255),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Just \$4 a month! Cancel anytime!",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "A message from me, the developer 💌 ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              64, 255, 255, 255),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "I'm one person developing this entire app. \n\n I think gameified meditation has the potential to bring peace and balance to so many people who might not otherwise get into meditation. \n\n That's why I made Shellevate! This app has helped me get through my own dark times. I hope it can be there for you as well.\n\n  I believe in Shellevate and I hope you do too. If you love this app, I'm counting on your support to keep it going! ❤️",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 4,
                    height: 2,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    // color is teal
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                    ),
                    onPressed: () {
                      //TODO: actually buy subscription
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Get Premium",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () => {Get.offAll(const AppPages())},
                      child: const Text("No Thanks",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14))),
                  const SizedBox(
                    height: 50,
                  )
                ],
              )
            ])));
  }
}
