import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TryForFreeContainer extends StatelessWidget {
  const TryForFreeContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(5), // Add some padding around the text
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green, // Lighter shade of purple
                Colors.teal, // Darker shade of purple
              ],
            ),
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Center(
            // Center the text inside the container
            child: Row(
              children: const [
                SizedBox(
                  width: 4,
                ),
                Text(
                  "Try for Free",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text color
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.white10,
          highlightColor: Colors.white30,
          child: Container(
              height: 20,
              padding:
                  const EdgeInsets.all(5), // Add some padding around the text
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green, // Lighter shade of purple
                    Colors.teal, // Darker shade of purple
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ) // Rounded corners
              ),
        ),
      ],
    );
  }
}
