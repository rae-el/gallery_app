import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_app/models/this_user.dart';
import 'package:gallery_app/ui/profile/profile_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class ProfileViewModel extends BaseViewModel implements Initialisable {
  final userService = locator<UserService>();
  final authService = locator<AuthenticationService>();
  final navigationService = locator<NavigationService>();

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
    var userData = await userService.getUserData();
    print('got data for $userData');

    if (userData != "") {
      _uid = userData['id'] ?? "";
      _userEmail = userData['email'] ?? "Email";
      _userName = userData['username'] ?? "Username";
      _userImagePath = userData['avatar'] ?? "";
      _userDescription = userData['description'] ?? "Description";
      nameField.text = _userName;
      descriptionField.text = _userDescription;

      return true;
    } else {
      //do some error handeling
      return false;
    }
  }

  Future signOut() async {
    if (await authService.signOut()) {
      navigationService.navigateTo(Routes.authView);
    } else {
      navigationService.navigateTo(Routes.homeView);
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
      print('source not set');
      return;
    }
    try {
      if (image == null) {
        print('image null');
        return;
      } else {
        _userImagePath = image.path;
        notifyListeners();
        navigationService.back();
        return;
      }
    } on PlatformException catch (e) {
      print(e);
      return;
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

  Future<bool> saveProfile() async {
    ThisUser thisUser = ThisUser(
      id: uid,
      email: userEmail,
      username: nameField.text.trim(),
      description: descriptionField.text.trim(),
      avatar: userImagePath,
    );
    print('save profile of $thisUser');
    await userService.updateUser(thisUser);
    return true;
  }
}
