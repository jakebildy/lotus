import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:meditate_app/pages/get_subscription/feature_checkbox.dart';

class ChecklistItemFeature extends StatelessWidget {
  final String title;
  final String description;
  const ChecklistItemFeature(
      {super.key, this.title = "", this.description = ""});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize
          .min, // this will take the minimum space required by the children
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const FeatureCheckbox(),
        Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // this will take the minimum space required by the children
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
