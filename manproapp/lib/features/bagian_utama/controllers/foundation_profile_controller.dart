import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/constants/api_constants.dart';
import '../Models/foundation_profile.dart';

class FoundationProfileController {
  Future<FoundationProfile> getProfile() async {
    try {
      final response = await http.get(Uri.parse('${url}foundation-profile'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          return FoundationProfile.fromJson(data['data']);
        }
      }
      throw Exception('Failed to load foundation profile');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 