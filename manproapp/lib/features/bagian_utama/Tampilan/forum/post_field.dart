import 'package:flutter/material.dart';

class PostField extends StatelessWidget {
  const PostField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.obscureText});

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: null,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16.0,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          hintStyle: const TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
