import 'package:cloud_firestore/cloud_firestore.dart';

class Image {
  final String? path;
  final bool favourite;
  final Timestamp date;

  Image({
    required this.path,
    required this.favourite,
    required this.date,
  });

  Map<String, dynamic> toMap(Image image) {
    return {
      "path": path,
      "favourite": favourite,
      "date": date,
    };
  }

  static Image fromJson(Map<String, dynamic> json) => Image(
        path: json['path'],
        favourite: json['favourite'],
        date: json['date'],
      );
}
