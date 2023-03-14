import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:gallery_app/models/this_image.dart';
import 'package:stacked/stacked.dart';

import 'image_view_model.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.image});

  //for now just get the path
  final ThisImage image;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImageViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ImageViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => Scaffold(
        //add an appBar
        body: Center(
            child: Hero(
          tag: image,
          child: Image.file(File(image.path)),
        )),
      ),
    );
  }
}
