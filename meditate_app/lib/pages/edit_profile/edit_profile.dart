import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/edit_profile_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/edit_profile/delete_account_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text("Edit Profile"),
      ),
      body: Container(
        color: Colors.grey[900],
        child: ListView(
          // physics: ClampingScrollPhysics(),
          children: const <Widget>[
            ProfileInfo(),
            //ProfileItems(),
          ],
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key}) : super(key: key);
  final TextStyle fieldTextStyle = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
  final TextStyle countTextStyle = const TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500);
  final TextStyle bodyTextStyle = const TextStyle(
      color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    EditProfileController editProfileController =
        Get.put(EditProfileController());
    UserController userController = Get.find();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(
            thickness: 1,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              // make it so tapping anywhere on the row opens the app settings (including space)
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // open app settings
                launchUrl(Uri.parse("app-settings:"));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.notifications),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Notification Settings",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
            ),
          ),

          const Divider(
            thickness: 1,
          ),
          // Profile Image
          Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Hero(
                tag: "profile_picture",
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage:
                      NetworkImage(userController.user.value.avatar),
                  backgroundColor: Colors.transparent,
                ),
              )),
          // Change Profile Picture
          GestureDetector(
            onTap: () => editProfileController.changeProfilePhoto(context),
            child: const Text("Change Profile Picture",
                style: TextStyle(fontSize: 16, color: Colors.tealAccent)),
          ),

          const SizedBox(height: 40),

          const Divider(
            thickness: 1,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text("Name:", style: fieldTextStyle),
                const SizedBox(width: 44),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 120,
                  height: 60,
                  child: TextField(
                    // textAlign: TextAlign.center,
                    controller: editProfileController.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                    decoration: InputDecoration(
                      // hintText: "Enter your display name",
                      fillColor: Colors.black26,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                )
              ],
            ),
          ),

          const Divider(
            thickness: 1,
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                    height: 35,
                    child: Text("Username:", style: fieldTextStyle)),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 120,
                  height: 60,
                  child: TextField(
                    // textAlign: TextAlign.center,
                    controller: editProfileController.username,

                    enabled: false,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Colors.black26,
                      filled: true,
                      suffixIcon: const Icon(Icons.lock),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(0.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: Colors.teal),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  editProfileController.updateUser();
                  Navigator.of(context).pop();
                },
                child: const Text("Save Changes",
                    style: TextStyle(color: Colors.tealAccent))),
          ),

          const SizedBox(
            height: 20,
          ),

          const SizedBox(
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: Colors.white10),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        buildDeleteAccountPopup(context),
                  );
                },
                child: const Text("Delete my account",
                    style: TextStyle(color: Colors.grey))),
          ),
        ],
      ),
    );
  }
}
