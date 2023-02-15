import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_app/models/this_user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
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
      /*var userUID = user?.uid;
      print(userUID);
      if (userUID != null) {
        print("Getting data for user $userUID");
        try {
          var docRef = db.collection("users").doc(userUID);
          docRef.get().then(
            (DocumentSnapshot doc) {
              var userData = doc.data() as Map<String, dynamic>;
              print("User data from doc snapshot: $userData");
              return userData;
            },
            onError: (e) => print("Error getting document: $e"),
          );
          return userUID;
          //add on firebase exception
        } catch (e) {
          print(e);
          returnMessage = e.toString();
          return returnMessage;
        }
      }*/
    } catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      return returnMessage;
    }
  }

  Future<String?> getUserEmail() async {
    try {
      var user = await _firebaseAuth.currentUser;
      var userUID = user?.uid;
      var userEmail = user?.email;

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

      return userEmail;
    } catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      return returnMessage;
    }
  }
}
