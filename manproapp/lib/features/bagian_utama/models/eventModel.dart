import 'package:manpro/features/bagian_utama/models/eventCategoryModel.dart';
import 'dart:convert';

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
    print('Parsing event JSON for ID: ${json['id']}');
    
    return Event(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      date: json['date'],
      time: json['time'] ?? '',
      createdAt: json['created_at'],
      registrationsCount: json['registrations_count'] ?? 0,
      capacity: json['capacity'],
      additionalImages: _parseAdditionalImages(json['additional_images']),
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
