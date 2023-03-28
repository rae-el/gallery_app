import 'package:cloud_firestore/cloud_firestore.dart';

class ThisImage {
  String? id;
  final String path;
  bool favourite;
  final Timestamp date;
  int? preferredIndex;

  ThisImage({
    this.id,
    required this.path,
    required this.favourite,
    required this.date,
    required this.preferredIndex,
  });

  toJson() {
    return {
      "path": path,
      "favourite": favourite,
      "date": date,
      "preferred_index": preferredIndex,
    };
  }

  static ThisImage fromJson(Map<String, dynamic> json) => ThisImage(
        path: json['path'],
        favourite: json['favourite'],
        date: json['date'],
        preferredIndex: json['preferred_index'],
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
      preferredIndex: data["preferred_index"],
    );
  }
}
