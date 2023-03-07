import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ImagePickerDialogModel extends BaseViewModel {
  String _imagePath = "";
  String get imagePath => _imagePath;

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
        _imagePath = XFile(image.path) as String;
        print(_imagePath);
        return;
      }
    } on PlatformException catch (e) {
      print(e);
      return;
    }
  }
}
