import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/follower_widget.dart';
import 'package:meditate_app/controllers/search_controller.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);
  final TextStyle appBarTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w400,
      fontFamily: "Termina");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          centerTitle: false,
          elevation: 0,
          title: SearchBox(),
        ),
        //Search - scafold body
        body: Container(
          color: Colors.grey[850],
          child: Center(
            child: ListView(
              // physics: ClampingScrollPhysics(),
              children: <Widget>[
                StylistsSearchResults(),
              ],
            ),
          ),
        ));
  }
}

class SearchBox extends StatelessWidget {
  SearchBox({Key? key}) : super(key: key);
  final InputDecoration _inputDecoration = InputDecoration(
      prefixIcon: Icon(
        Icons.search,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.black12,
      hintText: 'Search',
      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ));

  final TextStyle logoTextStyle = const TextStyle(
      color: Colors.red,
      fontSize: 27,
      fontWeight: FontWeight.w400,
      fontFamily: "Termina");

  @override
  Widget build(BuildContext context) {
    SearchController searchController = Get.find();
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.fromLTRB(0, 32, 16, 32),
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

class StylistsSearchResults extends StatelessWidget {
  const StylistsSearchResults({Key? key}) : super(key: key);
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
          ? Container(
              height: 176,
              child: Center(child: Text("Search for friends.")),
            )
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  searchController.searching.value
                      ? Container(
                          height: MediaQuery.of(context).size.height - 500,
                          child: Center(
                              child: SpinKitCircle(
                            color: Colors.teal,
                          )),
                        )
                      : searchController.userResults.length == 0
                          ? Container(
                              height: 176,
                              child: Center(child: Text("No results.")),
                            )
                          : Container(
                              height: searchController.userResults.length * 72,
                              child: new ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(left: 0, right: 0),
                                  scrollDirection: Axis.vertical,
                                  children: new List.generate(
                                      searchController.userResults.length,
                                      (int index) {
                                    return (searchController
                                                .userResults.length >
                                            index)
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new FollowerWidget(
                                                color: Colors.grey[850]!,
                                                user: searchController
                                                    .userResults[index]),
                                          )
                                        : Container();
                                  })),
                            )
                ],
              ),
            ),
    );
  }
}
