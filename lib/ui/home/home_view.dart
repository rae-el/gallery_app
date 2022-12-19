import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/ui/home/home_view_model.dart';
import 'package:gallery_app/ui/profile/profile_view.dart';
import 'package:gallery_app/ui/add/add_view.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  // home view after authentication

  //this has functionality that should be moved to the model

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: const MainAppBar(),
        body: Container(
          decoration: const BoxDecoration(
            color: backgroundColour,
          ),
          //fill space of entire screen
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
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
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // go to the image source action sheet here
                builder: (context) => const AddView(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: textColour,
          ),
        ),
      ),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Gallery'),
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // go to the image source action sheet here
                builder: (context) => const ProfileView(),
              ),
            );
          },
        ),
      ],
    );
  }
}

//when user clicks add image button
void _showImageSourceActionSheet(BuildContext context) {
  /*
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
  }*/
}
