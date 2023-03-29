import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_app/models/this_user.dart';

import '../app/app.logger.dart';

class UserService {
  final log = getLogger('UserService');
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
      log.i('Successfully added new user');
      try {
        await galleriesCollection.add({'user_id': newUserDetails.uid});
        log.i('successfully added new gallery');
        return true;
      } catch (e) {
        log.e(e);
        return false;
      }
    } catch (e) {
      log.e(e);
      return false;
    }
  }

  String currentUserId() {
    _uid = "";
    log.i('getting current user');
    //add error handeling

    //want to pull this from authenticationService but throwing error during set up
    //why?
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      _uid = user.uid;
      log.i('current user id: $_uid');
    }

    return _uid;
  }

  Future<ThisUser?> getUserData() async {
    try {
      var userID = currentUserId();
      if (userID.length > 1) {
        QuerySnapshot querySnapshot = await usersCollection.get();
        log.i(querySnapshot);

        var userQuerySnapshot = await usersCollection.doc(userID).get();
        var userDocument = ThisUser.fromSnapshot(userQuerySnapshot);
        log.i('user document $userDocument');
        return userDocument;
      } else {
        return null;
      }
    } catch (e) {
      log.e(e);
      return null;
    }
  }

  Future<bool> updateUser(ThisUser thisUser) async {
    var user = thisUser.toJson();
    log.i(user);
    var uid = user['id'];
    log.i(uid);
    try {
      await usersCollection.doc(uid).update(user);
      return true;
    } catch (e) {
      log.i(e.toString());
      return false;
    }
  }
}
