import 'package:manpro/features/bagian_utama/models/eventCategoryModel.dart';
import 'package:manpro/utils/constants/api_constants.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Model untuk merepresentasikan sebuah event
class Event {
  // =========== PROPERTIES ===========
  final int id;
  final String title;
  final String content;
  final String image;
  final String date;
  final String time;
  final String createdAt;
  final int registrationsCount;
  final int? capacity;
  final List<String>? additionalImages;
  final EventCategory? category;
  final String status;

  // =========== CONSTRUCTOR ===========
  Event({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.date,
    required this.time,
    required this.createdAt,
    this.registrationsCount = 0,
    this.capacity,
    this.additionalImages,
    this.category,
    required this.status,
  });

  // =========== FACTORY METHODS ===========
  /// Membuat instance Event dari JSON
  factory Event.fromJson(Map<String, dynamic> json) {
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
      // url is defined in api_constants.dart e.g. 'http://10.0.2.2:8000/api/'
      String baseUrl = url;
      if (url.endsWith('/api/')) {
        baseUrl = url.substring(
            0, url.length - 4); // remove 'api/' but keep trailing slash
      } else if (url.endsWith('/api')) {
        baseUrl = url.substring(0, url.length - 3);
      }

      // Ensure baseUrl ends with /
      if (!baseUrl.endsWith('/')) {
        baseUrl = '$baseUrl/';
      }

      // Ensure imgPath does not start with /
      String cleanImgPath = imgPath;
      if (cleanImgPath.startsWith('/')) {
        cleanImgPath = cleanImgPath.substring(1);
      }

      final finalUrl = '$baseUrl$cleanImgPath';
      print('Processed image URL: $imgPath -> $finalUrl');
      return finalUrl;
    }

    return Event(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: processImageUrl(json['image']),
      date: json['date'],
      time: json['time'] ?? '',
      createdAt: json['created_at'],
      registrationsCount: json['registrations_count'] ?? 0,
      capacity: json['capacity'],
      additionalImages: _parseAdditionalImages(json['additional_images'])
          ?.map((img) => processImageUrl(img))
          .toList(),
      category: json['category'] != null
          ? EventCategory.fromJson(json['category'])
          : null,
      status: json['status'] ?? 'upcoming',
    );
  }

  // =========== HELPER METHODS ===========
  /// Parse additional images dari berbagai format yang mungkin
  static List<String>? _parseAdditionalImages(dynamic value) {
    if (value == null) return null;

    try {
      if (value is String) {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return List<String>.from(decoded);
        }
        return null;
      } else if (value is List) {
        return List<String>.from(value);
      } else if (value is String && value.startsWith('[')) {
        final decoded = jsonDecode(value);
        return List<String>.from(decoded);
      }
    } catch (e) {
      print('Error parsing additional_images: $e');
    }
    return null;
  }

  // =========== STATUS GETTERS ===========
  /// Mengecek apakah event sudah selesai
  bool get isCompleted => status.toLowerCase() == 'completed';

  /// Mengecek apakah event sedang berlangsung
  bool get isOngoing => status.toLowerCase() == 'ongoing';

  /// Mengecek apakah event akan datang
  bool get isUpcoming => status.toLowerCase() == 'upcoming';

  // =========== REGISTRATION GETTERS ===========
  /// Mengecek apakah event sudah penuh
  bool get isFull => capacity != null && registrationsCount >= capacity!;

  /// Mengecek apakah masih bisa mendaftar ke event
  bool get canRegister => isUpcoming && !isFull;

  // =========== JSON CONVERSION ===========
  /// Mengkonversi Event ke format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image': image,
      'date': date,
      'time': time,
      'created_at': createdAt,
      'registrations_count': registrationsCount,
      'capacity': capacity,
      'additional_images': additionalImages,
      'category': category?.toJson(),
      'status': status,
    };
  }
}

/// Model untuk merepresentasikan registrasi event
class EventRegistration {
  // =========== PROPERTIES ===========
  final int id;
  final int eventId;
  final int userId;
  final String name;
  final String email;
  final Event? event;

  // =========== CONSTRUCTOR ===========
  EventRegistration({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.name,
    required this.email,
    this.event,
  });

  // =========== FACTORY METHODS ===========
  /// Membuat instance EventRegistration dari JSON
  factory EventRegistration.fromJson(Map<String, dynamic> json) {
    return EventRegistration(
      id: json['id'],
      eventId: json['event_id'],
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
    );
  }

  // =========== JSON CONVERSION ===========
  /// Mengkonversi EventRegistration ke format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'user_id': userId,
      'name': name,
      'email': email,
      'event': event?.toJson(),
    };
  }
}
