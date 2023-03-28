import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_app/models/this_user.dart';
import 'package:gallery_app/services/user_service.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/messages.dart';
import '../enums/basic_dialog_status.dart';
import '../enums/dialog_type.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  String _returnMessage = '';
  String get returnMessage => _returnMessage;

  final userService = locator<UserService>();

  Future signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (e) {
      print(e);
      switch (e.code) {
        case 'invalid-email':
          _returnMessage = 'The email you provided is invalid';
          return _returnMessage;
        case 'user-disabled':
          _returnMessage = 'This account is currently disabled';
          return _returnMessage;
        case 'user-not-found':
          _returnMessage = 'This user could not be found';
          return _returnMessage;
        case 'wrong-password':
          _returnMessage = 'Incorrect password, please try again';
          return _returnMessage;
        default:
          _returnMessage = 'Could not sign you in, please try again';
          return _returnMessage;
      }
    } catch (e) {
      _returnMessage = 'Could not sign you in, please try again';
      return _returnMessage;
    }
  }

  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      _returnMessage = e.toString();
      return _returnMessage;
    }
  }

  Future createNewUser(
      {required String email, required String password}) async {
    try {
      //create user
      var newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (newUser != null) {
        await userService.addNewUser(newUser);
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'weak-password':
          _returnMessage = 'The password provided is too weak.';
          return _returnMessage;
        case 'email-already-in-use':
          _returnMessage = 'An account already exists for that email.';
          return _returnMessage;
        case 'invalid-email':
          _returnMessage = 'Email provided is invalid';
          return _returnMessage;
        default:
          _returnMessage = 'Could not create new user';
          return _returnMessage;
      }
    }
  }

  Future forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _returnMessage =
          'Please check your email to finish resetting your password';
      return _returnMessage;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'auth/invalid-email':
          _returnMessage = 'Invalid Email, please try again';
          return _returnMessage;
        case 'auth/user-not-found':
          _returnMessage =
              'User not found, please check your email and try again';
          return _returnMessage;
        default:
          _returnMessage = 'Could not reset password';
          return _returnMessage;
      }
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        return true;
      } else {
        _returnMessage = 'No user';
        print('null user');
        return false;
      }
    } on FirebaseException catch (e) {
      print(e); // change this to a message
      //_returnMessage = e.toString();
      return false;
    }
  }

  User? currentUser() {
    print('getting current user');
    //add error handeling
    var user = _firebaseAuth.currentUser;
    return user;
  }

  Future changePassword({required String newPassword}) async {
    try {
      var user = _firebaseAuth.currentUser;
      await user?.updatePassword(newPassword).then((value) {
        print('successful password update');
        return;
      }).catchError((e) {
        switch (e) {
          case 'weak-password':
            _returnMessage = 'The password provided is too weak.';
            return _returnMessage;
          case 'requires-recent-login':
            _returnMessage = 'Please sign out before trying again';
            return _returnMessage;
          default:
            _returnMessage = 'Problem changing your password, please try again';
            return _returnMessage;
        }
      });
    } catch (e) {
      print(e);
      _returnMessage = 'Problem changing your password, please try again';
      return _returnMessage;
    }
  }
}
