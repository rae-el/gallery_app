import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../models/this_image.dart';
import '../../services/auth_service.dart';
import '../../services/gallery_service.dart';

class HomeViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final galleryService = locator<GalleryService>();

  Future navigateToProfile() async {
    navigationService.navigateTo(Routes.profileView);
  }

  Future getImages() async {
    var images = await galleryService.getGalleryImages();
    print(images);
  }

  Future<bool> addImage() async {
    try {
      ThisImage image =
          ThisImage(path: 'testimage', favourite: false, date: Timestamp.now());
      await galleryService.addImageToGallery(image);
      return true;
    } catch (e) {
      print(e);
      return false;
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
