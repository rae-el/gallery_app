import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_app/models/gallery.dart';
import 'package:gallery_app/models/image.dart';
import 'package:gallery_app/services/user_service.dart';

import '../app/app.locator.dart';

class GalleryService {
  final galleriesCollection =
      FirebaseFirestore.instance.collection('galleries');
  final userService = locator<UserService>();

  String? returnMessage;

  Future<Gallery?> getUserGallery() async {
    try {
      List<Gallery> galleries = [];
      var userID = userService.currentUser;
      print('Getting user $userID gallery');
      var querySnapshot =
          await galleriesCollection.where('id', isEqualTo: userID).get();
      for (var docSnapshot in querySnapshot.docs) {
        galleries.add(Gallery.fromSnapshot(docSnapshot));
      }
      //get first gallery (should only be 1)
      //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      //final userData = allData[0] as Map;
      Gallery userGallery = galleries[0];
      print('got data for $userGallery');

      if (userGallery != null) {
        return userGallery;
      } else {
        //do some error handeling
        return null;
      }
    } catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      print(returnMessage);
      return null;
    }
  }

  Future<List<Image>?> getGalleryImages() async {
    try {
      Gallery userGallery = getUserGallery() as Gallery;
      if (userGallery != null) {
        List<Image>? images = userGallery.images;
        print('listing images: $images');
        return images;
      } else {
        //do some error handeling
        return null;
      }
    } catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      print(returnMessage);
      return null;
    }
  }

  Future<bool> addImageToGallery(Image image) async {
    Gallery? gallery = getUserGallery() as Gallery;
    if (gallery != null) {
      //gallery exisits
      return false;
    } else {
      try {
        //gallery does not exist
        var userID = userService.currentUser;
        await galleriesCollection.add({'id': userID, 'images': image});
        return false;
      } catch (e) {
        print(e);
        return false;
      }
    }
  }
}
