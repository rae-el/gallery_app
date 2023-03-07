import 'package:flutter/material.dart';
import 'package:gallery_app/ui/dialogs/image_picker_dialog_model.dart';
import 'package:stacked/stacked.dart';

class ImagePickerDialog extends StatelessWidget {
  const ImagePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImagePickerDialogModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ImagePickerDialogModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => SimpleDialog(
        title: const Text('Select an Image'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () async {
              await model.openPicker(source: 'gallery');
            },
            child: const Text('Gallery'),
          ),
          SimpleDialogOption(
            onPressed: () async {
              await model.openPicker(source: 'camera');
            },
            child: const Text('Camera'),
          ),
        ],
      ),
    );
  }
}
