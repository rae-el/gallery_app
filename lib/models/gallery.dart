import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_app/models/this_image.dart';

class Gallery {
  final String? id;
  final String? user_id;
  //final List<Image>? images;

  Gallery({
    this.id,
    required this.user_id,
    //this.images,
  });

  toJson() {
    return {
      "user_id": user_id,
      //"images": images,
    };
  }

  factory Gallery.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    final dataId = document.id;
    return Gallery(
      id: dataId,
      user_id: data["user_id"],
      //images: data["images"],
    );
  }

  static Gallery fromJson(Map<String, dynamic> json) => Gallery(
        id: json['id'],
        user_id: json['user_id'],
        //images: (json['images']! as List).cast<Image>(),
        //images: List<Image>.from(json['images']),
      );
}
