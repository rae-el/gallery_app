import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:gallery_app/models/this_image.dart';
import 'package:stacked/stacked.dart';

import 'image_view_model.dart';

class ImageView extends StatelessWidget {
  const ImageView({Key? key, required this.image}) : super(key: key);

  //how do I get this image data to the different classes / model
  final ThisImage image;
  get currentImage => image;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImageViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ImageViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => Scaffold(
        appBar: const MainAppBar(),
        body: Center(
          //make this zoomable
          child: Hero(
            tag: image,
            child: Image.file(File(image.path)),
          ),
        ),
        bottomNavigationBar: const ActionBar(),
      ),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImageViewModel>.reactive(
      viewModelBuilder: () => ImageViewModel(),
      builder: (context, model, child) => AppBar(
        //should make the title the image title if exists?
        title: const Text(''),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: model.navigateToProfile,
            iconSize: 25,
            splashRadius: 25,
          ),
        ],
      ),
    );
  }
}

class ActionBar extends StatefulWidget {
  const ActionBar({super.key});
  @override
  State<ActionBar> createState() => ImageActionState();
}

class ImageActionState extends State<ActionBar> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImageViewModel>.reactive(
      viewModelBuilder: () => ImageViewModel(),
      builder: (context, model, child) => BottomNavigationBar(
        fixedColor: textColour,
        unselectedItemColor: textColour,
        iconSize: 25,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        unselectedIconTheme: const IconThemeData(size: 24),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                model.toggleFavourite();
              },
              icon: model.favourited
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_outline),
              splashRadius: 25,
            ),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              splashRadius: 25,
            ),
            label: 'Delete',
          ),
        ],
      ),
    );
  }
}
