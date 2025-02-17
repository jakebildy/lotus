import 'package:flutter/material.dart';

class FeatureCheckbox extends StatelessWidget {
  const FeatureCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 214, 214, 214)),
              height: 30,
              width: 30),
          const Text("✓",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue)),
        ],
      ),
    );
  }
}
