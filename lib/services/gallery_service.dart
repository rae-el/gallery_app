import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_app/models/gallery.dart';
import 'package:gallery_app/models/this_image.dart';
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
      //should this current user be more of a state or global variable
      var userID = userService.currentUser() as String;
      print('Getting user $userID gallery');
      try {
        var querySnapshot =
            await galleriesCollection.where('id', isEqualTo: userID).get();
        print('gallery query snapshot $querySnapshot');
        for (var docSnapshot in querySnapshot.docs) {
          print('docsnapshot: $docSnapshot');
          galleries.add(Gallery.fromSnapshot(docSnapshot));
        }
      } catch (e) {
        print(e);
        print('failed in querying galleries collection');
      }

      //get first gallery (should only be 1)
      //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      //final userData = allData[0] as Map;
      int numOfGalleries = galleries.length;
      print('There are $numOfGalleries that match this ID');
      if (numOfGalleries > 0) {
        Gallery userGallery = galleries[0];
        print('got data for $userGallery');
        return userGallery;
      } else {
        //if null create gallery
        print('no galleries that make query, create new gallery');
        var newUserGallery = createNewGallery(userID);

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

  Future<String?> getGalleryID() async {
    print('in get gallery id');
    try {
      Gallery? userGallery = await getUserGallery();
      if (userGallery != null) {
        String? galleryID = userGallery.id ?? "";
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

  Future<List<ThisImage>?> getGalleryImages(String galleryId) async {
    List<ThisImage> galleryImages = [];
    try {
      if (galleryId != null) {
        var imagesQuerySnapshot =
            await galleriesCollection.doc(galleryId).collection("images").get();
        //convert images query snapshot to a list of images?
        for (var imagesDocSnapshot in imagesQuerySnapshot.docs) {
          galleryImages.add(ThisImage.fromSnapshot(imagesDocSnapshot));
        }
        print(galleryImages);
        return galleryImages;
      } else {
        print('gallery id null');
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

  Future<Gallery?> createNewGallery(String userID) async {
    print('in create new gallery');
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

  Future<bool> addImageToGallery(ThisImage image, String galleryID) async {
    //convert image to json
    var jsonImg = image.toJson();
    print('try adding image $jsonImg to gallery');
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
