import 'package:flutter/material.dart';
import 'package:gallery_app/ui/profile/profile_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../services/auth_service.dart';

class ProfileViewModel extends BaseViewModel implements Initialisable {
  final authenticationService = locator<AuthenticationService>();
  final navigationService = locator<NavigationService>();

  String _userEmail = "";
  String get userEmail => _userEmail;

  String _userName = "";
  String get userName => _userName;

  String _userAvatar = "";
  String get userAvatar => _userAvatar;

  /*String _userDescription = "";
  String get userDescription => _userDescription;*/

  @override
  void initialise() async {
    runBusyFuture(retrieveUserData());
    // This will be called when init state cycle runs
    //this works but so quick that you don't see it, consider adding a delay
  }

  Future<bool> retrieveUserData() async {
    setBusy(true);
    var userData = await authenticationService.getUserData();

    if (userData != "") {
      _userEmail = userData['email'] ?? "";
      _userName = userData['userName'] ?? "";
      _userAvatar = userData['avatar'] ?? "";
      return true;
    } else {
      //do some error handeling
      return false;
    }
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
