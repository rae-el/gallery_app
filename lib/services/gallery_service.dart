import 'dart:io';

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
            await galleriesCollection.where('user_id', isEqualTo: userID).get();
        print('gallery query snapshot $querySnapshot');
        for (var docSnapshot in querySnapshot.docs) {
          print('docsnapshot: $docSnapshot');
          galleries.add(Gallery.fromSnapshot(docSnapshot));
        }
        //get first gallery (should only be 1)
        //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
        //final userData = allData[0] as Map;
        int numOfGalleries = galleries.length;
        print('There are $numOfGalleries that match this user ID');
        if (numOfGalleries == 0) {
          //if 0 create gallery
          print('no galleries that meet query, ');
          //var newUserGallery = createNewGallery(userID);
          //do some error handeling
          return null;
        }
        if (numOfGalleries == 1) {
          Gallery userGallery = galleries[0];
          print('got data for $userGallery');
          return userGallery;
        } else {
          print('number of galleries too high, return null');
          return null;
        }
      } catch (e) {
        print(e);
        print('failed in querying galleries collection');
        return null;
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
        var imagesQuerySnapshot = await galleriesCollection
            .doc(galleryId)
            .collection("images")
            .orderBy('date', descending: true)
            .get();
        //convert images query snapshot to a list of images?
        for (var docSnapshot in imagesQuerySnapshot.docs) {
          ThisImage imageDocSnapshot = ThisImage.fromSnapshot(docSnapshot);
          String path = imageDocSnapshot.path;
          //print(imageDocSnapshot.id);
          //why is this all the sudden throwing exception and not handleing it
          if (await File(path).exists()) {
            galleryImages.add(imageDocSnapshot);
          } else {
            print('did not add $imageDocSnapshot');
          }
        }
        //validate gallery Images
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
      var docRef = await galleriesCollection.add({'user_id': userID});
      print('create new gallery');
      if (docRef != null) {
        var docSnap = await galleriesCollection.doc(docRef.id).get();
        var newGallery = Gallery.fromSnapshot(docSnap);
        print('add new gallery to list');
        return newGallery;
      }
      print('doc ref null');
      return null;
    } catch (e) {
      print(e);
      print('failed to create new gallery');
      return null;
    }
  }

  Future<bool> addImageToGallery(ThisImage image, String galleryID) async {
    //validate path
    if (await File(image.path).exists()) {
      //convert image to json
      var jsonImg = image.toJson();
      print('try adding image $jsonImg to gallery');
      if (galleryID != null) {
        //gallery exisits
        await galleriesCollection
            .doc(galleryID)
            .collection("images")
            .add(jsonImg)
            .then((value) =>
                print('added document reference to images collection $value'));
        return true;
      } else {
        print('failed adding image to gallery');
        return false;
      }
    } else {
      print('path invalid could not add image');
      return false;
    }
  }
}
