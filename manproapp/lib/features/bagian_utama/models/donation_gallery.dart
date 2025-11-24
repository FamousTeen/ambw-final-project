import 'package:flutter/foundation.dart';
import 'package:manpro/utils/constants/api_constants.dart';

class DonationGallery {
  final int id;
  final String imageUrl;
  final String? caption;

  DonationGallery({
    required this.id,
    required this.imageUrl,
    this.caption,
  });

  factory DonationGallery.fromJson(Map<String, dynamic> json) {
    String imgUrl = json['image_url'];
    if (kIsWeb) {
      if (imgUrl.contains('localhost:8000/storage/')) {
        imgUrl = imgUrl.replaceFirst('storage/', 'api/public-image/');
      } else if (!imgUrl.startsWith('http')) {
        imgUrl = '${url}public-image/$imgUrl';
      }
    }

    return DonationGallery(
      id: json['id'],
      imageUrl: imgUrl,
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'caption': caption,
    };
  }
} 