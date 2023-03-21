import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_app/models/gallery.dart';
import 'package:gallery_app/models/this_image.dart';
import 'package:gallery_app/services/gallery_service.dart';
import 'package:gallery_app/services/user_service.dart';

import '../app/app.locator.dart';

class ImageService {
  final galleriesCollection =
      FirebaseFirestore.instance.collection('galleries');
  final galleryService = locator<GalleryService>();

  String returnMessage = '';

  ThisImage? thisImage;

  Future imageInGallery(String? imageId) async {
    if (imageId != null) {
      String? currentGallery = await galleryService.getGalleryID();
      if (currentGallery != null) {
        var imageQuerySnapshot = await galleriesCollection
            .doc(currentGallery)
            .collection("images")
            .doc(imageId)
            .get();

        thisImage = ThisImage.fromSnapshot(imageQuerySnapshot);
        return thisImage;
      }
    }
  }

  Future updateFavourite(String? imageId, bool fave) async {
    if (imageId != null) {
      String? currentGallery = await galleryService.getGalleryID();
      if (currentGallery != null) {
        var imagesQuerySnapshot = await galleriesCollection
            .doc(currentGallery)
            .collection("images")
            .doc(imageId)
            .update({'favourite': fave})
            .then((value) => print('updated favourite'))
            .onError((error, stackTrace) => returnMessage = error as String);
        return returnMessage;
      }
    } else {
      returnMessage = 'Image ID Null';
      return returnMessage;
    }
  }

  deleteImage() {}
}
