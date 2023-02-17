import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_app/models/this_user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  String? returnMessage;

  Future<bool> signIn(String email, String password) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print(e); // change this to a message to show in a snack bar
      returnMessage = e.toString();
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      var newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (newUser.user != null) {
        try {
          await db
              .collection('users')
              .doc(newUser.user!.uid)
              .set({'email': newUser.user!.email});
          return true;
          //add on firebase exception
        } catch (e) {
          print(e);
          return false;
        }
      }
      return false;
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        returnMessage =
            'The password provided is too weak.'; // change this to a message
      } else if (e.code == 'email=already-in-use') {
        returnMessage =
            'An account already exists for that email.'; // change this to a message
      }
      return false;
    } catch (e) {
      print(e);
      returnMessage = e.toString();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseException catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      return false;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      var user = await _firebaseAuth.currentUser;
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      return false;
    }
  }

  Future getUserData() async {
    try {
      var user = _firebaseAuth.currentUser;
      var uid = user?.uid;

      QuerySnapshot querySnapshot = await usersCollection.get();

      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      final userData = allData[0] as Map;
      var userEmail = userData['email'];
      print(userEmail);

      return userData;
    } catch (e) {
      return e as String;
    }
  }

  Future getUserAuthData() async {
    try {
      var user = _firebaseAuth.currentUser;
      print(user);
      var userEmail = user?.email;
      var userName = user?.displayName;
      var avatar = user?.photoURL;
      var userData = {
        'email': userEmail,
        'userName': userName,
        'avatar': avatar,
      };
      print(userData);
      return userData;
    } catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      return returnMessage;
    }
  }

  Future<bool> changeUpdateUser(ThisUser thisUser) async {
    var user = _firebaseAuth.currentUser;
    var userUID = user?.uid;
    await db.collection("users").doc(userUID).update(thisUser.toJson());
    return false;
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
