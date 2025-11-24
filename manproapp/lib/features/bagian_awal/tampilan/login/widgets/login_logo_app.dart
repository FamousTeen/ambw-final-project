import 'package:flutter/material.dart';
import 'package:manpro/utils/constants/image_string.dart';

class LoginLogoApp extends StatelessWidget {
  const LoginLogoApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Transform.scale(
        scale: 1.2,
        child: const Image(
          height: 300.0,
          image: AssetImage(YPKImages.logo),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
