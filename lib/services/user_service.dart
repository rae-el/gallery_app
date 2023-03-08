import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_app/models/this_user.dart';

class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  String? returnMessage;

  Future<bool> createNewUser(newUserDetails) async {
    try {
      await usersCollection
          .doc(newUserDetails.uid)
          .set({'id': newUserDetails.uid, 'email': newUserDetails.email});
      print('Successfully added new user');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  String? currentUser() {
    //add error handeling
    var user = _firebaseAuth.currentUser;
    var uid = user?.uid;
    return uid;
  }

  Future<ThisUser?> getUserData() async {
    try {
      var userID = currentUser() as String;

      QuerySnapshot querySnapshot = await usersCollection.get();
      print(querySnapshot);

      var userQuerySnapshot = await usersCollection.doc(userID).get();
      var userDocument = ThisUser.fromSnapshot(userQuerySnapshot);
      print('user document $userDocument');
      return userDocument;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> updateUser(ThisUser thisUser) async {
    var user = thisUser.toJson();
    print(user);
    var uid = user['id'];
    print(uid);
    try {
      await usersCollection.doc(uid).update(user);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
