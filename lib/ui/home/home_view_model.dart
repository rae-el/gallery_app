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
import '../../app/messages.dart';
import '../../enums/basic_dialog_status.dart';
import '../../enums/dialog_type.dart';
import '../../models/this_image.dart';
import '../../models/this_user.dart';
import '../../services/auth_service.dart';
import '../../services/gallery_service.dart';
import '../../services/user_service.dart';

class HomeViewModel extends BaseViewModel implements Initialisable {
  final _navigationService = locator<NavigationService>();
  final _galleryService = locator<GalleryService>();
  final _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();

  Gallery? _userGallery;

  String _galleryId = "";
  String get galleryId => _galleryId;

  String _username = "";
  String get username => _username;

  List<ThisImage>? _galleryImages;
  List<ThisImage>? get galleryImages => _galleryImages;

  List<String> _galleryImagePaths = [];
  List<String> get galleryImagePaths => _galleryImagePaths;

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
      var i = image.toJson();
      print('navigate to view of $i');
      _navigationService.navigateTo(Routes.imageView,
          arguments: ImageViewArguments(image: image));
      //navigationService.navigateToImageView(image: image);
    } else {
      _navigationService.navigateTo(Routes.homeView);
    }
  }

  Future<bool> askForGalleryData() async {
    ThisUser? userData = await _userService.getUserData();
    print('got data for $userData');

    if (userData != null) {
      _username = userData.username ?? "";
    } else {
      //do some error handeling
      showRetrievingGalleryError();
    }
    //this will automatically happen
    //setBusy(true);
    print('asking for gallery data');
    _userGallery = await _galleryService.getUserGallery();
    if (_userGallery != null) {
      _galleryId = _userGallery!.id ?? "";
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
          _galleryImages = null;
          _galleryImagePaths = [];
          return true;
        }
      } else {
        print('gallery id nul');
        showRetrievingGalleryError();
        return false;
      }
    } else {
      print('user gallery null');
      showRetrievingGalleryError();
      return false;
    }
  }

  showRetrievingGalleryError() async {
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.error,
      title: errorTitle,
      description: 'There was a problem retrieving your gallery',
      mainButtonTitle: 'OK',
    );
    return dialogResult;
  }

  showAddingImageError() async {
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.error,
      title: errorTitle,
      description:
          'There was a problem adding the image to your gallery, please try again',
      mainButtonTitle: 'OK',
    );
    return dialogResult;
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
        return;
      } else {
        _navigationService.back();
        String? newImagePath = image.path;
        bool addNewImage = await addImage(newImagePath);
        if (addNewImage) {
          print('successfully added image and resent query');
          notifyListeners();
          //why is this no longer updating the view?????
          return;
        } else {
          showAddingImageError();
          return;
        }
      }
    } on PlatformException catch (e) {
      print(e);
      showAddingImageError();
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
          showAddingImageError();
          return false;
        }
      } else {
        showAddingImageError();
        return false;
      }
    } catch (e) {
      print(e);
      showAddingImageError();
      return false;
    }
  }

  onReorder({required int oldIndex, required int newIndex}) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ThisImage item = galleryImages!.removeAt(oldIndex);
    galleryImages!.insert(newIndex, item);
  }

  //gesture functions
  //double tap, add / remove from liked
  //tap, navigate to image view
  //long hold, option to delete (maybe)
  //drag, reorder (maybe)
}
