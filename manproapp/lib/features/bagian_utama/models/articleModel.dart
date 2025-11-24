import 'dart:convert';

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
    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      image: json['image'] ?? '',
      content: json['content'] ?? '',
      isAsset: json['isAsset'] ?? 'false',
      additionalImages: _parseAdditionalImages(json['additional_images']),
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
