import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_app/models/this_user.dart';

class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final galleriesCollection =
      FirebaseFirestore.instance.collection('galleries');

  String _uid = '';
  String get uid => _uid;

  String? returnMessage;

  Future<bool> addNewUser(newUserDetails) async {
    try {
      await usersCollection
          .doc(newUserDetails.uid)
          .set({'id': newUserDetails.uid, 'email': newUserDetails.email});
      print('Successfully added new user');
      try {
        await galleriesCollection.add({'user_id': newUserDetails.uid});
        print('successfully added new gallery');
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  String currentUserId() {
    _uid = "";
    print('getting current user');
    //add error handeling

    //want to pull this from authenticationService but throwing error during set up
    //why?
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      _uid = user.uid;
      print('current user id: $_uid');
    }

    return _uid;
  }

  Future<ThisUser?> getUserData() async {
    try {
      var userID = currentUserId();
      if (userID.length > 1) {
        QuerySnapshot querySnapshot = await usersCollection.get();
        print(querySnapshot);

        var userQuerySnapshot = await usersCollection.doc(userID).get();
        var userDocument = ThisUser.fromSnapshot(userQuerySnapshot);
        print('user document $userDocument');
        return userDocument;
      } else {
        return null;
      }
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
