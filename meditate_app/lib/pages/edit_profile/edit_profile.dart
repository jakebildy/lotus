import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/edit_profile_controller.dart';
import 'package:meditate_app/pages/edit_profile/delete_account_popup.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        title: Text("Edit Profile"),
      ),
      body: Container(
        color: Colors.grey[850],
        child: ListView(
          // physics: ClampingScrollPhysics(),
          children: <Widget>[
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
    AuthController authController = Get.find();

    return Obx(
      () => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Hero(
                  tag: "profile_picture",
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        NetworkImage(authController.user.value.avatar),
                    backgroundColor: Colors.transparent,
                  ),
                )),
            // Change Profile Picture
            GestureDetector(
              onTap: editProfileController.changeProfilePhoto,
              child: Text("Change Profile Picture",
                  style: TextStyle(fontSize: 16, color: Colors.tealAccent)),
            ),

            SizedBox(height: 40),

            Divider(
              thickness: 1,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text("Name:", style: fieldTextStyle),
                  SizedBox(width: 44),
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    height: 60,
                    child: TextField(
                      // textAlign: TextAlign.center,
                      controller: editProfileController.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                      decoration: InputDecoration(
                        // hintText: "Enter your display name",
                        fillColor: Colors.black26,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Divider(
              thickness: 1,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                      height: 35,
                      child: Text("Username:", style: fieldTextStyle)),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    height: 60,
                    child: TextField(
                      // textAlign: TextAlign.center,
                      controller: editProfileController.username,

                      enabled: false,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.black26,
                        filled: true,
                        suffixIcon: Icon(Icons.lock),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Divider(
              thickness: 1,
            ),

            Padding(
              padding: const EdgeInsets.all(0.0),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.teal),
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    editProfileController.updateUser();
                    Navigator.of(context).pop();
                  },
                  child: Text("Save Changes",
                      style: TextStyle(color: Colors.tealAccent))),
            ),

            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.white10),
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          buildDeleteAccountPopup(context),
                    );
                  },
                  child: Text("Delete my account",
                      style: TextStyle(color: Colors.grey))),
            ),
          ],
        ),
      ),
    );
  }
}
