import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:manpro/features/bagian_awal/tampilan/login/login.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/api_constants.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  /// Try using a cached session without hitting the network (useful offline).
  Future<void> tryAutoLoginWithCache() async {
    final savedToken = box.read('token');
    if (savedToken != null && savedToken.toString().isNotEmpty) {
      token.value = savedToken.toString();
      Get.offAll(() => const Navbar());
    }
  }

  Future register({
    required String nama_lengkap,
    required String username,
    required String email,
    required String kota_asal,
    required String no_telpon,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        "nama_lengkap": nama_lengkap,
        "username": username,
        "email": email,
        "kota_asal": kota_asal,
        "no_telpon": no_telpon,
        "password": password,
      };

      var response = await http.post(
        Uri.parse('${url}register'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => const Login());
        Get.snackbar('Success', 'Akun berhasil dibuat',
            margin: const EdgeInsets.only(bottom: 10.0),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        isLoading.value = false;
        Get.snackbar('Error', json.decode(response.body)['message'],
            margin: const EdgeInsets.only(bottom: 10.0),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future login({
    required String username,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        "username": username,
        "password": password,
      };

      var response = await http.post(
        Uri.parse('${url}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      print('Login response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        isLoading.value = false;
        token.value = responseData['token'];
        box.write('token', token.value);

        // Store user data
        if (responseData['user'] != null) {
          box.write('user', responseData['user']);
          print('Stored user data: ${responseData['user']}');
        }

        Get.offAll(() => const Navbar());
      } else {
        isLoading.value = false;
        Get.snackbar('Error', json.decode(response.body)['message'],
            margin: const EdgeInsets.only(bottom: 10.0),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print(json.decode(response.body));
      }
    } catch (e) {
      // If offline or request fails, allow fallback to cached token.
      final savedToken = box.read('token');
      if (savedToken != null && savedToken.toString().isNotEmpty) {
        token.value = savedToken.toString();
        Get.snackbar(
          'Offline',
          'Using saved session',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        Get.offAll(() => const Navbar());
      } else {
        Get.snackbar('Error', 'Login failed. Check connection.',
            margin: const EdgeInsets.only(bottom: 10.0),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future forgetPassword({
    required String email,
    required String password,
    required String password_confirmation,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        "email": email,
        "password": password,
        "password_confirmation": password_confirmation,
      };

      var response = await http.post(
        Uri.parse('${url}forget-password'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.offAll(() => const Login());
        Get.snackbar('Success', 'Password berhasil diubah',
            margin: const EdgeInsets.only(bottom: 10.0),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        isLoading.value = false;
        Get.snackbar('Error', json.decode(response.body)['message'],
            margin: const EdgeInsets.only(bottom: 10.0),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('${url}logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}'
        },
      );

      if (response.statusCode == 200) {
        box.remove('token');
        box.remove('user');

        Get.snackbar(
          'Success',
          'Successfully logged out',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAll(() => const Login());
      } else {
        Get.snackbar(
          'Error',
          'Failed to logout',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
