import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/util/logger.dart';

Timer? searchOnStoppedTyping;

class SearchController extends GetxController {
  RxList<User> userResults = new RxList();
  RxString queryValue = "".obs;
  final TextEditingController textEditingController = TextEditingController();
  RxBool searching = false.obs;

  SearchController() {}

  void onSearchChanged(String value) {
    queryValue.value = value;
    update();
    searchAndWait(value);
  }

  searchAndWait(String query) {
    searching.value = true;
    update();

    const duration = Duration(
        milliseconds:
            500); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel(); // clear timer
    }
    searchOnStoppedTyping = new Timer(duration, () => fetchResults(query));
  }

  Future<void> fetchResults(String query) async {
    searching.value = true;
    update();
    try {
      logInfo("Fetching search results...");
      List<User> responseStylists = await Api.search.searchStylists(query);

      userResults.value = responseStylists;
      update();
    } catch (error, trace) {
      logError(error.toString());
      logError(trace.toString());
    }
    searching.value = false;
    update();
  }
}
