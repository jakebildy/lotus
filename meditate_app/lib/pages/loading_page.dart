import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/util/quotes.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  double opacity = 0;
  @override
  void initState() {
    super.initState();

    increaseCount();
  }

  Future<void> increaseCount() async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    //_visible = true;
    return Scaffold(
      body: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
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
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      randomQuote(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ))),
            )
          ])),
    );
  }
}
