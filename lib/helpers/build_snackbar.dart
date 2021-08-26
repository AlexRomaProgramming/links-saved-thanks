import 'package:flutter/material.dart';
import 'package:get/get.dart';

void buildSimpleSnackbar(String title, String message, Icon icon) {
  return Get.snackbar(
    title,
    message,
    titleText: Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
    ),
    messageText: Text(
      message,
      style: TextStyle(fontSize: 16, color: Colors.white),
    ),
    icon: icon,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 3),
    barBlur: 12,
    borderWidth: 2,
    borderColor: Colors.limeAccent,
  );
}
