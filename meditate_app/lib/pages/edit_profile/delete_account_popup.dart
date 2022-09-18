import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/api/index.dart' as API;

Widget buildDeleteAccountPopup(BuildContext context) {
  TextEditingController textEditingController = new TextEditingController();
  AuthController auth = Get.find();

  return new AlertDialog(
    title: Column(
      children: [
        Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
          size: 100,
        ),
        Text(
            "Are you sure you want to delete your account? This cannot be undone."),
      ],
    ),
    actions: <Widget>[
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new TextButton(
                onPressed: () async {
                  await API.analytics.logUserEvent("DELETE_ACCOUNT_REQUEST");
                  auth.logoutRequest();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete Account',
                    style: TextStyle(color: Colors.red)),
              ),
              new TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "It may take up to 24 hours for your account to be completely deleted.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ],
  );
}
