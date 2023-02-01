import 'package:flutter/material.dart';
import 'package:gallery_app/ui/profile/profile_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../services/auth_service.dart';

class ProfileViewModel extends BaseViewModel {
  final authenticationService = locator<AuthenticationService>();
  final navigationService = locator<NavigationService>();

  Future<String> showUserEmail(Set set) async {
    String userEmail = await authenticationService.getUserEmail() as String;

    return userEmail;
  }

  Future signOut() async {
    if (await authenticationService.signOut()) {
      navigationService.navigateTo(Routes.authView);
    } else {
      navigationService.navigateTo(Routes.homeView);
    }
  }

  Future? changeAvatarRequest() {
    return null;
  }

  Future? openAvatarPicker(Set set) {
    final ImageSource imageSource;

    //OpenAvatarPicker({required this.imageSource});
    return null;
  }

  Future? getAvatarPath(Set set) {
    final String avatarPath;

    //GetAvatarPath({required this.avatarPath});
    return null;
  }

  Future? profileDescriptionChanged(Set set) {
    final String description;
    //ProfileDescriptionChanged({required this.description});
    return null;
  }

  Future? saveProfileChanges(Set set) {
    return null;
  }
}
