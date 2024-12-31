import 'package:flutter/material.dart';

class FindUsWidget extends StatelessWidget {
  final String text;
  final bool selected;
  const FindUsWidget({super.key, required this.text, required this.selected});

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
                color: selected ? Colors.blue : Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                          color: selected ? Colors.blue : Colors.black87,
                          fontWeight:
                              selected ? FontWeight.w900 : FontWeight.bold,
                          fontSize: 18),
                    ),
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
