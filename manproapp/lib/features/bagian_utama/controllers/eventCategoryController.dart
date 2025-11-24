import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:manpro/utils/constants/api_constants.dart';
import 'package:manpro/features/bagian_utama/models/eventCategoryModel.dart';

class EventCategoryController extends GetxController {
  final box = GetStorage();
  final categories = <EventCategory>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${url}event-categories'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        categories.value = data.map((json) => EventCategory.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }
}