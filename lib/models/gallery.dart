import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_app/models/image.dart';

class Gallery {
  final String? id;
  final List<Image>? images;

  Gallery({
    required this.id,
    this.images,
  });

  toJson() {
    return {
      "id": id,
      "images": images,
    };
  }

  factory Gallery.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Gallery(
      id: data["id"],
      images: data["images"],
    );
  }

  static Gallery fromJson(Map<String, dynamic> json) => Gallery(
        id: json['id'],
        images: (json['images']! as List).cast<Image>(),
        //images: List<Image>.from(json['images']),
      );
}
