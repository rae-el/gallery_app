import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_app/services/user_service.dart';

import '../app/app.locator.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  final userService = locator<UserService>();

  String _returnMessage = '';
  String get returnMessage => _returnMessage;

  User? _user;
  User? get user => _user;

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
      await userService.addNewUser(newUser);
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

  User? currentUser() {
    print('getting current user');
    //add error handeling
    _user = _firebaseAuth.currentUser;
    return _user;
  }

  Future<bool> isUserLoggedIn() async {
    try {
      _user = currentUser();
      if (user != null) {
        return true;
      } else {
        _returnMessage = 'No user';
        return false;
      }
    } on FirebaseException catch (e) {
      print(e); // change this to a message
      _returnMessage = e.toString();
      return false;
    }
  }

  Future changePassword({required String newPassword}) async {
    try {
      _user = currentUser();
      await _user?.updatePassword(newPassword).then((value) {
        print('successful password update');
        return true;
      }).catchError((e) {
        print(e);
        switch (e) {
          case 'weak-password':
            _returnMessage = 'The password provided is too weak.';
            return false;
          case 'requires-recent-login':
            _returnMessage = 'Please sign out before trying again';
            return false;
          default:
            _returnMessage = 'Problem changing your password, please try again';
            return false;
        }
      });
    } catch (e) {
      print(e);
      _returnMessage = 'Problem changing your password, please try again';
      return false;
    }
  }
}
