import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:meditate_app/util/logger.dart';

/// SubscriptionController handles the subscription/purchases
/// {@category Controllers}
class SubscriptionController extends GetxController {
  late ProductDetails? shellevatePremium;
  bool isAvailable = false;

  SubscriptionController() {
    initialize();
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
    } else {
      logError("InAppPurchase is not available");
    }
  }

  Future<void> buySubscription() async {
    if (isAvailable == false) {
      logError("InAppPurchase is not available");
      return;
    }
    if (shellevatePremium != null) {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: shellevatePremium!,
        applicationUserName: null,
      );
      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }
}
