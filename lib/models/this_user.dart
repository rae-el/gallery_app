import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

class ThisUser {
  final String? id;
  final String? email;
  final String? username;
  final String? description;
  //changed avatar from string to xfile, will this cause a database error
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

  /*factory ThisUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ThisUser(
      email: data?['email'],
      username: data?['username'],
      description: data?['description'],
      picture: data?['picture'],
      gallery:
          data?['gallery'] is Iterable ? List.from(data?['gallery']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "email": email,
      if (username != null) "username": username,
      if (description != null) "description": description,
      if (picture != null) "picture": picture,
      if (gallery != null) "gallery": gallery,
    };
  }

  getUser() async {
    var user = _firebaseAuth.currentUser;
    var uid = user?.uid;
    final userRef = db.collection("users").doc(uid).withConverter(
          fromFirestore: ThisUser.fromFirestore,
          toFirestore: (ThisUser thisUser, _) => thisUser.toFirestore(),
        );
    final userSnap = await userRef.get();
    final userData = userSnap.data();
    if (userData != null) {
      print(userData);
      return userData;
    } else {
      print("No such user.");
      return "";
    }
  }*/
}
