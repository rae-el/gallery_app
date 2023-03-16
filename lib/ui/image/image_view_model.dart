import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:gallery_app/enums/basic_dialog_status.dart';
import 'package:gallery_app/enums/dialog_type.dart';
import 'package:gallery_app/ui/image/image_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/messages.dart';
import '../../models/this_image.dart';

class ImageViewModel extends BaseViewModel implements Initialisable {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  bool _favourited = false;
  bool get favourited => _favourited;

  ThisImage? _image;
  ThisImage? get image => _image;

  @override
  void initialise() async {}

  Future navigateToHome() async {
    _navigationService.navigateTo(Routes.homeView);
  }

  Future navigateToProfile() async {
    _navigationService.navigateTo(Routes.profileView);
  }

  toggleFavourite({required bool favourite}) {
    print('toggle fave');
    favourite = !favourite;
    notifyListeners();
    return favourite;
  }

  requestDelete() async {
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.error,
      title: errorTitle,
      description: 'We cannot delete your image',
      mainButtonTitle: 'OK',
    );
    return dialogResult;
  }

  //gesture functions
  //double tap, add / remove from liked
  //pinch, zoom
  //long hold, option to delete (maybe)
}
