import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/donation_goal.dart';
import '../../../utils/constants/api_constants.dart';

class DonationGoalController extends GetxController {
  RxList<DonationGoal> goals = <DonationGoal>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDonationGoals();
  }

  Future<void> fetchDonationGoals() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await http.get(Uri.parse('${url}donation-goals'));
      
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        print('API Response: ${response.body}'); // Debug print
        
        if (decodedResponse['status'] == 'success' && decodedResponse['data'] != null) {
          final List<dynamic> goalsData = decodedResponse['data'];
          goals.value = goalsData.map((goal) => DonationGoal.fromJson(goal)).toList();
        } else {
          error.value = decodedResponse['message'] ?? 'Failed to load donation goals';
        }
      } else {
        error.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      print('Error fetching goals: $e'); // Debug print
      error.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
} 