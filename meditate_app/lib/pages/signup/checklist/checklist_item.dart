import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChecklistItem extends StatelessWidget {
  final String text;
  final bool checked;
  final Function()? action;

  const ChecklistItem(
      {super.key,
      required this.text,
      required this.checked,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          checked
              ? const Icon(Icons.check_circle, color: Colors.lightBlue)
              : const Icon(Icons.circle_outlined, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: checked ? Colors.lightBlue : Colors.white)),
          ),
          Spacer(),
          action != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_forward_outlined, size: 20),
                  onPressed: action,
                )
              : Container(),
        ],
      ),
    );
  }
}
