class DonationModel {
  final int? id;
  final String type;
  final String quantity;
  final String shippingMethod;
  final String notes;
  final String? status;
  final String? createdAt;

  DonationModel({
    this.id,
    required this.type,
    required this.quantity,
    required this.shippingMethod,
    required this.notes,
    this.status = 'pending',
    this.createdAt,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'],
      type: json['type'],
      quantity: json['quantity'].toString(),
      shippingMethod: json['shippingMethod'] ?? json['shipping_method'],
      notes: json['notes'] ?? '-',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final RegExp numberRegex = RegExp(r'\d+');
    final match = numberRegex.firstMatch(quantity);
    final numberOnly = match != null ? match.group(0) : quantity;

    return {
      'type': type,
      'quantity': numberOnly,
      'shipping_method': shippingMethod,
      'notes': notes,
      'status': status,
    };
  }

  bool get isPending => status?.toLowerCase() == 'pending';
  bool get isAccepted => status?.toLowerCase() == 'accepted';
  bool get isSuccess => status?.toLowerCase() == 'success';
  bool get isFailed => status?.toLowerCase() == 'failed';

  String get formattedDate {
    if (createdAt == null) return '-';
    try {
      // Convert to local time (WIB if user is in Indonesia)
      final date = DateTime.parse(createdAt!).toLocal();
      // Pad minutes with 0 for better formatting (e.g. 10:05 instead of 10:5)
      final minute = date.minute.toString().padLeft(2, '0');
      return '${date.day}/${date.month}/${date.year} ${date.hour}:$minute';
    } catch (e) {
      return createdAt!;
    }
  }
}
