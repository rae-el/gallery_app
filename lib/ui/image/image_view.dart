import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

import 'image_view_model.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImageViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ImageViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => Scaffold(
        //add an appBar
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset(model.imageLocation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
