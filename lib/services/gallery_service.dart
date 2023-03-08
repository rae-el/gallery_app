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
    print('in get user gallery');
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
      int numOfGalleries = galleries.length;
      print('There are $numOfGalleries that match this ID');
      //should i make this length an error check?
      Gallery userGallery = galleries[0];
      print('got data for $userGallery');

      if (userGallery != null) {
        return userGallery;
      } else {
        //if null create gallery
        print('no galleries that make query, create new gallery');
        var newUserGallery = createNewGallery();

        //do some error handeling
        return newUserGallery;
      }
    } catch (e) {
      print(e); // change this to a message
      returnMessage = e.toString();
      print(returnMessage);
      return null;
    }
  }

  String? getGalleryID() {
    print('in get gallery id');
    try {
      Gallery userGallery = getUserGallery() as Gallery;
      if (userGallery != null) {
        String? galleryID = userGallery.id;
        print('gallery id: $galleryID');
        return galleryID;
      } else {
        //do some error handeling
        print('user gallery null, failed to retreive gallery id');
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

  Future<Gallery?> createNewGallery() async {
    print('in create new gallery');
    var userID = userService.currentUser;
    //create new gallery with userid
    try {
      var docRef = await galleriesCollection.add({'id': userID});
      var docSnap = await galleriesCollection.doc(docRef.id).get();
      var newGallery = Gallery.fromSnapshot(docSnap);
      return newGallery;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> addImageToGallery(Image image) async {
    //convert image to json
    var jsonImg = image.toJson();
    print('try adding image $jsonImg to gallery');
    //get gallery id and create if not exists
    String? galleryID = getGalleryID();
    if (galleryID != null) {
      //gallery exisits
      await galleriesCollection
          .doc(galleryID)
          .collection("images")
          .add(jsonImg);
      return true;
    } else {
      print('failed adding image to gallery');
      return false;
    }
  }
}
