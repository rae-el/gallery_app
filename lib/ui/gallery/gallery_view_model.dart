import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/messages.dart';
import '../../enums/basic_dialog_status.dart';
import '../../enums/dialog_type.dart';
import '../../models/gallery.dart';
import '../../models/this_image.dart';
import '../../models/this_user.dart';
import '../../services/auth_service.dart';
import '../../services/gallery_service.dart';
import '../../services/image_service.dart';
import '../../services/user_service.dart';

class GalleryViewModel extends BaseViewModel implements Initialisable {
  final _navigationService = locator<NavigationService>();
  final _galleryService = locator<GalleryService>();
  final _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();
  final _imageService = locator<ImageService>();

  Gallery? _userGallery;

  String _galleryId = "";
  String get galleryId => _galleryId;

  String _username = "";
  String get username => _username;

  List<ThisImage>? _galleryImages;
  List<ThisImage>? get galleryImages => _galleryImages;

  List<ThisImage>? _galleryImagesShown;
  List<ThisImage>? get galleryImagesShown => _galleryImagesShown;

  List<String> _galleryImagePaths = [];
  List<String> get galleryImagePaths => _galleryImagePaths;

  List<ThisImage>? _preferredOrder;
  List<ThisImage>? get preferredOrder => _preferredOrder;

  String? id;

  bool faveIcon = false;

  @override
  void initialise() async {
    runBusyFuture(askForGalleryData());
  }

  Future navigateToProfile() async {
    //_galleryService.reorderGallery(galleryImages!);
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
      _navigationService.navigateTo(Routes.galleryView);
    }
  }

  Future<bool> askForGalleryData() async {
    ThisUser? userData = await _userService.getUserData();
    print('got data for $userData');

    if (userData != null) {
      _username = userData.username ?? "";
      print('got username $_username');
      //this will automatically happen
      //setBusy(true);
      print('asking for gallery data');
      _userGallery = await _galleryService.getUserGallery();
      if (_userGallery != null) {
        _galleryId = _userGallery!.id ?? "";
        print('gallery id: $_galleryId');

        if (_galleryId != null) {
          _galleryImages = null;
          _galleryImagesShown = null;
          _galleryImagePaths = [];
          _galleryImages = await _galleryService.getGalleryImages(_galleryId);
          if (_galleryImages == null || _galleryImages!.isEmpty) {
            print('gallery images empty');
            return true;
          } else {
            print('adding gallery image paths to list');
            //reset to empty list
            _galleryImagesShown = [];
            //only add if path exists
            for (var galleryImage in _galleryImages!) {
              _galleryImagePaths.add(galleryImage.path);

              _galleryImagesShown!.add(galleryImage);
            }

            return true;
          }
        } else {
          print('gallery id nul');
          _navigationService.clearStackAndShow(Routes.authView);
          return false;
        }
      } else {
        _navigationService.clearStackAndShow(Routes.authView);
        return false;
      }
    } else {
      _navigationService.clearStackAndShow(Routes.authView);
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
    print('add image to gallery $_galleryId');
    try {
      ThisImage image = ThisImage(
          path: path,
          favourite: false,
          date: Timestamp.now(),
          preferred_index: 0);
      bool addedImage =
          await _galleryService.addImageToGallery(image, _galleryId);
      if (addedImage) {
        if (_galleryImages == null || _galleryImages!.isEmpty) {
          askForGalleryData();
        } else {
          _galleryImagesShown!.insert(0, image);
          notifyListeners();
        }

        return true;
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
    int index = 0;

    final ThisImage item = _galleryImagesShown!.removeAt(oldIndex);
    _galleryImagesShown!.insert(newIndex, item);

    notifyListeners();

    if (_galleryImagesShown!.length > 1) {
      for (var image in _galleryImagesShown!) {
        image.preferred_index = index;
        index++;
      }
    }
  }

  Future reorderAcending() async {
    int index = 0;
    _galleryImagesShown!.sort((a, b) => a.date.compareTo(b.date));

    notifyListeners();
    if (_galleryImagesShown!.length > 1) {
      for (var image in _galleryImagesShown!) {
        image.preferred_index = index;
        index++;
      }
      //_galleryService.reorderGallery(galleryImages!);
    }
  }

  Future reorderDecending() async {
    int index = 0;
    _galleryImagesShown!.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
    if (_galleryImagesShown!.length > 1) {
      for (var image in _galleryImagesShown!) {
        image.preferred_index = index;
        index++;
      }
      //_galleryService.reorderGallery(galleryImages!);
    }
  }

  Future filterFavourites() async {
    List<ThisImage> _favouriteImages = [];
    for (var image in _galleryImagesShown!) {
      if (image.favourite == true) {
        _favouriteImages.add(image);
      }
    }

    if (_galleryImagesShown!.length == _favouriteImages.length) {
      _galleryImagesShown = _galleryImages!;
    } else {
      _galleryImagesShown = _favouriteImages;
    }

    notifyListeners();
    return;
  }

  Future saveOrder() async {
    if (_galleryImages!.length == _galleryImagesShown!.length) {
      var reorderResult =
          await _galleryService.reorderGallery(_galleryImagesShown!);
      if (reorderResult) {
        await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.success,
          title: successTitle,
          description: 'Saved your new order',
          mainButtonTitle: 'OK',
        );
      } else {
        await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.error,
          title: errorTitle,
          description:
              'There was a problem saving your order, please try again',
          mainButtonTitle: 'OK',
        );
      }
    }
  }

  Future toggleFavourite({required ThisImage image}) async {
    id = image.id;
    print('toggle fave');
    faveIcon = !faveIcon;
    for (var imageShown in _galleryImagesShown!) {
      if (imageShown.id == image.id) {
        imageShown.favourite = !imageShown.favourite;
      }
    }
    notifyListeners();
    //update in firebase
    requestFavouriteToggle(image: image);
    bool favourite = !image.favourite;
    if (id != null) {
    } else {
      print('id null');
      await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: 'We cannot update your favourite status',
        mainButtonTitle: 'OK',
      );
    }
  }

  Future requestFavouriteToggle({required ThisImage image}) async {
    String? update =
        await _imageService.updateFavourite(image.id, image.favourite);
    if (update == '') {
      updateImage(image: image);
    } else {
      await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: 'We cannot update your favourite status',
        mainButtonTitle: 'OK',
      );
    }
  }

  Future updateImage({required ThisImage image}) async {
    await _galleryService.getGalleryImages(_galleryId);
    id = image.id;
    image = await _imageService.imageInGallery(id);
  }

  //gesture functions
  //double tap, add / remove from liked
  //tap, navigate to image view
  //long hold, option to delete (maybe)
  //drag, reorder (maybe)
}
