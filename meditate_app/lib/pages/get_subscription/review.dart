import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String review;

  const ReviewCard({super.key, required this.name, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 500, // Maximum height
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 242, 243, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Fit children size
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("⭐️⭐️⭐️⭐️⭐️"),
                ],
              ),
              SizedBox(height: 8), // Spacing between elements
              Text(
                review,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
