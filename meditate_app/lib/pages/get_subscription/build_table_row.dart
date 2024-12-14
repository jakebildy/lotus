import 'package:flutter/material.dart';

TableRow buildTableRow(
    String feature, String free, String premium, int rowIndex) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          feature,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          free,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 30),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.only(
              bottomRight:
                  Radius.circular(rowIndex == 5 ? 20 : 0)), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            premium,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
    ],
  );
}
