import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
      var signUpResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
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
      return true;
    } on FirebaseException catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      return false;
    }
  }

  Future getUserDetails() async {
    try {
      var user = await _firebaseAuth.currentUser;
      var userDetails = {};
      userDetails['username'] = user?.displayName;
      userDetails['email'] = user?.email;
      userDetails['photo'] = user?.photoURL;
      //need to create a description or have this as part of the gallery db
      //userDetails['description'] = user?.;

      return userDetails;
    } catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      return returnMessage;
    }
  }
}
