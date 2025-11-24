import 'package:flutter/material.dart';

class IsiSignUp extends StatelessWidget {
  const IsiSignUp({
    super.key,
    required this.labelText,
    required this.controller,
    required this.obscureText,
  });

  final String labelText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w500,
            fontSize: 14.0),
      ),
    );
  }
}