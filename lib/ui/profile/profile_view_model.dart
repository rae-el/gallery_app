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

class ProfileViewModel extends BaseViewModel implements Initialisable {
  final authenticationService = locator<AuthenticationService>();
  final navigationService = locator<NavigationService>();

  String _uid = "";
  String get uid => _uid;

  String _userEmail = "";
  String get userEmail => _userEmail;

  String _userName = "";
  String get userName => _userName;

  String _userDescription = "";
  String get userDescription => _userDescription;

  XFile? _userImage;
  XFile? get userImage => _userImage;

  @override
  void initialise() async {
    runBusyFuture(askForUserData());
    // This will be called when init state cycle runs
    //this works but so quick that you don't see it, consider adding a delay
  }

  Future<bool> askForUserData() async {
    setBusy(true);
    print('asking for user data');
    var userData = await authenticationService.getUserData();
    print('got data for $userData');

    if (userData != "") {
      _uid = userData['id'] ?? "";
      _userEmail = userData['email'] ?? "Email";
      _userName = userData['username'] ?? "Username";
      //_userImage = userData['avatar'] ?? "";
      _userDescription = userData['description'] ?? "Description";
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
        _userImage = image;
        notifyListeners();
        //_imagePath = File(image.path);
        print(_userImage);
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

  Future? getAvatarPath(Set set) {
    final String avatarPath;

    //GetAvatarPath({required this.avatarPath});
    return null;
  }

  Future? profileNameChanged(Set set) {
    final String description;
    //ProfileDescriptionChanged({required this.description});
    return null;
  }

  Future<bool> saveProfile({
    required ThisUser user,
  }) async {
    print('save profile of $user');
    await authenticationService.updateUser(user);
    return true;
  }
}
