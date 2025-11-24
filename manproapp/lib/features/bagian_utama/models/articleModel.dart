import 'package:manpro/utils/constants/api_constants.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Article {
  final int id;
  final String title;
  final String date;
  final String image;
  final String content;
  final String isAsset;
  final List<String>? additionalImages;

  Article({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
    required this.content,
    required this.isAsset,
    this.additionalImages,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    // Helper to process image URL
    String processImageUrl(String? imgPath) {
      if (imgPath == null || imgPath.isEmpty) return '';

      // Fix for CORS on localhost:8000 (php artisan serve)
      if (kIsWeb) {
        if (imgPath.contains('localhost:8000/storage/')) {
          return imgPath.replaceFirst('storage/', 'api/public-image/');
        }
        if (!imgPath.startsWith('http')) {
           return '${url}public-image/$imgPath';
        }
      }

      if (imgPath.startsWith('http')) return imgPath;

      // Remove /api/ from the base url to get the root url
      String baseUrl = url;
      if (url.endsWith('/api/')) {
        baseUrl = url.substring(0, url.length - 4);
      } else if (url.endsWith('/api')) {
        baseUrl = url.substring(0, url.length - 3);
      }

      if (!baseUrl.endsWith('/')) {
        baseUrl = '$baseUrl/';
      }

      String cleanImgPath = imgPath;
      if (cleanImgPath.startsWith('/')) {
        cleanImgPath = cleanImgPath.substring(1);
      }

      final finalUrl = '$baseUrl$cleanImgPath';
      print('Processed Article image URL: $imgPath -> $finalUrl');
      return finalUrl;
    }

    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      image: processImageUrl(json['image']),
      content: json['content'] ?? '',
      isAsset: json['isAsset'] ?? 'false',
      additionalImages: _parseAdditionalImages(json['additional_images'])
          ?.map((img) => processImageUrl(img))
          .toList(),
    );
  }

  static List<String>? _parseAdditionalImages(dynamic value) {
    if (value == null) return null;

    try {
      if (value is String) {
        // Try to parse JSON string
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return List<String>.from(decoded);
        }
        return null;
      } else if (value is List) {
        // Direct list
        return List<String>.from(value);
      }
    } catch (e) {
      print('Error parsing additional_images: $e');
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'image': image,
      'content': content,
      'isAsset': isAsset,
      'additional_images': additionalImages,
    };
  }
}
