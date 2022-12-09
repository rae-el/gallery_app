import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {}

class ChangeAvatarRequest extends ProfileEvent {}

class OpenAvatarPicker extends ProfileEvent {
  final ImageSource imageSource;

  OpenAvatarPicker({required this.imageSource});
}

class GetAvatarPath extends ProfileEvent {
  final String avatarPath;

  GetAvatarPath({required this.avatarPath});
}

class ProfileDescriptionChanged extends ProfileEvent {
  final String description;
  ProfileDescriptionChanged({required this.description});
}

class SaveProfileChanges extends ProfileEvent {}
