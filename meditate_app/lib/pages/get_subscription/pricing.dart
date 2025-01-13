import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PricingWidget extends StatelessWidget {
  const PricingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 216, 255, 252), // Lighter shade of purple
                  Color.fromARGB(255, 192, 198, 222), // Darker shade of purple
                ],
              ),
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "1 month",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w900,
                          fontSize: 18),
                    ),
                    Row(
                      children: [
                        Text("\$4.99",
                            style: TextStyle(
                                color: Colors.black26,
                                // strikethrough
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        SizedBox(
                          width: 5,
                        ),
                        Text("\$1.99",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ],
                    )
                  ]),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.blue,
                width: 0,
              ),
              borderRadius: BorderRadius.circular(1000)),
          child: const Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(Icons.check, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
