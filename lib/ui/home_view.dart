import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/profile/profile_view.dart';
import 'package:gallery_app/ui/add_view.dart';
import 'package:gallery_app/utlis/colors.dart';
import 'package:image_picker/image_picker.dart';
import '../gallery/gallery_event.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  // home view after authentication

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
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
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              builder: (context) => AddView(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: textColour,
        ),
        backgroundColor: primaryColour,
      ),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Gallery'),
      actions: [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // go to the image source action sheet here
                builder: (context) => ProfileView(),
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
