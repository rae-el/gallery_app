import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {}

class AddAvatarRequest extends ProfileEvent {}

class OpenAvatarPicker extends ProfileEvent {
  final ImageSource imageSource;

  OpenAvatarPicker({required this.imageSource});
}

class GetAvatarPath extends ProfileEvent {
  final String imagePath;

  GetAvatarPath({required this.imagePath});
}

class DeleteAvatarRequest extends ProfileEvent {}
