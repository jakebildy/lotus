import 'package:flutter/material.dart';

class PremiumContainer extends StatelessWidget {
  const PremiumContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5), // Add some padding around the text
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
          children: [
            SizedBox(
              width: 2,
            ),
            Icon(
              Icons.star,
              color: Colors.white,
              size: 10,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              "PREMIUM",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text color
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
