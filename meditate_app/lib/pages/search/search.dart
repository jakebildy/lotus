import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/follower_widget.dart';
import 'package:meditate_app/controllers/search_controller.dart';
import 'package:meditate_app/pages/search/friend_suggestions.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);
  final TextStyle appBarTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w400,
      fontFamily: "Termina");

  @override
  Widget build(BuildContext context) {
    SearchController searchController = Get.put(SearchController());
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          centerTitle: false,
          elevation: 0,
          title: SearchBox(),
        ),
        backgroundColor: Colors.grey[900],
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.ios_share_outlined),
        //   onPressed: () {
        //     UserController userController = Get.find();
        //     Share.share("Add me on Shellevate! My username is @" +
        //         userController.user.value.username +
        //         "\n\n https://shellevate.app/get");
        //   },
        // ),
        //Search - scafold body
        body: Container(
            color: Colors.grey[900],
            child: Center(
              child: ListView(
                // physics: ClampingScrollPhysics(),
                children: <Widget>[
                  const SearchResults(),
                  searchController.queryValue.value != ''
                      ? Container()
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Friend Suggestions",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                  searchController.queryValue.value != ''
                      ? Container()
                      : const FriendSuggestions(),
                ],
              ),
            )),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  SearchBox({Key? key}) : super(key: key);
  final InputDecoration _inputDecoration = InputDecoration(
      prefixIcon: const Icon(
        Icons.search,
        color: Colors.white,
      ),
      filled: true,
      fillColor: Colors.black12,
      hintText: 'Search',
      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ));

  @override
  Widget build(BuildContext context) {
    SearchController searchController = Get.find();
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 32, 16, 32),
          child: TextField(
            controller: searchController.textEditingController,
            decoration: _inputDecoration,
            onChanged: (String value) {
              searchController.onSearchChanged(value);
            },
          ),
        )),
      ],
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({Key? key}) : super(key: key);
  final TextStyle titleTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: "Termina",
      fontWeight: FontWeight.w600);
  final TextStyle moreTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontFamily: "Termina",
      fontWeight: FontWeight.w600);
  final String title = "Users";
  final String seeMoreText = "See More >";

  @override
  Widget build(BuildContext context) {
    SearchController searchController = Get.find();

    return Obx(
      () => searchController.queryValue.value == ''
          ? const SizedBox(
              height: 176,
              child: Center(
                child: Text("Search for friends!",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                searchController.searching.value
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height - 500,
                        child: const Center(
                            child: SpinKitCircle(
                          color: Colors.teal,
                        )),
                      )
                    : searchController.userResults.isEmpty
                        ? const SizedBox(
                            height: 176,
                            child: Center(child: Text("No results.")),
                          )
                        : SizedBox(
                            height: searchController.userResults.length * 72,
                            child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.only(left: 0, right: 0),
                                scrollDirection: Axis.vertical,
                                children: List.generate(
                                    searchController.userResults.length,
                                    (int index) {
                                  return (searchController.userResults.length >
                                          index)
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FollowerWidget(
                                              color: Colors.grey[850]!,
                                              user: searchController
                                                  .userResults[index]),
                                        )
                                      : Container();
                                })),
                          )
              ],
            ),
    );
  }
}
