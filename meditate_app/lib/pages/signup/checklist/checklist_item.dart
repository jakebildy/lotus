import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChecklistItem extends StatelessWidget {
  final String text;
  final bool checked;

  const ChecklistItem({super.key, required this.text, required this.checked});

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
                    color: checked ? Colors.lightBlue : Colors.white)),
          ),
        ],
      ),
    );
  }
}
