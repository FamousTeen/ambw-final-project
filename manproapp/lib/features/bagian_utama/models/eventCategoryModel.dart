class EventCategory {
  final int id;
  final String name;
  final String slug;

  EventCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}