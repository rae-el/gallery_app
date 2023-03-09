import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ThisImage {
  final String path;
  final bool favourite;
  final Timestamp date;

  ThisImage({
    required this.path,
    required this.favourite,
    required this.date,
  });

  toJson() {
    return {
      "path": path,
      "favourite": favourite,
      "date": date,
    };
  }

  static ThisImage fromJson(Map<String, dynamic> json) => ThisImage(
        path: json['path'],
        favourite: json['favourite'],
        date: json['date'],
      );

  factory ThisImage.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ThisImage(
      path: data["path"],
      favourite: data["favourite"],
      date: data["date"],
    );
  }
}
