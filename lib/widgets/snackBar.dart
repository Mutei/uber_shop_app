import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(
  String title,
  String message,
  Color backGroundColor,
  Color colorText,
) {
  Get.snackbar(
    title,
    message,
    backgroundColor: backGroundColor,
    colorText: colorText,
  );
}
