import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:manpro/features/bagian_utama/models/contactModel.dart';
import 'package:manpro/utils/constants/api_constants.dart';

class ContactController extends GetxController {
  final isLoading = false.obs;
  final Rxn<Contact> contact = Rxn<Contact>();
  final _apiUrl = '${url}contact';

  @override
  void onInit() {
    super.onInit();
    fetchContact();
  }

  Future<void> fetchContact() async {
    try {
      isLoading.value = true;
      final response = await _getContactFromApi();
      _handleResponse(response);
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<http.Response> _getContactFromApi() async {
    return await http.get(
      Uri.parse(_apiUrl),
      headers: {'Accept': 'application/json'},
    );
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['data'];
      contact.value = Contact.fromJson(jsonData);
    } else {
      _showErrorSnackbar('Gagal memuat informasi kontak');
    }
  }

  void _handleError(dynamic error) {
    debugPrint('Error getting contact: $error');
    _showErrorSnackbar('Terjadi kesalahan saat memuat kontak');
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}