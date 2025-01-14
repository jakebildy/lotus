import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:meditate_app/api/user_api.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/egg_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/pages/turtle_hatch_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:meditate_app/api/index.dart' as api;

/// SubscriptionController handles the subscription/purchases
/// {@category Controllers}
class SubscriptionController extends GetxController {
  late ProductDetails? shellevatePremium;

  bool isAvailable = false;

  //Don't use this value to check if subscribed, use the one in SaveController
  RxBool isSubscribedToPremium = false.obs;
  RxBool getPremiumTapped = false.obs;

  SubscriptionController() {
    initPlatformState();
  }

  Package? subscriptionPackage;
  Package? subscriptionPackageDiscount;
  Package? sandDollars800Package;
  Package? sandDollars100Package;
  Package? sandDollars14500Package;
  Package? eggHatchPackage;

  RxBool purchasing800SandDollars = false.obs;
  RxBool purchasing100SandDollars = false.obs;
  RxBool purchasing14500SandDollars = false.obs;
  RxBool purchasingEggHatch = false.obs;

  final InAppReview inAppReview = InAppReview.instance;

  Future<void> buySubscription(BuildContext context) async {
    getPremiumTapped.value = true;
    update();
    if (subscriptionPackage != null) {
      try {
        CustomerInfo customerInfo =
            await Purchases.purchasePackage(subscriptionPackage!);
        // UserController user = Get.find();
        // api.user.userSubscribed(user.user.value.email);
        logSuccess("Purchased!");
        if (customerInfo.entitlements.all["Premium"] != null &&
            customerInfo.entitlements.all["Premium"]!.isActive) {
          // Unlock that great "pro" content
          logInfo('Unlocking premium content');
          SaveController save = Get.find();
          save.updateIsSubscribedToPremium(true);

          PostHogService posthog = Get.find();
          posthog.logEvent("TRIAL_STARTED", {});

          Get.offAll(const AppPages());

          if (save.hasReviewed.value == false) {
            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
              save.updateHasReviewed();
            }
          }
        }
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          logError(e.toString());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              key: UniqueKey(),
              backgroundColor: Colors.black,
              content: Text(
                e.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              )));
        }
        getPremiumTapped.value = false;
        update();
      }
    } else {
      logError("subscriptionPackage is null!");
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          key: UniqueKey(),
          backgroundColor: Colors.black,
          content: const Text(
            "Subscription does not exist!",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )));
    }

    getPremiumTapped.value = false;
    update();
  }

  Future<void> buySubscriptionDiscount(BuildContext context) async {
    getPremiumTapped.value = true;
    update();
    if (subscriptionPackageDiscount != null) {
      try {
        CustomerInfo customerInfo =
            await Purchases.purchasePackage(subscriptionPackageDiscount!);
        // UserController user = Get.find();
        // api.user.userSubscribed(user.user.value.email);
        logSuccess("Purchased!");
        if (customerInfo.entitlements.all["Premium"] != null &&
            customerInfo.entitlements.all["Premium"]!.isActive) {
          // Unlock that great "pro" content
          logInfo('Unlocking premium content');
          SaveController save = Get.find();
          save.updateIsSubscribedToPremium(true);

          PostHogService posthog = Get.find();
          posthog.logEvent("DISCOUNT_STARTED", {});

          Get.offAll(const AppPages());
        }
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          logError(e.toString());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              key: UniqueKey(),
              backgroundColor: Colors.black,
              content: Text(
                e.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              )));
        }
        getPremiumTapped.value = false;
        update();
      }
    } else {
      logError("subscriptionPackageDiscount is null!");
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          key: UniqueKey(),
          backgroundColor: Colors.black,
          content: const Text(
            "Subscription does not exist!",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )));
    }

    getPremiumTapped.value = false;
    update();
  }

  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);
    UserController user = Get.find();

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_AHySwhpSZMCEuqqmZrhbUjMhJPv");
    } else {
      configuration =
          PurchasesConfiguration("appl_HEBWkEyqgTkiujTorPxIamHrVjW");
    }
    configuration.appUserID = user.user.value.id;
    await Purchases.configure(configuration);

    // Fetch offerings
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        // Display packages for sale
        subscriptionPackage = offerings.current!.availablePackages[0];
        subscriptionPackageDiscount =
            offerings.all["default_offering_discount"]!.availablePackages[0];
        logWarning(offerings.current!.availablePackages.toString());

        // Get the sand dollars product
        sandDollars800Package =
            offerings.all["sand_dollar_purchase"]!.availablePackages[0];

        sandDollars100Package =
            offerings.all["100_sand_dollar_purchase"]!.availablePackages[0];

        sandDollars14500Package =
            offerings.all["14500_sand_dollar_purchase"]!.availablePackages[0];

        // Get the instant egg hatch product
        eggHatchPackage =
            offerings.all["instant_egg_hatch"]!.availablePackages[0];
      }
    } on PlatformException catch (e) {
      // optional error handling
      logError("🎃" + e.toString());
    }

    // Fetch subscription status
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // access latest customerInfo
      if (customerInfo.entitlements.all["Premium"] != null &&
          customerInfo.entitlements.all["Premium"]!.isActive) {
        // Grant user "pro" access
        SaveController save = Get.find();
        save.updateIsSubscribedToPremium(true);
      } else {
        SaveController save = Get.find();
        save.updateIsSubscribedToPremium(false);
      }
    } on PlatformException catch (e) {
      logError(e.toString());
      // Error fetching customer info
    }
  }

  Future<void> purchase800SandDollars() async {
    SubscriptionController subscriptionController = Get.find();
    if (subscriptionController.sandDollars800Package != null) {
      try {
        purchasing800SandDollars.value = true;
        CustomerInfo customerInfo = await Purchases.purchasePackage(
            subscriptionController.sandDollars800Package!);
        logSuccess("Purchased!");
        UserController user = Get.find();
        await user.updateProperty(
            UserProperty.gems, user.user.value.gems + 800);
        purchasing800SandDollars.value = false;
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          logError(e.toString());
        }
        purchasing800SandDollars.value = false;
      }
    } else {
      logError("sandDollarPackage is null!");
    }
  }

  Future<void> purchase100SandDollars() async {
    SubscriptionController subscriptionController = Get.find();
    if (subscriptionController.sandDollars100Package != null) {
      try {
        purchasing100SandDollars.value = true;
        CustomerInfo customerInfo = await Purchases.purchasePackage(
            subscriptionController.sandDollars100Package!);
        logSuccess("Purchased!");
        UserController user = Get.find();
        await user.updateProperty(
            UserProperty.gems, user.user.value.gems + 100);
        purchasing100SandDollars.value = false;
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          logError(e.toString());
        }
        purchasing100SandDollars.value = false;
      }
    } else {
      logError("sandDollarPackage 100 is null!");
    }
  }

  Future<void> purchase14500SandDollars() async {
    SubscriptionController subscriptionController = Get.find();
    if (subscriptionController.sandDollars14500Package != null) {
      try {
        purchasing14500SandDollars.value = true;
        CustomerInfo customerInfo = await Purchases.purchasePackage(
            subscriptionController.sandDollars14500Package!);
        logSuccess("Purchased!");
        UserController user = Get.find();
        await user.updateProperty(
            UserProperty.gems, user.user.value.gems + 14500);
        purchasing14500SandDollars.value = false;
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          logError(e.toString());
        }
        purchasing14500SandDollars.value = false;
      }
    } else {
      logError("sandDollarPackage 14500 is null!");
    }
  }

  Future<void> purchaseInstantEggHatch() async {
    SubscriptionController subscriptionController = Get.find();
    if (subscriptionController.eggHatchPackage != null) {
      try {
        purchasingEggHatch.value = true;
        CustomerInfo customerInfo = await Purchases.purchasePackage(
            subscriptionController.eggHatchPackage!);
        logSuccess("Purchased!");
        // pop the popup that's open
        Get.back();
        UserController user = Get.find();
        int turtleToHatch;
        int turtleColorToHatch;
        if (user.user.value.eggTypes.isNotEmpty) {
          String eggTypeNew = user.user.value.eggTypes[0];
          turtleToHatch = int.parse(eggTypeNew.split("-")[0]);
          turtleColorToHatch = int.parse(eggTypeNew.split("-")[1]);
        } else {
          turtleToHatch = 1;
          turtleColorToHatch = 1;
        }
        Get.to(TurtleHatchPage(
            gemsAmount: -1,
            foundEgg: false,
            levelUp: false,
            id: turtleToHatch,
            color: turtleColorToHatch));
        EggController eggController = Get.find();
        await eggController.hatchTurtle(turtleToHatch, turtleColorToHatch);

        purchasingEggHatch.value = false;
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          logError(e.toString());
        }
        purchasingEggHatch.value = false;
      }
    } else {
      logError("instant egg hatch is null!");
    }
  }
}
