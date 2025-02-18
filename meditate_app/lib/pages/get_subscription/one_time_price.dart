import 'package:flutter/material.dart';
import 'package:meditate_app/util/util.dart';

class OneTimePricingWidget extends StatelessWidget {
  final bool selected;
  const OneTimePricingWidget({super.key, this.selected = false});

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
                color: selected ? Colors.blue : Colors.black12,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lifetime",
                          style: TextStyle(
                              color: selected ? Colors.blue : Colors.black87,
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                        Text(
                          "One-time purchase, unlock forever",
                          style: TextStyle(
                              color: selected ? Colors.blue : Colors.black87,
                              // fontWeight: FontWeight.w900,
                              fontSize: 10),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (isCanada)
                          const Text("\$25",
                              style: TextStyle(
                                  color: Colors.black26,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        if (isCanada)
                          const SizedBox(
                            width: 5,
                          ),
                        Text(isCanada ? "\$11" : "\$4.99",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ],
                    )
                  ]),
            ),
          ),
        ),
        selected
            ? Container(
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
              )
            : Container(),
      ],
    );
  }
}
