// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/subscription_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:shimmer/shimmer.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final int STREAK_FREEZE_PRICE = 40;
  final int STREAK_REVIVE_PRICE = 400;
  final int LURE_PRICE = 90;

  // every second, update
  int secondsTillStreakReviveExpires = 0;

  @override
  void initState() {
    super.initState();
    UserController user = Get.find();

    DateTime dayExpires =
        user.user.value.streakLostAndSeenAt.add(const Duration(days: 1));

    secondsTillStreakReviveExpires = dayExpires
        .difference(DateTime.utc(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second))
        .inSeconds;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsTillStreakReviveExpires = dayExpires
            .difference(DateTime.utc(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour,
                DateTime.now().minute,
                DateTime.now().second))
            .inSeconds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    SubscriptionController? subscriptionController;
    NetworkStatusController network = Get.find();

    if (!network.offline.value) {
      if (Get.isRegistered<SubscriptionController>()) {
        // If the controller already exists, retrieve it
        subscriptionController = Get.find<SubscriptionController>();
      } else {
        // If the controller does not exist, create and register it
        subscriptionController = Get.put(SubscriptionController());
      }
    }

    return Obx(
      () => ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Earn  ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                  height: 20, child: Image.asset("assets/sand_dollar.png")),
              const Text(
                " sand dollars",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                " by meditating. ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const Text(
            "Spend them here! ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),

          // Streak Revive
          secondsTillStreakReviveExpires < 0 ||
                  user.user.value.streakValueNeverReset == 0 ||
                  user.user.value.streak != 0
              ? Container()
              : GestureDetector(
                  onTap: () {
                    if (user.user.value.gems >= STREAK_REVIVE_PRICE) {
                      HapticFeedback.lightImpact();

                      user.updateProperty(UserProperty.gems,
                          user.user.value.gems - STREAK_REVIVE_PRICE);
                      // Restore the user's streak
                      user.reviveStreak();
                    } else {
                      //Log the event to AppsFlyer
                      PostHogService appsflyer = Get.find();
                      appsflyer.logEvent(
                          "STREAK_REVIVE_TAPPED", {"purchased": "false"});

                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.greenAccent,
                        key: UniqueKey(),
                        content: const Text(
                            "Earn more sand dollars to purchase this!"),
                      ));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(
                          color: const Color.fromARGB(255, 107, 80, 80),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal:
                                      MediaQuery.of(context).size.width / 70),
                              child: SizedBox(
                                  width: 60,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          child: Image.asset(
                                              "assets/streak_revive.png")),
                                      Opacity(
                                        opacity: 0.8,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.white12,
                                          highlightColor: Colors.white70,
                                          child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              child: Image.asset(
                                                  "assets/streak_revive.png")),
                                        ),
                                      ),
                                    ],
                                  ))),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Streak Revive",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                    width: 200,
                                    child: Text(
                                        "Restore your ${user.user.value.streakValueNeverReset} day streak!")),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Buy for ",
                                      style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                        height: 20,
                                        child: Image.asset(
                                            "assets/sand_dollar.png")),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "$STREAK_REVIVE_PRICE",
                                      style: const TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${secondsTillStreakReviveExpires ~/ (60 * 60)}:${((secondsTillStreakReviveExpires ~/ 60) % 60).toStringAsFixed(0).padLeft(2, '0')}:${(secondsTillStreakReviveExpires % 60).toString().padLeft(2, '0')} LEFT TO BUY",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

          //Streak Freeze
          GestureDetector(
            onTap: () {
              if (user.user.value.gems >= STREAK_FREEZE_PRICE) {
                if (user.user.value.streakFreezes < 3) {
                  //Log the event to AppsFlyer
                  PostHogService posthog = Get.find();
                  posthog
                      .logEvent("STREAK_FREEZE_TAPPED", {"purchased": "true"});

                  logSuccess("Purchasing Streak Freeze!");
                  HapticFeedback.lightImpact();

                  user.updateProperty(UserProperty.gems,
                      user.user.value.gems - STREAK_FREEZE_PRICE);
                  user.updateProperty(UserProperty.streakFreezes,
                      user.user.value.streakFreezes + 1);
                } else {
                  //Log the event to AppsFlyer
                  PostHogService posthog = Get.find();
                  posthog.logEvent(
                      "STREAK_FREEZE_TAPPED", {"purchased": "false, >3"});

                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.greenAccent,
                    key: UniqueKey(),
                    content: const Text(
                        "You can only equip three Streak Freezes at a time!"),
                  ));
                }
              } else {
                //Log the event to AppsFlyer
                PostHogService appsflyer = Get.find();
                appsflyer
                    .logEvent("STREAK_FREEZE_TAPPED", {"purchased": "false"});

                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.greenAccent,
                  key: UniqueKey(),
                  content:
                      const Text("Earn more sand dollars to purchase this!"),
                ));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: user.user.value.streakFreezes > 0
                      ? const Color.fromARGB(255, 46, 48, 59)
                      : Colors.black12,
                  border: Border.all(
                    color: user.user.value.streakFreezes > 0
                        ? const Color.fromARGB(255, 81, 80, 107)
                        : Colors.white24,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: MediaQuery.of(context).size.width / 70),
                        child: SizedBox(
                            width: 60,
                            child: Stack(
                              children: [
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: Image.asset(
                                        "assets/streak_freeze.png")),
                                Opacity(
                                  opacity: 0.8,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.white12,
                                    highlightColor: Colors.white70,
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        child: Image.asset(
                                            "assets/streak_freeze.png")),
                                  ),
                                ),
                              ],
                            ))),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Streak Freeze",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                              width: 200,
                              child: Text(
                                  "Save your streak if you miss a day of meditation.")),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Buy for ",
                                style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                  height: 20,
                                  child: Image.asset("assets/sand_dollar.png")),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "$STREAK_FREEZE_PRICE",
                                style: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${user.user.value.streakFreezes} OUT OF 3 ACTIVE",
                            style: TextStyle(
                                color: user.user.value.streakFreezes > 0
                                    ? Colors.lightBlue
                                    : Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Buy Sand Dollars
          network.offline.value ||
                  subscriptionController == null ||
                  subscriptionController.sandDollarPackage == null
              ? Container()
              : GestureDetector(
                  onTap: () {
                    // RevenueCat purchase 'sand_dollar_purchase' item
                    if (!subscriptionController!.purchasingSandDollars.value) {
                      HapticFeedback.lightImpact();
                      subscriptionController.purchaseSandDollars();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(
                          color: Colors.white24,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal:
                                      MediaQuery.of(context).size.width / 70),
                              child: SizedBox(
                                  width: 70,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          child: Image.asset(
                                              "assets/sand_dollar_chest.png")),
                                      Opacity(
                                        opacity: 0.8,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.white12,
                                          highlightColor: Colors.white70,
                                          child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              child: Image.asset(
                                                  "assets/sand_dollar_chest.png")),
                                        ),
                                      ),
                                    ],
                                  ))),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 15, 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "800 Sand Dollars",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // const SizedBox(
                                //     width: 200,
                                //     child: Text(
                                //         "Save your streak if you miss a day of meditation.")),
                                const SizedBox(
                                  height: 5,
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      Text(
                                        subscriptionController!
                                                .purchasingSandDollars.value
                                            ? "Purchasing..."
                                            : "\$4.99",
                                        style: const TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

          //Lure
        ],
      ),
    );
  }
}
