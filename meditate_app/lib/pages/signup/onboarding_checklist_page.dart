import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OnboardingChecklistPage extends StatelessWidget {
  const OnboardingChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Your First Steps'),
      ),
      body: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    width: MediaQuery.of(context).size.width - 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(56, 33, 156, 243),
                      borderRadius: BorderRadius.circular(20),
                      border: const Border.fromBorderSide(
                          BorderSide(color: Colors.transparent, width: 2)),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: (MediaQuery.of(context).size.width - 70) * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                      border: const Border.fromBorderSide(
                          BorderSide(color: Colors.transparent, width: 2)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("28%", style: TextStyle(color: Colors.lightBlue)),
            )
          ],
        ),

        // checklist
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.lightBlue),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Create an account",
                          style: TextStyle(color: Colors.lightBlue)),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Meditate for the first time",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Add profile picture"),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Add a friend"),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Protect your streak with streak freezes"),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Try breathwork"),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ]),
    );
  }
}
