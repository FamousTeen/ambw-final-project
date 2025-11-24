import 'package:flutter/material.dart';

class TulisanKontak extends StatelessWidget {
  const TulisanKontak({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Kontak Yayasan',
      style: TextStyle(
        fontSize: 28.0,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}
