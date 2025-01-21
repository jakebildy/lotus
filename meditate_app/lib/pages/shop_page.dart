// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/egg_controller.dart';
import 'package:meditate_app/components/turtle_image.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/subscription_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/pages/new_egg_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';
import 'package:shimmer/shimmer.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
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

    List<List<int>> turtleOptions = availableTurtles(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));

    return Obx(() => ListView(
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
                        PostHogService posthog = Get.find();
                        posthog.logEvent(
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
            const StreakFreeze(),

            const DividerWithText(text: "OTHER ITEMS"),
            Container(
              height: 200,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
                padding: const EdgeInsets.all(8.0),
                children: [
                  itemPackage(context, "Lucky Egg", "200", "assets/egg.png"),
                  itemPackage(context, "XP Boost", "60", "assets/xp_boost.png"),
                ],
              ),
            ),
            // Buy Sand Dollars
            // network.offline.value ||
            //         subscriptionController == null ||
            //         subscriptionController.sandDollarPackage == null
            //     ? Container()
            //     : GestureDetector(
            //         onTap: () {
            //           // RevenueCat purchase 'sand_dollar_purchase' item
            //           if (!subscriptionController!.purchasingSandDollars.value) {
            //             HapticFeedback.lightImpact();
            //             subscriptionController.purchaseSandDollars();
            //           }
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Container(
            //             // height: 100,
            //             decoration: BoxDecoration(
            //               color: Colors.black12,
            //               border: Border.all(
            //                 color: Colors.white24,
            //                 width: 2,
            //               ),
            //               borderRadius: BorderRadius.circular(20),
            //             ),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Padding(
            //                     padding: EdgeInsets.symmetric(
            //                         vertical: 15.0,
            //                         horizontal:
            //                             MediaQuery.of(context).size.width / 70),
            //                     child: SizedBox(
            //                         child: Stack(
            //                       children: [
            //                         SizedBox(
            //                             child: Image.asset(
            //                                 "assets/sand_dollar_chest.png")),
            //                         Opacity(
            //                           opacity: 0.8,
            //                           child: Shimmer.fromColors(
            //                             baseColor: Colors.white12,
            //                             highlightColor: Colors.white70,
            //                             child: SizedBox(
            //                                 child: Image.asset(
            //                                     "assets/sand_dollar_chest.png")),
            //                           ),
            //                         ),
            //                       ],
            //                     ))),
            //                 // SizedBox(
            //                 //   width: 10,
            //                 // ),
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(0, 0, 15, 0.0),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       const SizedBox(
            //                         height: 5,
            //                       ),
            //                       const Text(
            //                         "800 Sand Dollars",
            //                         style: TextStyle(
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 16),
            //                       ),
            //                       const SizedBox(
            //                         height: 5,
            //                       ),
            //                       // const SizedBox(
            //                       //     width: 200,
            //                       //     child: Text(
            //                       //         "Save your streak if you miss a day of meditation.")),
            //                       const SizedBox(
            //                         height: 5,
            //                       ),
            //                       Obx(
            //                         () => Row(
            //                           mainAxisSize: MainAxisSize.min,
            //                           children: [
            //                             Container(
            //                               decoration: BoxDecoration(
            //                                 color:
            //                                     Color.fromARGB(255, 54, 96, 164),
            //                                 borderRadius:
            //                                     BorderRadius.circular(4),
            //                               ),
            //                               child: Padding(
            //                                 padding: const EdgeInsets.all(5.0),
            //                                 child: Text(
            //                                   subscriptionController!
            //                                           .purchasingSandDollars.value
            //                                       ? "Loading..."
            //                                       : "\$4.99",
            //                                   style: const TextStyle(
            //                                       color: Color.fromARGB(
            //                                           255, 213, 236, 255),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       const SizedBox(
            //                         height: 0,
            //                       ),
            //                     ],
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            const DividerWithText(text: "SAND DOLLARS"),
            Container(
              height: 200,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
                padding: const EdgeInsets.all(8.0),
                children: [
                  sandDollarPackage(
                      context,
                      "100\nSand Dollars",
                      subscriptionController?.sandDollars100Package
                              ?.storeProduct.priceString ??
                          "\$0.99",
                      "assets/sand_dollar_min.png"),
                  sandDollarPackage(
                      context,
                      "800\nSand Dollars",
                      subscriptionController?.sandDollars800Package
                              ?.storeProduct.priceString ??
                          "\$4.99",
                      "assets/sand_dollar_chest.png"),
                  sandDollarPackage(
                      context,
                      "14,500\nSand Dollars",
                      subscriptionController?.sandDollars14500Package
                              ?.storeProduct.priceString ??
                          "\$69.99",
                      "assets/sand_dollar_max.png"),
                ],
              ),
            ),

            // Daily Turtles
            const DividerWithText(text: "TURTLES AVAILABLE TODAY"),

            // pick 10 random turtles
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(10, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(
                          color: Colors.white24,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TurtleImage(
                                    id: turtleOptions[index][0],
                                    color: turtleOptions[index][1],
                                  )),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      TURTLE_COLORS_NAME[turtleOptions[index]
                                              [1]] +
                                          " " +
                                          TURTLES[turtleOptions[index][0]]
                                              .name
                                              .replaceAll(" Turtle", ""),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    rarityReadable(
                                        TURTLES[turtleOptions[index][0]]
                                            .rarity),
                                    style: TextStyle(
                                      color: rarityColor(
                                          TURTLES[turtleOptions[index][0]]
                                              .rarity),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 47, 59, 78),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              height: 20,
                                              child: Image.asset(
                                                  "assets/sand_dollar.png")),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "${calculateTurtlePrice(turtleOptions[index][0], turtleOptions[index][1])}",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 213, 236, 255),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ))),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ));
  }
}

class StreakFreeze extends StatelessWidget {
  const StreakFreeze({super.key});

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (user.user.value.gems >= STREAK_FREEZE_PRICE) {
            if (user.user.value.streakFreezes < 3) {
              //Log the event to AppsFlyer
              PostHogService posthog = Get.find();
              posthog.logEvent("STREAK_FREEZE_TAPPED", {"purchased": "true"});

              logSuccess("Purchasing Streak Freeze!");
              HapticFeedback.lightImpact();

              user.updateProperty(UserProperty.gems,
                  user.user.value.gems - STREAK_FREEZE_PRICE);
              user.updateProperty(UserProperty.streakFreezes,
                  user.user.value.streakFreezes + 1);
              if (user.user.value.hasTriedStreakFreeze == false) {
                user.updateProperty(UserProperty.hasTriedStreakFreeze, true);
              }
            } else {
              //Log the event to AppsFlyer
              PostHogService posthog = Get.find();
              posthog
                  .logEvent("STREAK_FREEZE_TAPPED", {"purchased": "false, >3"});

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
            PostHogService posthog = Get.find();
            posthog.logEvent("STREAK_FREEZE_TAPPED", {"purchased": "false"});

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.greenAccent,
              key: UniqueKey(),
              content: const Text("Earn more sand dollars to purchase this!"),
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 160,
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
                SizedBox(
                  width: 10,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: MediaQuery.of(context).size.width / 70),
                    child: SizedBox(
                        width: 60,
                        child: Stack(
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 4,
                                child: Image.asset("assets/streak_freeze.png")),
                            Opacity(
                              opacity: 0.8,
                              child: Shimmer.fromColors(
                                baseColor: Colors.white12,
                                highlightColor: Colors.white70,
                                child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
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
                          Container(
                            decoration: BoxDecoration(
                              color: user.user.value.streakFreezes > 0
                                  ? const Color.fromARGB(255, 81, 80, 107)
                                  : const Color.fromARGB(255, 47, 59, 78),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  SizedBox(
                                      height: 16,
                                      child: Image.asset(
                                          "assets/sand_dollar.png")),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    STREAK_FREEZE_PRICE.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 213, 236, 255),
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      user.user.value.streakFreezes == 0
                          ? Text(
                              "${user.user.value.streakFreezes} ACTIVE",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
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
    );
  }
}

Widget sandDollarPackage(
    BuildContext context, String title, String price, String assetPath) {
  SubscriptionController subscriptionController =
      Get.find<SubscriptionController>();
  return GestureDetector(
    onTap: () {
      // RevenueCat purchase logic here
      if (title == "100\nSand Dollars") {
        if (!subscriptionController!.purchasing100SandDollars.value) {
          HapticFeedback.lightImpact();
          subscriptionController.purchase100SandDollars();
        }
      } else if (title == "800\nSand Dollars") {
        if (!subscriptionController!.purchasing800SandDollars.value) {
          HapticFeedback.lightImpact();
          subscriptionController.purchase800SandDollars();
        }
      } else if (title == "14,500\nSand Dollars") {
        if (!subscriptionController!.purchasing14500SandDollars.value) {
          HapticFeedback.lightImpact();
          subscriptionController.purchase14500SandDollars();
        }
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(
          color: Colors.white24,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: MediaQuery.of(context).size.width / 70,
            ),
            child: SizedBox(
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    child: Image.asset(assetPath),
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Shimmer.fromColors(
                      baseColor: Colors.white12,
                      highlightColor: Colors.white70,
                      child: SizedBox(
                        child: Image.asset(assetPath),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 15, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 47, 59, 78),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                subscriptionController!.purchasing800SandDollars
                                                .value &&
                                            title == "800\nSand Dollars" ||
                                        subscriptionController!
                                                .purchasing100SandDollars
                                                .value &&
                                            title == "100\nSand Dollars" ||
                                        subscriptionController!
                                                .purchasing14500SandDollars
                                                .value &&
                                            title == "14,500\nSand Dollars"
                                    ? "Loading..."
                                    : price,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 213, 236, 255),
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
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

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 2,
            indent: 20,
            endIndent: 10, // Adjusted for spacing
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8.0), // Spacing around text
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.grey, fontSize: 12), // Style the text as needed
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 2,
            indent: 10, // Adjusted for spacing
            endIndent: 20,
          ),
        ),
      ],
    );
  }
}

Widget itemPackage(
    BuildContext context, String title, String price, String assetPath) {
  SubscriptionController subscriptionController =
      Get.find<SubscriptionController>();
  UserController userController = Get.find();
  SaveController saveController = Get.find();

  return GestureDetector(
    onTap: () {
      if (title == "XP Boost" &&
          DateTime.now().difference(saveController.xpBoostedAt.value) <
              const Duration(hours: 24)) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          key: UniqueKey(),
          content: const Text(
            "You can only use one XP Boost per day!",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ));
        return;
      }

      if (userController.user.value.gems < int.parse(price)) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          key: UniqueKey(),
          content: const Text(
            "Earn or buy more sand dollars to purchase this!",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ));
        return;
      }
      if (title == "Lucky Egg") {
        EggController egg = Get.find();
        userController.updateProperty(
            UserProperty.gems, userController.user.value.gems - 200);

        int whichTurtle = getTurtleToHatch("Water Sounds");
        egg.addEgg(18, whichTurtle);
        PostHogService posthog = Get.find();
        posthog.logEvent("LUCKY_EGG_PURCHASED", {});

        Get.to(const NewEggPage());
      } else if (title == "XP Boost") {
        userController.updateProperty(
            UserProperty.gems, userController.user.value.gems - 60);
        saveController.updateXpBoostedAt(DateTime.now());
        PostHogService posthog = Get.find();
        posthog.logEvent("XP_BOOST_PURCHASED", {});
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: title == "XP Boost" &&
                DateTime.now().difference(saveController.xpBoostedAt.value) <
                    const Duration(hours: 24)
            ? const Color.fromARGB(255, 46, 48, 59)
            : Colors.black12,
        border: (title == "XP Boost" &&
                DateTime.now().difference(saveController.xpBoostedAt.value) <
                    const Duration(hours: 24))
            ? Border.all(
                color: const Color.fromARGB(255, 81, 80, 107),
                width: 2,
              )
            : Border.all(
                color: Colors.white24,
                // width: 2,
              ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: MediaQuery.of(context).size.width / 70,
            ),
            child: SizedBox(
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    child: Image.asset(assetPath),
                  ),
                  title == "Lucky Egg"
                      ? ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.red.withOpacity(0.5),
                                Colors.orange.withOpacity(0.5),
                                Colors.yellow.withOpacity(0.5),
                                Colors.green.withOpacity(0.5),
                                Colors.blue.withOpacity(0.5),
                                Colors.indigo.withOpacity(0.5),
                                Colors.purple.withOpacity(0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.centerRight,
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Image.asset(
                            "assets/egg_spots.png",
                            height: 80,
                          ),
                        )
                      : Container(),
                  Opacity(
                    opacity: 0.8,
                    child: Shimmer.fromColors(
                      baseColor: Colors.white12,
                      highlightColor: Colors.white70,
                      child: SizedBox(
                        child: Image.asset(assetPath),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 15, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                (title == "XP Boost" &&
                        DateTime.now()
                                .difference(saveController.xpBoostedAt.value) <
                            const Duration(hours: 24))
                    ? Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 81, 80, 107),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            (24 -
                                        DateTime.now()
                                            .difference(saveController
                                                .xpBoostedAt.value)
                                            .inHours)
                                    .toString() +
                                "h",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 47, 59, 78),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  SizedBox(
                                      height: 16,
                                      child: Image.asset(
                                          "assets/sand_dollar.png")),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 213, 236, 255),
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
