import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/donation_gallery.dart';
import '../../../utils/constants/api_constants.dart';

class DonationGalleryController {
  Future<List<DonationGallery>> getGalleryImages({int? page, int? limit}) async {
    try {
      final queryParams = {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'per_page': limit.toString(),
      };

      final uri = Uri.parse('${url}donation-gallery').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          return (data['data'] as List)
              .map((json) => DonationGallery.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load gallery images');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 