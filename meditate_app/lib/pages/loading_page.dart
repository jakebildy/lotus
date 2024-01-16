import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/quotes.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  double opacity = 0;
  double backgroundOpacity = 1;
  String quote = "";
  @override
  void initState() {
    super.initState();
    quote = randomQuote();
    increaseCount();
  }

  Future<void> increaseCount() async {
    UserController user = Get.find();
    user.isLoadingPageNotDone.value = true;
    user.update();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity = 1;
    });
    await Future.delayed(const Duration(milliseconds: 3200));
    while (user.isLoading.value) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    setState(() {
      backgroundOpacity = 0;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    user.isLoadingPageNotDone.value = false;
    user.update();
  }

  @override
  Widget build(BuildContext context) {
    //_visible = true;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedOpacity(
        opacity: backgroundOpacity,
        duration: const Duration(milliseconds: 600),
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 33, 135, 175),
                Color.fromARGB(255, 65, 113, 142),
                Color.fromARGB(255, 21, 115, 155),
                Color.fromARGB(255, 1, 126, 137),
              ],
            )),
            child: Stack(children: [
              Positioned.fill(
                  child: FloatingBubbles.alwaysRepeating(
                noOfBubbles: 20,
                sizeFactor: 0.03,
                opacity: 40,
                paintingStyle: PaintingStyle.fill,
                strokeWidth: 1,
                shape: BubbleShape.circle,
                colorsOfBubbles: [
                  Colors.white.withAlpha(30),
                ],
              )),
              AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: opacity,
                duration: const Duration(milliseconds: 2000),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        quote,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ))),
              )
            ])),
      ),
    );
  }
}
