import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

  Future<void> buySubscription(BuildContext context) async {
    getPremiumTapped.value = true;
    update();
    if (subscriptionPackage != null) {
      try {
        CustomerInfo customerInfo =
            await Purchases.purchasePackage(subscriptionPackage!);
        logSuccess("Purchased!");
        if (customerInfo.entitlements.all["Premium"] != null &&
            customerInfo.entitlements.all["Premium"]!.isActive) {
          // Unlock that great "pro" content
          logInfo('Unlocking premium content');
          SaveController save = Get.find();
          save.updateIsSubscribedToPremium(true);

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
        logWarning(offerings.current!.availablePackages.toString());
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
}

Future<void> purchaseSandDollars() async {}
