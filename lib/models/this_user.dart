import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

class ThisUser {
  final String? email;
  final String? username;
  final String? description;
  final String? picture;
  final List<String>? gallery;

  ThisUser({
    this.email,
    this.username,
    this.description,
    this.picture,
    this.gallery,
  });

  factory ThisUser.fromFirestore(
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
  }
}
