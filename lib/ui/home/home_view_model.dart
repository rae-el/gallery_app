import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_app/models/gallery.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../models/this_image.dart';
import '../../services/auth_service.dart';
import '../../services/gallery_service.dart';

class HomeViewModel extends BaseViewModel implements Initialisable {
  final _navigationService = locator<NavigationService>();
  final _galleryService = locator<GalleryService>();

  String _galleryId = "";
  String get galleryId => _galleryId;

  List<ThisImage>? _galleryImages = [];
  List<ThisImage>? get galleryImages => _galleryImages;

  List<String> _galleryImagePaths = [];
  List<String> get galleryImagePaths => _galleryImagePaths;

  List<Image>? _myImages = [];
  List<Image>? get myImages => _myImages;

  String _imagePath = "";
  String get imagePath => _imagePath;

  @override
  void initialise() async {
    runBusyFuture(askForGalleryData());
  }

  Future navigateToProfile() async {
    _navigationService.navigateTo(Routes.profileView);
  }

  Future navigateToImageView({required ThisImage image}) async {
    print('navigate to image view');
    if (image != null) {
      _navigationService.navigateTo(Routes.imageView,
          arguments: ImageViewArguments(image: image));
      //navigationService.navigateToImageView(image: image);
    } else {
      _navigationService.navigateTo(Routes.homeView);
    }
  }

  Future<bool> askForGalleryData() async {
    //this will automatically happen
    //setBusy(true);
    print('asking for gallery data');
    Gallery? userGallery = await _galleryService.getUserGallery();
    if (userGallery != null) {
      _galleryId = userGallery.id ?? "";
      print('gallery id: $_galleryId');

      if (_galleryId != null) {
        _galleryImages = await _galleryService.getGalleryImages(_galleryId);
        if (_galleryImages!.isNotEmpty) {
          print('adding gallery image paths to list');
          //reset to empty list
          _galleryImagePaths = [];
          //only add if path exists
          for (var galleryImage in _galleryImages!) {
            _galleryImagePaths.add(galleryImage.path);
          }
          return true;
        } else {
          print('gallery images empty');
          return false;
        }
      } else {
        print('gallery id nul');
        return false;
      }
    } else {
      print('user gallery null');
      return false;
    }
  }

  createImages() {
    /*
    List<Hero> imageHeros = <Hero>[];
    List<Widget> empty = [const Text("Sorry you have no images yet!")];
    if (_galleryImages == null) {
      print('You have no pictures yet!');
      return empty;
    } else {
      Hero? imageHero;
      for (ThisImage createImage in _galleryImages!) {
        try {
          imageHero = Hero(
            tag: createImage,
            child: Image.file(File(imagePath)),
          );
          imageHeros.add(imageHero);
        } catch (e) {
          print(e);
        }
      }
      print('returning heros');
      return imageHeros;
      */

    List<Widget> imageBlocks = <Widget>[];
    if (_galleryImagePaths.isEmpty) {
      return Text('You have no pictures yet!');
    } else {
      Widget? imageBlock;
      for (String imagePath in _galleryImagePaths) {
        try {
          if (File(imagePath).existsSync()) {
            imageBlock = GestureDetector(
              child: Image.file(File(imagePath)),
            );
            imageBlocks.add(imageBlock);
          } else {
            print('image $imagePath not added');
          }
        } catch (e) {
          print(e);
        }
      }
      return imageBlocks;
    }
  }

  //mostly repeated code, can i reduce or move?
  Future? openPicker({required String source}) async {
    ImagePicker picker = ImagePicker();
    XFile? image;
    if (source == "gallery") {
      image = await picker.pickImage(source: ImageSource.gallery);
    }
    if (source == "camera") {
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      print('source not set');
      return;
    }
    try {
      if (image == null) {
        print('image null');
        return;
      } else {
        _navigationService.back();
        String? newImagePath = image.path;
        bool addNewImage = await addImage(newImagePath);
        if (addNewImage) {
          print('successfully added image and resent query');
          notifyListeners();
          return;
        } else {
          print("didn't add new image");
          return;
        }
      }
    } on PlatformException catch (e) {
      print(e);
      return;
    }
  }

  //repeated code, can i reduce or move?
  Future<void> openPickerDialog(context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select an Image'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                await openPicker(source: 'gallery');
              },
              child: const Text('Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                await openPicker(source: 'camera');
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> addImage(String path) async {
    try {
      ThisImage image =
          ThisImage(path: path, favourite: false, date: Timestamp.now());
      bool addedImage =
          await _galleryService.addImageToGallery(image, _galleryId);
      if (addedImage) {
        print('added image now resend query');
        bool resendQuery = await askForGalleryData();
        if (resendQuery) {
          print('resent query');
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<String> getMyStream() async* {
    List<ThisImage>? myGalleryImages =
        await _galleryService.getGalleryImages(_galleryId);
    if (myGalleryImages!.isNotEmpty) {
      for (ThisImage galleryImage in myGalleryImages) {
        print(galleryImage.path);
        yield galleryImage.path;
      }
    }
  }

  //gesture functions
  //double tap, add / remove from liked
  //tap, navigate to image view
  //long hold, option to delete (maybe)
  //drag, reorder (maybe)
}
