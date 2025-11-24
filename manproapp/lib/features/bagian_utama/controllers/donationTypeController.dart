import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:manpro/features/bagian_utama/models/donationTypeModel.dart';
import 'package:manpro/utils/constants/api_constants.dart';

class DonationTypeController extends GetxController {
  final isLoading = false.obs;
  final donationTypes = <DonationType>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getDonationTypes();
  }

  Future<void> getDonationTypes() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${url}donation-types'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        donationTypes.value = data.map((json) => DonationType.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting donation types: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createDonationType(String name) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await http.post(
        Uri.parse('${url}donation-types'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'name': name},
      );

      if (response.statusCode == 201) {
        getDonationTypes();
        Get.back();
        Get.snackbar(
          'Success',
          'Donation type created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw json.decode(response.body)['message'];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDonationType(int id, String name) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await http.put(
        Uri.parse('${url}donation-types/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'name': name},
      );

      if (response.statusCode == 200) {
        getDonationTypes();
        Get.back();
        Get.snackbar(
          'Success',
          'Donation type updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw json.decode(response.body)['message'];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDonationType(int id) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await http.delete(
        Uri.parse('${url}donation-types/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        getDonationTypes();
        Get.snackbar(
          'Success',
          'Donation type deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw json.decode(response.body)['message'];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}