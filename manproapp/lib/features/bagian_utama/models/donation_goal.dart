class DonationGoal {
  final int id;
  final String type;
  final int targetQuantity;
  final int currentQuantity;
  final int percentage;

  DonationGoal({
    required this.id,
    required this.type,
    required this.targetQuantity,
    required this.currentQuantity,
    required this.percentage,
  });

  factory DonationGoal.fromJson(Map<String, dynamic> json) {
    try {
      return DonationGoal(
        id: json['id'] ?? 0,
        type: json['type'] ?? '',
        targetQuantity: json['target_quantity'] ?? 0,
        currentQuantity: json['current_quantity'] ?? 0,
        percentage: json['percentage'] ?? 0,
      );
    } catch (e) {
      print('Error parsing DonationGoal: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'DonationGoal(id: $id, type: $type, targetQuantity: $targetQuantity, currentQuantity: $currentQuantity, percentage: $percentage)';
  }
} 