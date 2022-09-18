import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/pages/user_profile/user_profile_page.dart';

class FollowingWidget extends StatelessWidget {
  final User user;

  const FollowingWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(UserProfilePage(user: user));
      },
      child: Container(
        color: Color.fromARGB(255, 42, 42, 42),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          height: 40,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(user.avatar))),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            "30 total minutes",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          height: 40,
                          child: Icon(Icons.arrow_forward_ios_rounded)))
                ],
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}
