import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../services/auth_service.dart';

class ProfileViewModel extends BaseViewModel {
  final authenticationService = locator<AuthenticationService>();
  final navigationService = locator<NavigationService>();

  Future signOut() async {
    if (await authenticationService.signOut()) {
      navigationService.navigateTo(Routes.authView);
    } else {
      navigationService.navigateTo(Routes.homeView);
    }
  }

  Future? ChangeAvatarRequest() {
    return null;
  }

  Future? OpenAvatarPicker(Set set) {
    final ImageSource imageSource;

    //OpenAvatarPicker({required this.imageSource});
    return null;
  }

  Future? GetAvatarPath(Set set) {
    final String avatarPath;

    //GetAvatarPath({required this.avatarPath});
    return null;
  }

  Future? ProfileDescriptionChanged(Set set) {
    final String description;
    //ProfileDescriptionChanged({required this.description});
    return null;
  }

  Future? SaveProfileChanges(Set set) {
    return null;
  }
}
