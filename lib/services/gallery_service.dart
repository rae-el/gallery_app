import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_app/models/gallery.dart';
import 'package:gallery_app/models/this_image.dart';
import 'package:gallery_app/services/auth_service.dart';
import 'package:gallery_app/services/user_service.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';

class GalleryService {
  final log = getLogger('GalleryService');
  final galleriesCollection =
      FirebaseFirestore.instance.collection('galleries');
  final userService = locator<UserService>();
  final authService = locator<AuthenticationService>();

  String? returnMessage;

  String? _galleryID;

  String _userID = "";

  Future<Gallery?> getUserGallery() async {
    log.i('in get user gallery');
    try {
      List<Gallery> galleries = [];
      //should this current user be more of a state or global variable
      _userID = userService.currentUserId();
      log.i('Getting user $_userID gallery');
      try {
        var querySnapshot = await galleriesCollection
            .where('user_id', isEqualTo: _userID)
            .get();
        log.i('gallery query snapshot $querySnapshot');
        for (var docSnapshot in querySnapshot.docs) {
          log.i('docsnapshot: $docSnapshot');
          galleries.add(Gallery.fromSnapshot(docSnapshot));
        }
        //get first gallery (should only be 1)
        //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
        //final userData = allData[0] as Map;
        int numOfGalleries = galleries.length;
        log.i('There are $numOfGalleries that match this user ID');
        if (numOfGalleries == 0) {
          //if 0 create gallery
          log.i('no galleries that meet query, ');
          //var newUserGallery = createNewGallery(userID);
          //do some error handeling
          return null;
        }
        if (numOfGalleries == 1) {
          Gallery userGallery = galleries[0];
          log.i('got data for $userGallery');
          return userGallery;
        } else {
          log.i('number of galleries too high, return null');
          return null;
        }
      } catch (e) {
        log.e(e);
        log.i('failed in querying galleries collection');
        return null;
      }
    } catch (e) {
      log.e(e); // change this to a message
      returnMessage = e.toString();
      log.i(returnMessage);
      return null;
    }
  }

  Future<String?> getGalleryID() async {
    log.i('in get gallery id');
    try {
      Gallery? userGallery = await getUserGallery();
      if (userGallery != null) {
        _galleryID = userGallery.id ?? "";
        log.i('gallery id: $_galleryID');
        return _galleryID;
      } else {
        //do some error handeling
        log.i('user gallery null, failed to retreive gallery id');
        return null;
      }
    } catch (e) {
      log.e(e); // change this to a message
      returnMessage = e.toString();
      log.i(returnMessage);
      return null;
    }
  }

  Future<List<ThisImage>?> getGalleryImages(String galleryId) async {
    List<ThisImage> galleryImages = [];
    try {
      var imagesQuerySnapshot = await galleriesCollection
          .doc(galleryId)
          .collection('images')
          .orderBy('preferred_index')
          .get();
      //convert images query snapshot to a list of images?
      for (var docSnapshot in imagesQuerySnapshot.docs) {
        ThisImage imageDocSnapshot = ThisImage.fromSnapshot(docSnapshot);
        String? path = imageDocSnapshot.path;
        //print(imageDocSnapshot.id);
        //why is this all the sudden throwing exception and not handleing it
        if (path.isNotEmpty) {
          try {
            if (await File(path).exists()) {
              galleryImages.add(imageDocSnapshot);
            } else {
              log.i('did not add $imageDocSnapshot');
            }
          } on PathNotFoundException {
            log.i('did not add $imageDocSnapshot');
          } catch (e) {
            log.i('did not add $imageDocSnapshot');
          }
        }
      }
      //validate gallery Images
      return galleryImages;
    } catch (e) {
      log.e(e); // change this to a message
      returnMessage = e.toString();

      return null;
    }
  }

  Future<Gallery?> createNewGallery(String userID) async {
    log.i('in create new gallery');
    //create new gallery with userid
    try {
      var docRef = await galleriesCollection.add({'user_id': userID});
      log.i('create new gallery');
      var docSnap = await galleriesCollection.doc(docRef.id).get();
      var newGallery = Gallery.fromSnapshot(docSnap);
      log.i('add new gallery to list');
      return newGallery;
    } catch (e) {
      log.e(e);
      log.i('failed to create new gallery');
      return null;
    }
  }

  Future addImageToGallery(ThisImage image, String galleryID) async {
    //validate path
    if (await File(image.path).exists()) {
      //convert image to json
      var jsonImg = image.toJson();
      log.i('try adding image $jsonImg to gallery');
      var addedImage = await galleriesCollection
          .doc(galleryID)
          .collection('images')
          .add(jsonImg);
      await galleriesCollection
          .doc(galleryID)
          .collection('images')
          .doc(addedImage.id)
          .update({'id': addedImage.id});

      return addedImage.id;
    } else {
      log.i('path invalid could not add image');
      return false;
    }
  }

  Future<bool> reorderGallery(List<ThisImage>? reorderedGalleryImages) async {
    log.i('in gallery service reorder');
    _galleryID = await getGalleryID();
    log.i('Gallery id $_galleryID');
    log.i(reorderedGalleryImages);
    if (_galleryID != null && reorderedGalleryImages!.length > 1) {
      //gallery exisits
      await galleriesCollection
          .doc(_galleryID)
          .collection('images')
          .get()
          .then((value) {
        for (DocumentSnapshot snapshot in value.docs) {
          snapshot.reference.delete();
        }
      });
      for (var image in reorderedGalleryImages) {
        var jsonImg = image.toJson();
        try {
          await galleriesCollection
              .doc(_galleryID)
              .collection('images')
              .doc(image.id)
              .set(jsonImg);
        } catch (e) {
          log.e(e);
          return false;
        }
      }

      return true;
    } else {
      log.i('failed reordering gallery');
      return false;
    }
  }
}
