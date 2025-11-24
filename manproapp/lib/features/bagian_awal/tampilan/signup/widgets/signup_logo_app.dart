import 'package:flutter/material.dart';
import 'package:manpro/utils/constants/image_string.dart';

class SignupLogoApp extends StatelessWidget {
  const SignupLogoApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Transform.scale(
        scale: 1.75,
        child: const Image(
          height: 200.0,
          image: AssetImage(YPKImages.logo),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
