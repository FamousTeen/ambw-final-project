class PostModel {
  int? id;
  String? content;
  bool? liked;
  UserModel? user;
  String? createdAt;

  PostModel({
    this.id,
    this.content,
    this.liked,
    this.user,
    this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    print('Post JSON: $json'); // Debug print
    return PostModel(
      id: json['id'],
      content: json['content'],
      liked: json['liked'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: json['created_at'],
    );
  }
}

class UserModel {
  int? id;
  String? username;
  String? email;

  UserModel({
    this.id,
    this.username,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing user: $json');
      return UserModel(
        id: json['id'],
        username: json['username'] ?? json['nama_lengkap'] ?? json['name'] ?? 'Unknown User',
        email: json['email'] ?? '',
      );
    } catch (e) {
      print('Error parsing user: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email)';
  }
}

class CommentModel {
  int? id;
  String? body;
  UserModel? user;
  String? createdAt;

  CommentModel({
    this.id,
    this.body,
    this.user,
    this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing comment: $json');
      return CommentModel(
        id: json['id'],
        body: json['body'],
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
        createdAt: json['created_at'],
      );
    } catch (e) {
      print('Error parsing comment: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'CommentModel(id: $id, body: $body, user: $user, createdAt: $createdAt)';
  }
} 