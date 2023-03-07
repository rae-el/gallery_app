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
      //create user
      var newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (newUser.user != null) {
        //add user to collection
        try {
          await db
              .collection('users')
              .doc(newUser.user!.uid)
              .set({'id': newUser.user!.uid, 'email': newUser.user!.email});
          try {
            //sign user in
            await _firebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
            return true;
          } catch (e) {
            returnMessage = e.toString();
            print(returnMessage);
            return false;
          }
          //add on firebase exception
        } catch (e) {
          returnMessage = e.toString();
          print(returnMessage);
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
}
