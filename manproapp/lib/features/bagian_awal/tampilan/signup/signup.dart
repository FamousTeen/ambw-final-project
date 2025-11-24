import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/features/bagian_awal/controllers/authenticationController.dart';
import 'package:manpro/features/bagian_awal/tampilan/signup/widgets/isi_signup.dart';
import 'package:manpro/features/bagian_awal/tampilan/signup/widgets/signup_logo_app.dart';
import 'package:manpro/features/bagian_awal/tampilan/login/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Bagian controller
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _kotaAsalController = TextEditingController();
  final TextEditingController _noTelponController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Bagian bg app
          const BackgroundAPP(),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Column(
                  children: [
                    // Bagian logo app
                    const SignupLogoApp(),

                    // Bagian signup
                    Container(
                      margin: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                      // height: 550.0,
                      height: 450.0,
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
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w800,
                                fontSize: 20.0,
                              ),
                            ),

                            // Bagian text field
                            Form(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IsiSignUp(
                                    labelText: 'Nama Lengkap',
                                    controller: _namaLengkapController,
                                    obscureText: false,
                                  ),
                                  IsiSignUp(
                                    labelText: 'Username',
                                    controller: _usernameController,
                                    obscureText: false,
                                  ),
                                  IsiSignUp(
                                    labelText: 'Email',
                                    controller: _emailController,
                                    obscureText: false,
                                  ),
                                  IsiSignUp(
                                    labelText: 'Kota Asal',
                                    controller: _kotaAsalController,
                                    obscureText: false,
                                  ),
                                  IsiSignUp(
                                    labelText: 'No. Telpon',
                                    controller: _noTelponController,
                                    obscureText: false,
                                  ),
                                  IsiSignUp(
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
                                        onPressed: () async {
                                          await authenticationController
                                              .register(
                                            nama_lengkap: _namaLengkapController
                                                .text
                                                .trim(),
                                            username:
                                                _usernameController.text.trim(),
                                            email: _emailController.text.trim(),
                                            kota_asal:
                                                _kotaAsalController.text.trim(),
                                            no_telpon:
                                                _noTelponController.text.trim(),
                                            password:
                                                _passwordController.text.trim(),
                                          );
                                        },
                                        child: const Text(
                                          'Confirm',
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
                              'Have an account ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.to(() => const Login()),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                minimumSize: const Size(100, 40),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                ' Login Here',
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
                    const SizedBox(height: 100.0)
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
