import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:manpro/features/bagian_utama/Tampilan/profile/profile.dart';
import 'package:manpro/utils/constants/api_constants.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final userData = {}.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      print('Token: ${box.read('token')}');

      final response = await http.get(
        Uri.parse('${url}profile'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}'
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        userData.value = json.decode(response.body)['user'];
      } else {
        Get.snackbar(
          'Error',
          'Failed to load profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error getting profile: $e');
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

  Future<void> updateProfile({
    required String namaLengkap,
    required String username,
    required String email,
    required String kotaAsal,
    required String noTelpon,
  }) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('${url}profile/update'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}'
        },
        body: {
          'nama_lengkap': namaLengkap,
          'username': username,
          'email': email,
          'kota_asal': kotaAsal,
          'no_telpon': noTelpon,
        },
      );

      if (response.statusCode == 200) {
        userData.value = json.decode(response.body)['user'];
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.off(() => const Profile());
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
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
