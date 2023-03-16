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

  final String _errorMessage = 'ERROR';
  String get errorMessage => _errorMessage;

  final userService = locator<UserService>();
  final _dialogService = locator<DialogService>();

  Future<bool> signIn(String email, String password) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseException catch (e) {
      print(e);
      if (e.code == 'invalid-email') {
        _returnMessage = 'The email you provided is invalid';
      } else if (e.code == 'user-disabled') {
        _returnMessage = 'This account is currently disabled';
      } else if (e.code == 'user-not-found') {
        _returnMessage = 'This user could not be found';
      } else if (e.code == 'wrong-password') {
        _returnMessage = 'Incorrect password, please try again';
      } else {
        print(e);
        _returnMessage = 'Could not sign you in, please try again';
      }
      showSignInError(_returnMessage);
      return false;
    } catch (e) {
      print(e);
      _returnMessage = 'Could not sign you in, please try again';
      showSignInError(_returnMessage);
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e); // change this to a message
      showSignOutError();
      return false;
    }
  }

  Future showSignInError(String description) async {
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.error,
      title: errorTitle,
      description: description,
      mainButtonTitle: 'OK',
    );
    return dialogResult;
  }

  Future showSignUpError(String description) async {
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.error,
      title: errorTitle,
      description: description,
      mainButtonTitle: 'OK',
    );
    return dialogResult;
  }

  Future showSignOutError() async {
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.error,
      title: errorTitle,
      description: 'Problem logging you out, please try again',
      mainButtonTitle: 'OK',
    );
    return dialogResult;
  }

  Future signUp(String email, String password) async {
    try {
      //create user
      var newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (newUser.user != null) {
        //add user to collection
        try {
          var newUserDetails = newUser.user!;
          if (await userService.createNewUser(newUserDetails) == true) {
            try {
              //sign user in
              await _firebaseAuth.signInWithEmailAndPassword(
                email: email,
                password: password,
              );
              return '';
            } catch (e) {
              print(e);

              _returnMessage = 'Could not sign in new user';
              showSignUpError(_returnMessage);
              return _errorMessage;
            }
          }
        } catch (e) {
          print(e);
          _returnMessage = 'Could not create new user';
          showSignUpError(_returnMessage);
          return _errorMessage;
        }
      }
      return false;
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        _returnMessage =
            'The password provided is too weak.'; // change this to a message
      } else if (e.code == 'email-already-in-use') {
        _returnMessage =
            'An account already exists for that email.'; // change this to a message
      } else if (e.code == 'invalid-email') {
        _returnMessage =
            'Email provided is invalid'; // change this to a message
      } else {
        print(e);
        _returnMessage = 'Could not create new user';
        showSignUpError(_returnMessage);
        return _errorMessage;
      }
      return _returnMessage;
    } catch (e) {
      print(e);
      _returnMessage = 'Could not create new user';
      showSignUpError(_returnMessage);
      return _errorMessage;
    }
  }

  Future forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      final dialogResult = await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.warning,
        title: warningTitle,
        description:
            'Please check your email to finish resetting your password',
        mainButtonTitle: 'OK',
      );
      return dialogResult;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        _returnMessage = 'Invalid Email, please try again';
        return _returnMessage;
      } else if (e.code == 'auth/user-not-found') {
        _returnMessage =
            'User not found, please check your email and try again';
        return _returnMessage;
      } else {
        final dialogResult = await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.error,
          title: errorTitle,
          description: 'Could not reset password',
          mainButtonTitle: 'OK',
        );
        return dialogResult;
      }
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
      _returnMessage = e.toString();
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
      _returnMessage = e.toString();
      return _returnMessage;
    }
  }

  Future changePassword({required String newPassword}) async {
    try {
      var user = _firebaseAuth.currentUser;
      print('change password for user $user');
      await user?.updatePassword(newPassword).then((value) {
        print('success');
        return '';
      }).catchError((e) {
        if (e.code == 'weak-password') {
          _returnMessage = 'The password provided is too weak.';
        } else if (e.code == 'requires-recent-login') {
          _returnMessage = 'Please sign out before trying again';
        } else {
          _returnMessage = 'Problem changing your password, please try again';
        }
        return _errorMessage;
      });
      return _errorMessage;
    } catch (e) {
      print(e);
      _returnMessage = 'Problem changing your password, please try again';
      return _returnMessage;
    }
  }
}
