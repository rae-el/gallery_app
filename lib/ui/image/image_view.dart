import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:gallery_app/models/this_image.dart';
import 'package:stacked/stacked.dart';

import 'image_view_model.dart';

class ImageView extends StatelessWidget {
  const ImageView({Key? key, required this.image}) : super(key: key);

  final ThisImage image;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImageViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ImageViewModel(image),
      onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => model.isBusy
          ? Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: const LinearProgressIndicator(
                  color: secondaryBackgroundColour,
                ),
              ),
            )
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
                  child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(1),
                minScale: 0.1,
                maxScale: 100,
                child: Hero(
                  tag: image,
                  child: Image.file(File(model.image!.path)),
                ),
              )
                  //ImageWidget(image: image),
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

class ImageWidget extends StatefulWidget {
  const ImageWidget({super.key, required this.image});

  final ThisImage image;

  @override
  State<ImageWidget> createState() => ImageState(image: image);
}

class ImageState extends State<ImageWidget> {
  final ThisImage image;

  ImageState({required this.image});
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      //make this zoomable
      child: GestureDetector(
        onScaleStart: (details) {
          _baseScaleFactor = _scaleFactor;
        },
        onScaleUpdate: (details) {
          print('scale update');
          if (details.scale == 1.0) {
            return;
          } else {
            setState(() {
              print('scale');
              _scaleFactor = _baseScaleFactor * details.scale;
            });
          }
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: image,
            child: Image.file(
              File(image.path),
              scale: _scaleFactor,
            ),
          ),
        ),
      ),
    );
  }
}
