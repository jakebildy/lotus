import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/signup/onboarding_checklist_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/util.dart';

class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    FollowController follow = Get.find();

    return Obx(
      () => GestureDetector(
        onTap: () {
          PostHogService posthog = Get.find();
          posthog.logEvent("ONBOARDING_PROGRESS_BAR_TAPPED", {});

          Get.to(const OnboardingChecklistPage());
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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "YOUR FIRST STEPS ON SHELLEVATE",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text((calculateOnboardingPercentage(
                                      user.user.value.totalMinutes > 0,
                                      user.user.value.avatar !=
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                      user.user.value.hasTriedStreakFreeze ||
                                          user.user.value.streakFreezes > 0,
                                      follow.usersFollowing.isNotEmpty,
                                      user.user.value.hasTriedBreathwork))
                                  .toString() +
                              "%"),
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
                            border: const Border.fromBorderSide(BorderSide(
                                color: Colors.transparent, width: 2)),
                          ),
                        ),
                        Container(
                          height: 8,
                          width: (MediaQuery.of(context).size.width - 60) *
                              (calculateOnboardingPercentage(
                                      user.user.value.totalMinutes > 0,
                                      user.user.value.avatar !=
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                      user.user.value.hasTriedStreakFreeze ||
                                          user.user.value.streakFreezes > 0,
                                      follow.usersFollowing.isNotEmpty,
                                      user.user.value.hasTriedBreathwork) /
                                  100),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: const Border.fromBorderSide(BorderSide(
                                color: Colors.transparent, width: 2)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Icon(Icons.arrow_forward_ios_sharp)
            ],
          ),
        ),
      ),
    );
  }
}
