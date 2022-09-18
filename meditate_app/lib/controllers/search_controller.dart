import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:meditate_app/models/user.dart';

Timer? searchOnStoppedTyping;

class SearchController extends GetxController {
  RxList<User> userResults = new RxList();
  RxString queryValue = "".obs;
  final TextEditingController textEditingController = TextEditingController();
  RxBool searching = false.obs;

  SearchController() {}

  void onSearchChanged(String value) {
    print(value);
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
      print("Fetching search results...");
      List<User> responseStylists = await Api.search.searchStylists(query);

      userResults.value = responseStylists;
      update();
    } catch (error, trace) {
      print(error);
      print(trace);
    }
    searching.value = false;
    update();
  }

  // //Called when the 'heart' icon is tapped on an outfit.
  // //If already liked, it will unlike the outfit instead.
  // Future<void> likeOutfit(Outfit outfit) async {
  //   if (likedOutfits.contains(outfit)) {
  //     likedOutfits.remove(outfit);
  //     try {
  //       await Api.likes.unlikeOutfit(outfit);
  //     } catch (error, trace) {
  //       print(error);
  //       print(trace);
  //     }
  //   } else {
  //     likedOutfits.add(outfit);
  //     try {
  //       await Api.likes.likeOutfit(outfit);
  //     } catch (error, trace) {
  //       print(error);
  //       print(trace);
  //     }
  //   }

  //   update();
  // }

  // //Called when the 'heart' icon is tapped on a clothing item.
  // //If already liked, it will unlike the clothing item instead.
  // Future<void> likeClothingItem(ClothingItem clothingItem) async {
  //   if (likedItems.contains(clothingItem)) {
  //     likedItems.remove(clothingItem);
  //     likedItemIDs.remove(clothingItem.id);
  //     try {
  //       await Api.likes.unlikeClothingItem(clothingItem);
  //     } catch (error, trace) {
  //       print(error);
  //       print(trace);
  //     }
  //   } else {
  //     likedItems.add(clothingItem);
  //     likedItemIDs.add(clothingItem.id!);
  //     try {
  //       await Api.likes.likeClothingItem(clothingItem);
  //     } catch (error, trace) {
  //       print(error);
  //       print(trace);
  //     }
  //   }

  //   update();
  // }
}
