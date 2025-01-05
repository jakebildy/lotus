import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/subscription_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/countdown/countdown_box_decoration.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:meditate_app/pages/get_subscription/build_table_row.dart';
import 'package:meditate_app/pages/get_subscription/feature_checkbox.dart';
import 'package:meditate_app/pages/get_subscription/pricing.dart';
import 'package:meditate_app/pages/get_subscription/review.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class GetSubscriptionPage extends StatefulWidget {
  const GetSubscriptionPage({super.key});

  @override
  State<GetSubscriptionPage> createState() => _GetSubscriptionPageState();
}

class _GetSubscriptionPageState extends State<GetSubscriptionPage> {
  double opacity = 1;
  @override
  void initState() {
    super.initState();

    increaseOpacity();
  }

  Future<void> increaseOpacity() async {
    await Future.delayed(const Duration(milliseconds: 20));
    setState(() {
      opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionController subscriptionController =
        Get.find<SubscriptionController>();
    UserController userController = Get.find<UserController>();

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
                  opacity: 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    //  padding: const EdgeInsets.fromLTRB(20,20,20,38),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/ocean_background.jpeg",
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
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
                        child: SingleChildScrollView(
                          // not able to scroll above the top of the screen
                          physics: const ClampingScrollPhysics(),
                          child: Center(
                            child: Stack(
                              children: [
                                Container(
                                  height: 430,
                                  width: MediaQuery.of(context).size.width,
                                  decoration:
                                      getBoxDecorationForAmbience("Night"),
                                ),
                                Opacity(
                                    opacity: 0.9,
                                    child: Container(
                                      color: Colors.black54,
                                      height: 2150,
                                      width: MediaQuery.of(context).size.width,
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 100, 0, 0),
                                  child: SizedBox(
                                    height: 330,
                                    child: WaveWidget(
                                      config: CustomConfig(
                                        colors: [
                                          const Color.fromRGBO(
                                              0, 105, 147, 0.22),
                                          const Color(0x3300BBF9),
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
                                      size: const Size(
                                          double.infinity, double.infinity),
                                      waveAmplitude: 0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 150, 0, 0),
                                  child: Image.asset("assets/lotus2.png"),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 40),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Get.offAll(const AppPages());
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.grey,
                                            )),
                                        // Padding(
                                        //   padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        //   child: Container(
                                        //       width: 80, child: PremiumContainer()),
                                        // ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Colors
                                                .white, // Default text color
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Free",

                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  color: Color.fromARGB(
                                                      255,
                                                      95,
                                                      220,
                                                      255)), // Blue color for "more likely"
                                            ),
                                            TextSpan(text: " full access to "),
                                            TextSpan(
                                                text:
                                                    "breathwork and soundscapes"),
                                            TextSpan(
                                                text:
                                                    " to help you achieve your meditation goal "),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 240),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8.0, 0, 8),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  0, 119, 153, 255),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    64, 255, 255, 255),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  //Pricing
                                                  const PricingWidget(),
                                                  const SizedBox(height: 16),
                                                  //Features
                                                  Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // this will take the minimum space required by the children
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      FeatureCheckbox(),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start, // this will take the minimum space required by the children
                                                        children: [
                                                          Text(
                                                            "Calm down easier with breathwork",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                100,
                                                            child: Text(
                                                              "Easy to follow along breathing exercises for different occasions",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 18,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min, //
                                                    children: [
                                                      FeatureCheckbox(),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start, // this will take the minimum space required by the children
                                                        children: [
                                                          Text(
                                                            "Personalize your meditations",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                100,
                                                            child: Text(
                                                              "12 new soundscapes to meditate in, from rainy days to deep in the jungle",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 18,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min, //
                                                    children: [
                                                      FeatureCheckbox(),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start, // this will take the minimum space required by the children
                                                        children: [
                                                          Text(
                                                            "Fall asleep faster",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                100,
                                                            child: Text(
                                                              "Fall asleep faster with our sleep breathing exercise",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 50),
                                                  const Text(
                                                      "What our users say",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),

                                                  CarouselSlider(
                                                    options: CarouselOptions(
                                                      autoPlay: false,
                                                      enableInfiniteScroll:
                                                          true,
                                                      viewportFraction: 0.8,
                                                      height: 330.0,
                                                    ),
                                                    items: [
                                                      {
                                                        "name": "DORIANRL",
                                                        "review":
                                                            "Shellevate is an app I recommend to all my friends and family, and anyone who has wanted to step away from the constant noise of life but doesn’t know where to start. The app makes meditation into a fun game where you can build your daily streak, interact with friends, and grow your collection of turtles!"
                                                      },
                                                      {
                                                        "name": "MIZUKI112",
                                                        "review":
                                                            "I’ve always wanted to meditate consistently but would always find myself forgetting one day and then not continuing . I used to use insight timer to keep streaks for meditating but once I lost my streak I would not be able to regain it , which was really de-incentivizing for me. The fact that this app provides streak freezes and the incentive that you can hatch and collect cute turtles is really encouraging to me — the UI is so pretty and I am really grateful for this app ! It is so unique and exactly what I need :-)"
                                                      },
                                                      {
                                                        "name": "DUKE",
                                                        "review":
                                                            "I love this app! The social aspect is really fun, I like adding my friends and seeing their progress."
                                                      }
                                                    ].map((i) {
                                                      return Builder(
                                                        builder: (BuildContext
                                                            context) {
                                                          return ReviewCard(
                                                              name: i["name"]!,
                                                              review:
                                                                  i["review"]!);
                                                        },
                                                      );
                                                    }).toList(),
                                                  ),

                                                  const SizedBox(height: 100),
                                                  const Text(
                                                    "Make Meditation a Habit with Premium",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Table(
                                                    border: TableBorder.all(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.grey),
                                                    columnWidths: const {
                                                      0: FlexColumnWidth(
                                                          2), // Feature column
                                                      1: FlexColumnWidth(
                                                          1), // Free column
                                                      2: FlexColumnWidth(
                                                          1), // Premium column
                                                    },
                                                    children: [
                                                      TableRow(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: const [
                                                                Text("🪷",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            30)),
                                                                Text(
                                                                  "Features",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: const [
                                                                Text("🤔",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            30)),
                                                                Text(
                                                                  "Basic",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors
                                                                  .white12,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                children: const [
                                                                  Text("🌟",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30)),
                                                                  Text(
                                                                    "Premium",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      buildTableRow(
                                                          "Offline Access",
                                                          "✅",
                                                          "✅",
                                                          0),
                                                      buildTableRow(
                                                          "Basic Meditations",
                                                          "✅",
                                                          "✅",
                                                          1),
                                                      buildTableRow(
                                                          "Breathwork",
                                                          "❌",
                                                          "✅",
                                                          2),
                                                      buildTableRow(
                                                          "Diverse Soundscapes",
                                                          "❌",
                                                          "✅",
                                                          3),
                                                      buildTableRow(
                                                          "Sleep Breathing Exercise",
                                                          "❌",
                                                          "✅",
                                                          4),
                                                      buildTableRow(
                                                          "Exclusive Turtles",
                                                          "❌",
                                                          "✅",
                                                          5),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 100),
                                                  const SizedBox(height: 20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: RichText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      text: const TextSpan(
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24,
                                                          color: Colors
                                                              .white, // Default text color
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  "Premium users are "),
                                                          TextSpan(
                                                            text: "more likely",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color: Colors
                                                                    .lightBlueAccent), // Blue color for "more likely"
                                                          ),
                                                          TextSpan(
                                                              text:
                                                                  " to make meditation a habit!"),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      "Try it free for 7 days, then just",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const PricingWidget(),
                                                  Text(
                                                      "No commitment. Cancel anytime.",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    height: 50,
                                                  )
                                                ],
                                              ),
                                            ))),
                                  ],
                                ),
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
                            height: 4,
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              PostHogService posthog = Get.find();
                              posthog.logEvent("START_TRIAL_TAPPED", {});
                              subscriptionController.buySubscription(context);
                            },
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.green, // Lighter shade of purple
                                        Colors.teal, // Darker shade of purple
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        20), // Rounded corner
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              subscriptionController
                                                          .getPremiumTapped
                                                          .value ==
                                                      true
                                                  ? "Loading..."
                                                  : "Start your free trial week",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Opacity(
                                    opacity: 0.8,
                                    child: Shimmer.fromColors(
                                        baseColor: Colors.white10,
                                        highlightColor: Colors.white30,
                                        child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 10, 20, 5),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        subscriptionController
                                                                    .getPremiumTapped
                                                                    .value ==
                                                                true
                                                            ? "Loading..."
                                                            : "Start your free trial week",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // Rounded corner
                                              border: Border.all(
                                                color: Colors.transparent,
                                                width: 0,
                                              ),
                                            )))),
                              ],
                            ),
                          ),
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
