class DonationType {
  final int id;
  final String name;

  DonationType({
    required this.id,
    required this.name,
  });

  factory DonationType.fromJson(Map<String, dynamic> json) {
    return DonationType(
      id: json['id'],
      name: json['name'],
    );
  }
}