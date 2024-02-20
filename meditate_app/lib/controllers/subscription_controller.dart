import 'dart:async';
import 'dart:io';

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
  late StreamSubscription<List<PurchaseDetails>> _streamSubscription;

  //Don't use this value to check if subscribed, use the one in SaveController
  RxBool isSubscribedToPremium = false.obs;
  RxBool getPremiumTapped = false.obs;

  SubscriptionController() {
    initPlatformState();
  }

  // Future<void> initialize() async {
  //   final bool available = await InAppPurchase.instance.isAvailable();
  //   if (available) {
  //     logSuccess("InAppPurchase is available");
  //     isAvailable = true;

  //     // Load available products
  //     const Set<String> _kIds = <String>{
  //       'shellevate_premium_01',
  //     };
  //     final ProductDetailsResponse response =
  //         await InAppPurchase.instance.queryProductDetails(_kIds);
  //     if (response.notFoundIDs.isNotEmpty) {
  //       logError("Subscription not found!");
  //     }
  //     List<ProductDetails> products = response.productDetails;
  //     logSuccess(
  //         "Subscription loaded: ${products[0].title.toString()} with price ${products[0].price.toString()}");
  //     shellevatePremium = products[0];

  //     // Check for past purchases
  //     UserController user = Get.find();
  //     if (user.user.value.username != "null") {
  //       InAppPurchase.instance
  //           .restorePurchases(applicationUserName: user.user.value.username);
  //     }
  //   } else {
  //     logError("InAppPurchase is not available");
  //   }
  // }

  // void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  //   purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
  //     if (purchaseDetails.status == PurchaseStatus.pending) {
  //       // _showPendingUI();
  //       logInfo("Pending purchase...");
  //     } else {
  //       if (purchaseDetails.status == PurchaseStatus.error) {
  //         // _handleError(purchaseDetails.error!);
  //         logError("Purchase errors");
  //       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
  //           purchaseDetails.status == PurchaseStatus.restored) {
  //         isSubscribedToPremium.value = true;
  //         update();

  //         // bool valid = await _verifyPurchase(purchaseDetails);
  //         // if (valid) {
  //         //   _deliverProduct(purchaseDetails);
  //         // } else {
  //         //   _handleInvalidPurchase(purchaseDetails);
  //         // }
  //       }

  //       if (purchaseDetails.status == PurchaseStatus.canceled) {
  //         getPremiumTapped.value = false;
  //         update();
  //       }
  //       if (purchaseDetails.pendingCompletePurchase) {
  //         await InAppPurchase.instance.completePurchase(purchaseDetails);
  //         SaveController save = Get.find();
  //         //TODO: also wait for loading to be finished
  //         if (save.isSubscribedToPremium.value == false &&
  //             save.loadingSaveController.value == false) {
  //           save.updateIsSubscribedToPremium(true);
  //           Get.offAll(const AppPages());
  //         }
  //       }
  //     }
  //   });
  // }

//   Future<void> buySubscription() async {
//     // check if a subscription is already being purchased

//     if (isAvailable == false) {
//       logError("InAppPurchase is not available");
//       return;
//     }

//     if (shellevatePremium != null) {
//       getPremiumTapped.value = true;
//       update();

//       UserController user = Get.find();

//       if (user.user.value.username != "null") {
//         final PurchaseParam purchaseParam = PurchaseParam(
//           productDetails: shellevatePremium!,
//           applicationUserName: user.user.value.username,
//         );
//         InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
//       }
//     }
//   }
// }

  Package? subscriptionPackage;

  Future<void> buySubscription() async {
    getPremiumTapped.value = true;
    update();
    if (subscriptionPackage != null) {
      try {
        CustomerInfo customerInfo =
            await Purchases.purchasePackage(subscriptionPackage!);

        if (customerInfo.entitlements.all["shellevate_premium"] != null &&
            customerInfo.entitlements.all["shellevate_premium"]!.isActive) {
          // Unlock that great "pro" content
          SaveController save = Get.find();
          save.updateIsSubscribedToPremium(true);
        }
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          logError(e.toString());
        }
        getPremiumTapped.value = false;
        update();
      }
    } else {
      logError("subscriptionPackage is null!");
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
    await Purchases.configure(configuration..appUserID = user.user.value.id);

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
    }

    // Fetch subscription status
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // access latest customerInfo
      if (customerInfo.entitlements.all["shellevate_premium"] != null &&
          customerInfo.entitlements.all["shellevate_premium"]!.isActive) {
        // Grant user "pro" access
        SaveController save = Get.find();
        save.updateIsSubscribedToPremium(true);
      } else {
        SaveController save = Get.find();
        save.updateIsSubscribedToPremium(false);
      }
    } on PlatformException catch (e) {
      // Error fetching customer info
    }
  }
}
