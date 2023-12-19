import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/pages/new_egg_page.dart';

class NewGemsPage extends StatefulWidget {
  final int gemsAmount;
  final bool foundEgg;

  const NewGemsPage(
      {Key? key, required this.gemsAmount, required this.foundEgg})
      : super(key: key);

  @override
  State<NewGemsPage> createState() => _NewGemsPageState();
}

class _NewGemsPageState extends State<NewGemsPage>
    with TickerProviderStateMixin {
  late AudioPlayer gemNoise;

  //init state
  @override
  void initState() {
    super.initState();
    //  play the noise "new_gems.mp3"
    gemNoise = AudioPlayer();
    gemNoise.setVolume(10.0);
    gemNoise.play(AssetSource('audio/new_gems.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Stack(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Image.asset("assets/sand_dollar_chest.png")),
                  // Shimmer.fromColors(
                  //   baseColor: Colors.white12,
                  //   highlightColor: Colors.white70,
                  //   child: Container(
                  //       height: MediaQuery.of(context).size.height / 4,
                  //       child: Image.asset("assets/gems_overlay.png")),
                  // ),
                ],
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("+" + widget.gemsAmount.toString(),
                style: const TextStyle(
                    fontSize: 120, color: Colors.lightBlueAccent)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "You earned " + widget.gemsAmount.toString() + " sand dollars!",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Container(
              child: const Padding(
            padding: EdgeInsets.fromLTRB(16, 8.0, 16, 8),
            child: Text(
              "The longer you meditate, the more sand dollars you'll earn",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          )),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              if (widget.foundEgg) {
                Get.offAll(const NewEggPage());
              } else {
                Get.offAll(const AppPages());
              }
            },
            child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 16, 77, 127),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                // color: const Color.fromARGB(255, 16, 77, 127),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 100),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                )),
          )
        ],
      ),
    ));
  }
}
