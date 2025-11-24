import 'package:flutter/material.dart';
import 'package:manpro/utils/constants/image_string.dart';

class BackgroundAPP extends StatelessWidget {
  const BackgroundAPP({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(YPKImages.background),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
