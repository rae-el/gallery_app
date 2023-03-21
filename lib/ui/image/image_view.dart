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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImageViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ImageViewModel(image),
      onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => model.isBusy
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                //should make the title the image title if exists?
                leading: IconButton(
                    onPressed: model.navigateToHome,
                    icon: const Icon(Icons.arrow_back)),
                title: const Text(''),
                centerTitle: true,
                actions: const [],
              ),
              body: Center(
                //make this zoomable
                child: GestureDetector(
                  child: Hero(
                    tag: image,
                    child: Image.file(File(model.image!.path)),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
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
                        model.toggleFavourite(
                            favourite: model.image!.favourite);
                      },
                      icon: model.image!.favourite
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_outline),
                      splashRadius: 25,
                    ),
                    label: 'Favourite',
                  ),
                  BottomNavigationBarItem(
                    icon: IconButton(
                      onPressed: () {
                        model.requestDelete();
                      },
                      icon: const Icon(Icons.delete),
                      splashRadius: 25,
                    ),
                    label: 'Delete',
                  ),
                ],
              ),
            ),
    );
  }
}
