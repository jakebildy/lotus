import 'dart:async';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/logger.dart';

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
    initialize();

    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _streamSubscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _streamSubscription.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>;
  }

  Future<void> initialize() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (available) {
      logSuccess("InAppPurchase is available");
      isAvailable = true;

      // Load available products
      const Set<String> _kIds = <String>{
        'shellevate_premium_01',
      };
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        logError("Subscription not found!");
      }
      List<ProductDetails> products = response.productDetails;
      logSuccess(
          "Subscription loaded: ${products[0].title.toString()} with price ${products[0].price.toString()}");
      shellevatePremium = products[0];

      // Check for past purchases
      UserController user = Get.find();
      if (user.user.value.username != "null") {
        InAppPurchase.instance
            .restorePurchases(applicationUserName: user.user.value.username);
      }
    } else {
      logError("InAppPurchase is not available");
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    if (purchaseDetailsList.isEmpty) {
      logInfo("No active subscription found.");
      SaveController save = Get.find();
      save.updateIsSubscribedToPremium(false);
      isSubscribedToPremium.value = false;
      update();
      return;
    }

    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // _showPendingUI();
        logInfo("Pending purchase...");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // _handleError(purchaseDetails.error!);
          logError("Purchase errors");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          isSubscribedToPremium.value = true;
          update();

          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (valid) {
          //   _deliverProduct(purchaseDetails);
          // } else {
          //   _handleInvalidPurchase(purchaseDetails);
          // }
        }

        if (purchaseDetails.status == PurchaseStatus.canceled) {
          getPremiumTapped.value = false;
          update();
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          SaveController save = Get.find();
          if (save.isSubscribedToPremium.value == false) {
            save.updateIsSubscribedToPremium(true);
            Get.offAll(const AppPages());
          }
        }
      }
    });
  }

  Future<void> buySubscription() async {
    // check if a subscription is already being purchased

    if (isAvailable == false) {
      logError("InAppPurchase is not available");
      return;
    }

    if (shellevatePremium != null) {
      getPremiumTapped.value = true;
      update();

      UserController user = Get.find();

      if (user.user.value.username != "null") {
        final PurchaseParam purchaseParam = PurchaseParam(
          productDetails: shellevatePremium!,
          applicationUserName: user.user.value.username,
        );
        InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
  }
}
