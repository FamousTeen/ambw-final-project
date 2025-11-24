class ShippingMethod {
  final int id;
  final String name;

  ShippingMethod({
    required this.id,
    required this.name,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) {
    return ShippingMethod(
      id: json['id'],
      name: json['name'],
    );
  }
}