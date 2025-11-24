import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';

class TombolBack extends StatelessWidget {
  const TombolBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.offAll(() => const Navbar(), arguments: 0);
      },
      icon: const ImageIcon(
        AssetImage(YPKImages.icon_back_button),
        size: 32.0,
      ),
    );
  }
}
