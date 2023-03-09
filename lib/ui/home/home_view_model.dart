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
  final navigationService = locator<NavigationService>();
  final galleryService = locator<GalleryService>();

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
    navigationService.navigateTo(Routes.profileView);
  }

  Future<bool> askForGalleryData() async {
    //this will automatically happen
    //setBusy(true);
    print('asking for gallery data');
    Gallery? userGallery = await galleryService.getUserGallery();
    if (userGallery != null) {
      _galleryId = userGallery.id ?? "";
      print('gallery id: $_galleryId');

      if (_galleryId != null) {
        _galleryImages = await galleryService.getGalleryImages(_galleryId);
        if (_galleryImages!.isNotEmpty) {
          for (var galleryImage in _galleryImages!) {
            _galleryImagePaths.add(galleryImage.path);
          }
          return true;
        }
        return false;
      }
      return false;
    } else {
      //do some error handeling
      print('user gallery null, failed to retreive gallery id');
      return false;
    }
  }

  createImages() {
    List<Image> imageBlocks = <Image>[];
    Image? imageBlock;
    for (String imagePath in _galleryImagePaths) {
      try {
        if (File(imagePath).existsSync()) {
          imageBlock = new Image.file(File(imagePath));
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
        String? newImagePath = image.path;
        addImage(newImagePath);
        // add confirmation window?
        notifyListeners();
        navigationService.back();
        return;
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
      await galleryService.addImageToGallery(image, _galleryId);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<String> getMyStream() async* {
    List<ThisImage>? myGalleryImages =
        await galleryService.getGalleryImages(_galleryId);
    if (myGalleryImages!.isNotEmpty) {
      for (ThisImage galleryImage in myGalleryImages) {
        print(galleryImage.path);
        yield galleryImage.path;
      }
    }
  }
  /*Future getImages() {
    //var user = authenticationService.getUserDetails();
    //change this to be receiving the images
    //return user;
    //populating with images
    /*
    StreamBuilder<QuerySnapshot>(
              //get info from Firestore
              stream: FirebaseFirestore.instance
                  //stream builder checks current authenticated user for collection Images
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Images')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    // while getting data show progress indicator
                    child: CircularProgressIndicator(),
                    // need to do something if no data
                  );
                }
                return ListView(
                  //get Images and list them as children containers
                  children: snapshot.data!.docs.map((document) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // build image here based on the path
                          Text("Image ${document.id}"),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },*/
  }*/

  //ignore and use different method
  //when user clicks add image button
  /*void _showImageSourceActionSheet(BuildContext context) {
    
  Function(ImageSource) selectImageSource = (imageSource) {
    context.add(OpenImagePicker(imageSource: imageSource));
  };
  if (Platform.isIOS) {
    // for ios show a popup
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          //add camera action
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.camera);
            },
          ),
          //add gallery action
          CupertinoActionSheetAction(
            child: Text('Gallery'),
            onPressed: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.gallery);
            },
          ),
          //add url action
        ],
      ),
    );
  } else {
    // for android and other platforms show a bottom sheet
    showModalBottomSheet(
        context: context,
        builder: (context) => ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    selectImageSource(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    selectImageSource(ImageSource.gallery);
                  },
                ),
              ],
            ));
  }
  }*/

  //gesture functions
  //double tap, add / remove from liked
  //tap, navigate to image view
  //long hold, option to delete (maybe)
  //drag, reorder (maybe)
}
