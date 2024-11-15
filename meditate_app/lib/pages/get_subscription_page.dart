import 'package:flutter/material.dart';
import 'package:foil/foil.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/components/premium_container.dart';
import 'package:meditate_app/components/unlocked_turtle.dart';
import 'package:meditate_app/controllers/subscription_controller.dart';
import 'package:meditate_app/pages/countdown_demo_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

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
    SubscriptionController subscriptionController =
        Get.find<SubscriptionController>();

    return Obx(
      () => Scaffold(
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
                Opacity(
                    opacity: 0.7,
                    child: Container(
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    )),
                Column(
                  children: [
                    Expanded(
                      child: AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: opacity,
                        duration: const Duration(milliseconds: 2000),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 80),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        width: 80, child: PremiumContainer()),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 50),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color:
                                            Colors.white, // Default text color
                                      ),
                                      children: [
                                        const TextSpan(
                                            text: "Premium users are "),
                                        TextSpan(
                                          text: "more likely",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors
                                                  .lightBlueAccent), // Blue color for "more likely"
                                        ),
                                        const TextSpan(
                                            text:
                                                " to make meditation a habit!"),
                                      ],
                                    ),
                                  ),
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
                                              const SizedBox(height: 20),
                                              const Text(
                                                "Unlock Breathwork!",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 10),
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    8, 0, 8, 0),
                                                child: Text(
                                                  "Find peace and balance easier with breathwork for different occasions.",
                                                  style: TextStyle(
                                                      color: Colors.white60,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                    autoPlay: false,
                                                    enableInfiniteScroll: false,
                                                    viewportFraction: 0.5,
                                                    height: 400.0),
                                                items: [
                                                  "Water Sounds",
                                                ].map((i) {
                                                  return Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
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
                                                                          SizedBox(
                                                                        height: MediaQuery.of(context)
                                                                            .size
                                                                            .height,
                                                                        child: CountdownDemoPage(
                                                                            breathwork:
                                                                                true,
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
                                              const SizedBox(height: 20),
                                              const Text(
                                                "Unlock 12 new soundscapes to meditate in!",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 10),
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
                                                      return SizedBox(
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
                                                                          SizedBox(
                                                                        height: MediaQuery.of(context)
                                                                            .size
                                                                            .height,
                                                                        child: CountdownDemoPage(
                                                                            breathwork:
                                                                                false,
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
                                          CarouselSlider(
                                            options: CarouselOptions(
                                                autoPlay: true,
                                                viewportFraction: 0.26,
                                                height: 100.0),
                                            items: [
                                              [21, 1],
                                              [23, 8],
                                              [22, 4],
                                              [21, 2],
                                              [23, 9],
                                              [22, 5],
                                              [21, 18],
                                              [23, 10],
                                              [22, 6],
                                              [21, 4],
                                              [23, 11],
                                              [22, 18],
                                            ].map((i) {
                                              return Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return SizedBox(
                                                      height: 200,
                                                      child: OverflowBox(
                                                        maxWidth: 300,
                                                        maxHeight: 200,
                                                        child: Transform.scale(
                                                            scale: 0.5,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child: SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      2,
                                                                  child: UnlockedTurtle(
                                                                      id: i[0],
                                                                      color: i[
                                                                          1])),
                                                            )),
                                                      ));
                                                },
                                              );
                                            }).toList(),
                                          ),
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Just \$4 / month (US)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "Cancel anytime.",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                                // const SizedBox(height: 20),
                                // const Text(
                                //   "A message from me, the developer 💌 ",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20),
                                //   textAlign: TextAlign.center,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Container(
                                //       decoration: BoxDecoration(
                                //         color: Colors.black12,
                                //         border: Border.all(
                                //           color: const Color.fromARGB(
                                //               64, 255, 255, 255),
                                //           width: 2,
                                //         ),
                                //         borderRadius: BorderRadius.circular(20),
                                //       ),
                                //       child: const Padding(
                                //         padding: EdgeInsets.all(8.0),
                                //         child: Text(
                                //           "I'm one person developing this entire app. \n\n I think gamified meditation has the potential to bring peace and balance to so many people who might not otherwise get into meditation. \n\n That's why I made Shellevate! This app has helped me get through my own dark times. I hope it can be there for you as well.\n\n  I believe in Shellevate and I hope you do too. If you love this app, I'm counting on your support to keep it going! ❤️",
                                //           style: TextStyle(
                                //               fontWeight: FontWeight.bold,
                                //               fontSize: 14),
                                //           textAlign: TextAlign.center,
                                //         ),
                                //       )),
                                // ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 4,
                      height: 2,
                    ),
                    Container(
                      color: Colors.black54,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(1000)),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ElevatedButton(
                                    // add a border
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightBlue,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onPressed: () {
                                      subscriptionController
                                          .buySubscription(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          subscriptionController
                                                      .getPremiumTapped.value ==
                                                  true
                                              ? "Loading..."
                                              : "Get Premium",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.2,
                                child: Foil(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(1000)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ElevatedButton(
                                        // add a border
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        onPressed: () {
                                          subscriptionController
                                              .buySubscription(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              subscriptionController
                                                          .getPremiumTapped
                                                          .value ==
                                                      true
                                                  ? "Loading..."
                                                  : "Get Premium",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.2,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.white10,
                                  highlightColor: Colors.white30,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(1000)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ElevatedButton(
                                        // add a border
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.lightBlue,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        onPressed: () {
                                          subscriptionController
                                              .buySubscription(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              subscriptionController
                                                          .getPremiumTapped
                                                          .value ==
                                                      true
                                                  ? "Loading..."
                                                  : "Get Premium",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text("Get Premium",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
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
                      ),
                    ),
                  ],
                )
              ]))),
    );
  }
}
