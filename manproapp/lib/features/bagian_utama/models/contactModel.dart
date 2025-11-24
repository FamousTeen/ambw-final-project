class Contact {
  final String alamat;
  final String email;
  final String noTelp;

  Contact({
    required this.alamat,
    required this.email,
    required this.noTelp,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      alamat: json['alamat'] ?? '',
      email: json['email'] ?? '',
      noTelp: json['no_telp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alamat': alamat,
      'email': email,
      'no_telp': noTelp,
    };
  }
}