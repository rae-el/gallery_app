import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ThisImage {
  final String? id;
  final String path;
  final bool favourite;
  final Timestamp date;
  int? preferred_index;

  ThisImage({
    this.id,
    required this.path,
    required this.favourite,
    required this.date,
    required this.preferred_index,
  });

  toJson() {
    return {
      "id": id,
      "path": path,
      "favourite": favourite,
      "date": date,
      "preferred_index": preferred_index,
    };
  }

  static ThisImage fromJson(Map<String, dynamic> json) => ThisImage(
        path: json['path'],
        favourite: json['favourite'],
        date: json['date'],
        preferred_index: json['preferred_index'],
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
      preferred_index: data["preferred_index"],
    );
  }
}
