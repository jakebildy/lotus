import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/subscription_controller.dart';
import 'package:meditate_app/pages/get_subscription/pricing_offer.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:shimmer/shimmer.dart';

class OneTimeOfferPage extends StatelessWidget {
  const OneTimeOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    SubscriptionController subscriptionController = Get.find();
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
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
              Opacity(
                  opacity: 0.9,
                  child: Container(
                    color: Colors.black54,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  )),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.offAll(const AppPages());
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white30,
                            )),
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        //   child: Container(
                        //       width: 80, child: PremiumContainer()),
                        // ),
                      ],
                    ),
                    Image.asset("assets/clock.webp", height: 80),
                    const Text(
                      "Your one-time offer",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      "80% OFF FOREVER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          // gradient color of green like button
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 4, 238, 0),
                                Color.fromARGB(255, 3, 255, 112),
                              ],
                            ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
                      // color: Color.fromARGB(255, 4, 238, 0)),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: PricingWidgetOffer(),
                    ),
                    const Text(
                        "Once you close your one-time offer, it's gone!"),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        PostHogService posthog = Get.find();
                        posthog.logEvent("OFFER_TAPPED", {});
                        subscriptionController.buySubscriptionDiscount(context);
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
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corner
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                        subscriptionController
                                                    .getPremiumTapped.value ==
                                                true
                                            ? "Loading..."
                                            : "Continue",
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 5),
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
                                                      : "Continue",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            20), // Rounded corner
                                        border: Border.all(
                                          color: Colors.transparent,
                                          width: 0,
                                        ),
                                      )))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ])),
      ),
    );
  }
}
