import 'package:d_button/d_button.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/app_color.dart';

class AppButton {
  static Widget primary(String title, VoidCallback? onClick) {
    return DButtonFlat(
      onClick: onClick,
      height: 46,
      mainColor: AppColor.primary,
      radius: 12,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
