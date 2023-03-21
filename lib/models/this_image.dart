import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ThisImage {
  final String? id;
  final String path;
  final bool favourite;
  final Timestamp date;

  ThisImage({
    this.id,
    required this.path,
    required this.favourite,
    required this.date,
  });

  toJson() {
    return {
      "id": id,
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
    final dataId = document.id;
    return ThisImage(
      id: dataId,
      path: data["path"],
      favourite: data["favourite"],
      date: data["date"],
    );
  }
}
