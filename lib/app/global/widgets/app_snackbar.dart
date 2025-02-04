import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  void defaultBar(title, message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xff6A6A82),
      snackPosition: SnackPosition.BOTTOM,
      colorText: const Color(0xffFFFFFF),
      titleText: Text(
        title,
        style: const TextStyle(
            fontSize: 0,
            fontWeight: FontWeight.w800,
            color: Color(0xffFFFFFF),
            fontFamily: 'Roboto'),
      ),
      margin: const EdgeInsets.all(8),
      // padding: const EdgeInsets.only(bottom: 8),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xffFFFFFF),
            fontFamily: 'Roboto'),
      ),
    );
  }

  void concluded(title, message) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xff6A6A82),
      snackPosition: SnackPosition.BOTTOM,
      colorText: const Color(0xffFFFFFF),
      titleText: Text(
        title,
        style: const TextStyle(
            fontSize: 0,
            fontWeight: FontWeight.w800,
            color: Color(0xffFFFFFF),
            fontFamily: 'Roboto'),
      ),
      margin: const EdgeInsets.all(8),
      // padding: const EdgeInsets.only(bottom: 8),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xffFFFFFF),
            fontFamily: 'Roboto'),
      ),
    );
  }

  void flutterSnackBar(title, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff6A6A82),
        duration: const Duration(
          seconds: 2,
        ),
        content: Text(title),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
      ),
    );
  }
}
