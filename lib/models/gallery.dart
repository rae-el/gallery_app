import 'package:cloud_firestore/cloud_firestore.dart';

class Gallery {
  final String? id;
  final String? userId;
  //final List<Image>? images;

  Gallery({
    this.id,
    required this.userId,
    //this.images,
  });

  toJson() {
    return {
      "user_id": userId,
      //"images": images,
    };
  }

  factory Gallery.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    final dataId = document.id;
    return Gallery(
      id: dataId,
      userId: data["user_id"],
      //images: data["images"],
    );
  }

  static Gallery fromJson(Map<String, dynamic> json) => Gallery(
        id: json['id'],
        userId: json['user_id'],
        //images: (json['images']! as List).cast<Image>(),
        //images: List<Image>.from(json['images']),
      );
}
