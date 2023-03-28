import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_app/models/this_user.dart';

import '../app/app.locator.dart';
import 'auth_service.dart';

class UserService {
  //deals with user collection
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final galleriesCollection =
      FirebaseFirestore.instance.collection('galleries');
  final authService = locator<AuthenticationService>();
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

  Future<ThisUser?> getUserData() async {
    try {
      var userID = authService.currentUser() as String;

      QuerySnapshot querySnapshot = await usersCollection.get();
      print(querySnapshot);

      var userQuerySnapshot = await usersCollection.doc(userID).get();
      var userDocument = ThisUser.fromSnapshot(userQuerySnapshot);
      print('user document $userDocument');
      return userDocument;
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
