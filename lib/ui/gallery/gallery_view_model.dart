import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../app/messages.dart';
import '../../enums/basic_dialog_status.dart';
import '../../enums/dialog_type.dart';
import '../../models/gallery.dart';
import '../../models/this_image.dart';
import '../../models/this_user.dart';
import '../../services/gallery_service.dart';
import '../../services/image_service.dart';
import '../../services/user_service.dart';

class GalleryViewModel extends BaseViewModel implements Initialisable {
  final log = getLogger('GalleryViewModel');
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

  String _userIcon = "";
  String get userIcon => _userIcon;

  List<ThisImage> _galleryImages = [];
  List<ThisImage> get galleryImages => _galleryImages;

  List<ThisImage> _galleryImagesShown = [];
  List<ThisImage> get galleryImagesShown => _galleryImagesShown;

  List<ThisImage> _favouriteGalleryImagesShown = [];
  List<ThisImage> get favouriteGalleryImagesShown =>
      _favouriteGalleryImagesShown;

  String? id;

  bool draggableReordering = false;

  bool decendingOrder = false;

  final String _logoLocation = 'assets/monstera_logo.png';
  String get logoLocation => _logoLocation;

  @override
  void initialise() async {
    runBusyFuture(getGallery());
  }

  Future navigateToProfile() async {
    //_galleryService.reorderGallery(galleryImages!);
    _navigationService.navigateTo(Routes.profileView,
        transition: TransitionsBuilders.slideLeftWithFade);
  }

  Future navigateToImageView({required ThisImage image}) async {
    log.i('navigate to image view');
    var i = image.toJson();
    log.i('navigate to view of $i');
    _navigationService.navigateTo(Routes.imageView,
        arguments: ImageViewArguments(image: image));
    //navigationService.navigateToImageView(image: image);
  }

  Future getGallery() async {
    _userGallery = await _galleryService.getUserGallery();
    if (_userGallery != null) {
      _galleryId = _userGallery!.id ?? "";
      if (_galleryId != "") {
        await setUserName();
        await setUserIcon();
        await getGalleryImages(galleryID: _galleryId);
      }
    }
  }

  Future setUserName() async {
    ThisUser? userData = await _userService.getUserData();
    log.i('got data for $userData');

    if (userData != null) {
      _username = userData.username ?? "";
      log.i('got username $_username');
    }
  }

  Future setUserIcon() async {
    ThisUser? userData = await _userService.getUserData();

    if (userData != null) {
      _userIcon = userData.avatar ?? "";
    }
  }

  Future getGalleryImages({
    required String galleryID,
  }) async {
    _galleryImages = [];
    _galleryImagesShown = [];
    var getGalleryImages = await _galleryService.getGalleryImages(_galleryId);
    if (getGalleryImages == null) {
      log.i('gallery images empty');
      return true;
    } else {
      log.i('adding gallery image paths to list');
      //only add if path exists
      for (ThisImage galleryImage in getGalleryImages) {
        log.i('try adding image');
        if (galleryImage.path.isNotEmpty) {
          log.i('there is a path');
          try {
            var truePath = await File(galleryImage.path).exists();
            log.i(truePath);
            if (truePath == true) {
              addGalleryImagesToGallery(galleryImage);
            }
          } on PathNotFoundException {
            //all these checks arnt resolving the throw error?
            log.i('path not found exception for $galleryImage');
          } catch (e) {
            log.i('error for $galleryImage');
          }
        }
      }

      return true;
    }
  }

  addGalleryImagesToGallery(ThisImage galleryImage) {
    log.i('validated path now add');
    _galleryImages.add(galleryImage);
    _galleryImagesShown.add(galleryImage);
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
      log.i('source not set');
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
          log.i('successfully added image and resent query');
          notifyListeners();
          return;
        } else {
          showAddingImageError();
          return;
        }
      }
    } on PlatformException catch (e) {
      log.i(e);
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
              child: SizedBox(
                height: 20,
                width: 80,
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  scrollDirection: Axis.horizontal,
                  children: const [
                    Icon(Icons.perm_media),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Gallery',
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                await openPicker(source: 'camera');
              },
              child: SizedBox(
                height: 20,
                width: 50,
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  scrollDirection: Axis.horizontal,
                  children: const [
                    Icon(Icons.photo_camera),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Camera',
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> addImage(String path) async {
    log.i('add image to gallery $_galleryId');
    try {
      ThisImage image = ThisImage(
          path: path,
          favourite: false,
          date: Timestamp.now(),
          preferredIndex: 0);
      var addedImage =
          await _galleryService.addImageToGallery(image, _galleryId);
      if (addedImage == false) {
        showAddingImageError();
        return false;
      } else {
        image.id = addedImage as String;
        if (_galleryImagesShown.isEmpty) {
          getGalleryImages(galleryID: _galleryId);
        } else {
          _galleryImagesShown.insert(0, image);
          notifyListeners();
        }

        return true;
      }
    } catch (e) {
      log.e(e);
      showAddingImageError();
      return false;
    }
  }

  onReorder({required int oldIndex, required int newIndex}) {
    int index = 0;

    final ThisImage item = _galleryImagesShown.removeAt(oldIndex);
    _galleryImagesShown.insert(newIndex, item);

    notifyListeners();

    if (_galleryImagesShown.length > 1) {
      for (var image in _galleryImagesShown) {
        image.preferredIndex = index;
        index++;
      }
    }
  }

  Future reorderAcendingDecending() async {
    int index = 0;
    if (!decendingOrder) {
      _galleryImagesShown.sort((a, b) => b.date.compareTo(a.date));
    } else {
      _galleryImagesShown.sort((a, b) => a.date.compareTo(b.date));
    }

    decendingOrder = !decendingOrder;

    notifyListeners();
    if (_galleryImagesShown.length > 1) {
      for (var image in _galleryImagesShown) {
        image.preferredIndex = index;
        index++;
      }
    }
  }

  Future reorderAcending() async {
    int index = 0;
    _galleryImagesShown.sort((a, b) => a.date.compareTo(b.date));

    notifyListeners();
    if (_galleryImagesShown.length > 1) {
      for (var image in _galleryImagesShown) {
        image.preferredIndex = index;
        index++;
      }
    }
  }

  Future reorderDecending() async {
    int index = 0;
    _galleryImagesShown.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
    if (_galleryImagesShown.length > 1) {
      for (var image in _galleryImagesShown) {
        image.preferredIndex = index;
        index++;
      }
    }
  }

  Future filterFavourites() async {
    List<ThisImage> favouriteImages = [];
    for (var image in _galleryImagesShown) {
      if (image.favourite == true) {
        favouriteImages.add(image);
        _favouriteGalleryImagesShown.add(image);
      }
    }

    if (_galleryImagesShown.length == favouriteImages.length) {
      _galleryImagesShown = _galleryImages;
      _favouriteGalleryImagesShown = [];
    } else {
      _galleryImagesShown = favouriteImages;
    }

    notifyListeners();
    return;
  }

//dont currently run this method
  Future saveOrder() async {
    if (_galleryImages.length == _galleryImagesShown.length) {
      var reorderResult =
          await _galleryService.reorderGallery(_galleryImagesShown);
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
    log.i('toggle fave');
    for (var imageShown in _galleryImagesShown) {
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
      log.i('id null');
      await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: 'We cannot update your favourite status',
        mainButtonTitle: 'OK',
      );
    }
  }

  toggleDraggableReordering() {
    draggableReordering = !draggableReordering;
    notifyListeners();
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
