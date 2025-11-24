import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/features/bagian_awal/tampilan/login/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
