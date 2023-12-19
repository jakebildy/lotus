import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/api/index.dart' as api;
import 'package:meditate_app/controllers/user_controller.dart';

Widget buildDeleteAccountPopup(BuildContext context) {
  UserController userController = Get.find();

  return AlertDialog(
    title: Column(
      children: const [
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
              TextButton(
                onPressed: () async {
                  await api.analytics.logUserEvent("DELETE_ACCOUNT_REQUEST");
                  userController.logoutRequest();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete Account',
                    style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "It may take up to 24 hours for your account to be completely deleted.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ],
  );
}
