import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_app/models/this_user.dart';

class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  String? returnMessage;

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

      //var userJson = userDocument.toJson();
      //print(userJson);

      //userSnapshot = ThisUser.fromSnapshot(userQuerySnapshot);

      // Get data from docs and convert map to List
      //need to remove this collection of all data
      //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      //final userData = allData[0] as Map;
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

  Future getUserGallery() async {
    try {
      var user = _firebaseAuth.currentUser;
      var userUID = user?.uid;
      var docRef = db.collection("users").doc(userUID);
      docRef.get().then(
        (DocumentSnapshot doc) {
          final userData = doc.data() as Map<String, dynamic>;
          print("User data from doc snapshot: $userData");
          var email = userData['email'];
          return email;
        },
        onError: (e) => print("Error getting document: $e"),
      );

      return userUID;
    } catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      return returnMessage;
    }
  }
}
