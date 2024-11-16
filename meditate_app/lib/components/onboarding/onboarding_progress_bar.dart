import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meditate_app/pages/signup/onboarding_checklist_page.dart';

class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Get.to(OnboardingChecklistPage()),
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "YOUR FIRST STEPS ON SHELLEVATE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("28%"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 8,
                        width: MediaQuery.of(context).size.width - 60,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                          border: const Border.fromBorderSide(
                              BorderSide(color: Colors.transparent, width: 2)),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: (MediaQuery.of(context).size.width - 60) * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: const Border.fromBorderSide(
                              BorderSide(color: Colors.transparent, width: 2)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Icon(Icons.arrow_forward_ios_sharp)
          ],
        ),
      ),
    );
  }
}
