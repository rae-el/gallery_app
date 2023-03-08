import 'package:cloud_firestore/cloud_firestore.dart';

class ThisUser {
  final String? id;
  final String? email;
  final String? username;
  final String? description;
  final String? avatar;

  ThisUser({
    required this.id,
    required this.email,
    required this.username,
    required this.description,
    required this.avatar,
  });

  toJson() {
    return {
      "id": id,
      "email": email,
      "username": username,
      "description": description,
      "avatar": avatar
    };
  }

  factory ThisUser.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ThisUser(
        id: data["id"],
        email: data["email"],
        username: data["username"],
        description: data["description"],
        avatar: data["avatar"]);
  }

  static ThisUser fromJson(Map<String, dynamic> json) => ThisUser(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      description: json['description'],
      avatar: json['avatar']);
}
