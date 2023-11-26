import 'package:flutter/material.dart';

SnackBar showCustomSnackbar({text, colour}) {
  Map<String, Color> snackBarColours = {
    'success': const Color.fromARGB(255, 205, 242, 202),
    'failure': const Color.fromARGB(255, 255, 143, 143),
    'warning': const Color.fromARGB(255, 255, 251, 193)
  };

  return SnackBar(
    dismissDirection: DismissDirection.horizontal,
    elevation: 2,
    width: 300,
    behavior: SnackBarBehavior.floating,
    backgroundColor: snackBarColours[colour],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.black),
    ),
  );
}
