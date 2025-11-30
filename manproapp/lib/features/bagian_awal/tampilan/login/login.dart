import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/features/bagian_awal/controllers/authenticationController.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/features/bagian_awal/tampilan/login/widgets/isi_login.dart';
import 'package:manpro/features/bagian_awal/tampilan/login/widgets/login_logo_app.dart';
import 'package:manpro/features/bagian_awal/tampilan/signup/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticationController.tryAutoLoginWithCache();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Bagian bg app
          const BackgroundAPP(),

          // Bagian isi tampilan
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Column(
                  children: [
                    // Gambar logo
                    const LoginLogoApp(),

                    // Bagian login
                    Container(
                      margin: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                      height: 250.0,
                      decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.4),
                          width: 1.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3.0,
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 13.0, 13.0, 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Bagian tulisan login
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w800,
                                fontSize: 20.0,
                              ),
                            ),

                            Form(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IsiLogin(
                                    labelText: 'Username',
                                    controller: _usernameController,
                                    obscureText: false,
                                  ),
                                  IsiLogin(
                                    labelText: 'Password',
                                    controller: _passwordController,
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),

                            // Bagian tombol
                            SizedBox(
                              width: 170.0,
                              child: Obx(() {
                                return authenticationController.isLoading.value
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: () async =>
                                            await authenticationController
                                                .login(
                                          username:
                                              _usernameController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                        ),
                                        child: const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Bagian tulisan bawah
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don’t Have an Account ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.to(() => const Signup()),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                minimumSize: const Size(100, 40),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                ' Sign Up Here',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
