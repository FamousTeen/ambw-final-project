import 'package:flutter/material.dart';

class TulisanProfile extends StatelessWidget {
  const TulisanProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Yayasan',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 24.0,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}