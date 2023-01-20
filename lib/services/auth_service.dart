import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user != null;
    } catch (e) {
      print(e); // change this to a message
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      var signUpResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return signUpResult.user != null;
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.'); // change this to a message
      } else if (e.code == 'email=already-in-use') {
        print(
            'An account already exists for that email.'); // change this to a message
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      var user = await _firebaseAuth.currentUser;
      return user != null;
    } catch (e) {
      print(e); // change this to a message
      return false;
    }
  }
}
