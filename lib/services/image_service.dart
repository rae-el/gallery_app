import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_app/models/gallery.dart';
import 'package:gallery_app/models/this_image.dart';
import 'package:gallery_app/services/gallery_service.dart';
import 'package:gallery_app/services/user_service.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/messages.dart';
import '../enums/basic_dialog_status.dart';
import '../enums/dialog_type.dart';

class ImageService {
  final galleriesCollection =
      FirebaseFirestore.instance.collection('galleries');
  final galleryService = locator<GalleryService>();
  final _dialogService = locator<DialogService>();

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
            .then((value) => returnMessage = '')
            .onError((error, stackTrace) => returnMessage = error as String);
        return returnMessage;
      }
    } else {
      returnMessage = 'Image ID Null';
      return returnMessage;
    }
  }

  Future requestDeleteImage({required String imageId}) async {
    print('reached delete service');
    String? currentGallery = await galleryService.getGalleryID();
    await galleriesCollection
        .doc(currentGallery)
        .collection("images")
        .doc(imageId)
        .delete()
        .then((value) => returnMessage = '')
        .onError((error, stackTrace) => returnMessage = error as String);
    return returnMessage;
  }
}
