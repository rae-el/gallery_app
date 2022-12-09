import 'package:image_picker/image_picker.dart';

abstract class GalleryEvent {}

class AddImageRequest extends GalleryEvent {}

class OpenImagePicker extends GalleryEvent {
  final ImageSource imageSource;

  OpenImagePicker({required this.imageSource});
}

class GetImagePath extends GalleryEvent {
  final String imagePath;

  GetImagePath({required this.imagePath});
}

class DeleteImageRequest extends GalleryEvent {}
