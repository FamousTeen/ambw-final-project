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
    return DonationGallery(
      id: json['id'],
      imageUrl: json['image_url'],
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