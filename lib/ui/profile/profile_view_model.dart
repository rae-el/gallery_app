import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_app/models/this_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/messages.dart';
import '../../enums/basic_dialog_status.dart';
import '../../enums/dialog_type.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class ProfileViewModel extends BaseViewModel implements Initialisable {
  final _userService = locator<UserService>();
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final TextEditingController nameField = TextEditingController();
  final TextEditingController descriptionField = TextEditingController();

  String _uid = "";
  String get uid => _uid;

  String _userEmail = "";
  String get userEmail => _userEmail;

  String _userName = "";
  String get userName => _userName;

  String _userDescription = "";
  String get userDescription => _userDescription;

  String _userImagePath = "";
  String get userImagePath => _userImagePath;

  @override
  void initialise() async {
    runBusyFuture(askForUserData());
    // This will be called when init state cycle runs
    //this works but so quick that you don't see it, consider adding a delay
  }

  Future<bool> askForUserData() async {
    //this will automatically happen
    //setBusy(true);
    print('asking for user data');
    ThisUser? userData = await _userService.getUserData();
    print('got data for $userData');

    if (userData != null) {
      _uid = userData.id ?? "";
      _userEmail = userData.email ?? "";
      _userName = userData.username ?? "";
      _userImagePath = userData.avatar ?? "";
      _userDescription = userData.description ?? "";

      //assign values to the controllers
      nameField.text = _userName;
      descriptionField.text = _userDescription;

      return true;
    } else {
      //do some error handeling
      showDialogError();
      return false;
    }
  }

  showDialogError() async {
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.error,
      title: errorTitle,
      description: 'There was a problem retrieving user data',
      mainButtonTitle: 'OK',
    );
    return dialogResult;
  }

  Future signOut() async {
    if (await _authService.signOut() == null) {
      _navigationService.navigateTo(Routes.authView);
    } else {
      _navigationService.navigateTo(Routes.galleryView);
    }
  }

  Future? openPicker({required String source}) async {
    ImagePicker picker = ImagePicker();
    XFile? image;
    if (source == "gallery") {
      image = await picker.pickImage(source: ImageSource.gallery);
    }
    if (source == "camera") {
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      final dialogResult = await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: 'There was a problem selecting a photo',
        mainButtonTitle: 'OK',
      );
      return dialogResult;
    }
    try {
      if (image == null) {
        final dialogResult = await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.error,
          title: errorTitle,
          description: 'There was a problem selecting a photo',
          mainButtonTitle: 'OK',
        );
        return dialogResult;
      } else {
        _userImagePath = image.path;
        notifyListeners();
        _navigationService.back();
        final dialogResult = await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.warning,
          title: warningTitle,
          description: 'Remember to save your changes',
          mainButtonTitle: 'OK',
        );
        return dialogResult;
      }
    } on PlatformException catch (e) {
      print(e);
      final dialogResult = await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: 'There was a problem selecting a photo',
        mainButtonTitle: 'OK',
      );
      return dialogResult;
    }
  }

  Future<void> openPickerDialog(context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select an Image'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                await openPicker(source: 'gallery');
              },
              child: const Text('Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                await openPicker(source: 'camera');
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );
  }

  Future requestToChangePassword() async {
    _navigationService.navigateTo(Routes.changePwView);
  }

  Future saveProfile() async {
    ThisUser thisUser = ThisUser(
      id: uid,
      email: userEmail,
      username: nameField.text.trim(),
      description: descriptionField.text.trim(),
      avatar: userImagePath,
    );
    print('save profile of $thisUser');
    bool savedUser = await _userService.updateUser(thisUser);
    if (savedUser) {
      final dialogResult = await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.success,
        title: successTitle,
        description: 'Saved changes to profile',
        mainButtonTitle: 'OK',
      );
      return dialogResult;
    } else {
      final dialogResult = await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: 'There was a problem saving your profile',
        mainButtonTitle: 'OK',
      );
      return dialogResult;
    }
  }
}
