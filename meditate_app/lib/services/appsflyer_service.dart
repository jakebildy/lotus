import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:get/get.dart';

class AppsflyerService extends GetxService {
  AppsflyerService() {
    _init();
  }

  void _init() async {
    AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
        afDevKey: "fDKWbmY89i8DNTKtDoHr5F",
        appId: "id1645214014",
        showDebug: true,
        timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
        //appInviteOneLink: oneLinkID, // Optional field
        disableAdvertisingIdentifier: false, // Optional field
        disableCollectASA: false); // Optional field

    AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  }
}
