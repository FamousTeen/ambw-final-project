class FoundationProfile {
  final String description;

  FoundationProfile({
    required this.description,
  });

  factory FoundationProfile.fromJson(Map<String, dynamic> json) {
    return FoundationProfile(
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
} 