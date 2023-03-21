import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:gallery_app/enums/basic_dialog_status.dart';
import 'package:gallery_app/enums/dialog_type.dart';
import 'package:gallery_app/services/image_service.dart';
import 'package:gallery_app/ui/home/home_view_model.dart';
import 'package:gallery_app/ui/image/image_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/messages.dart';
import '../../models/gallery.dart';
import '../../models/this_image.dart';
import '../../services/gallery_service.dart';

class ImageViewModel extends BaseViewModel implements Initialisable {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _imageService = locator<ImageService>();
  final _galleryService = locator<GalleryService>();

  ThisImage? image;

  ImageViewModel(this.image);

  String? id;

  String _galleryId = "";
  String get galleryId => _galleryId;

  List<ThisImage>? _galleryImages = [];
  List<ThisImage>? get galleryImages => _galleryImages;

  List<String> _galleryImagePaths = [];
  List<String> get galleryImagePaths => _galleryImagePaths;

  @override
  void initialise() async {}

  Future navigateToHome() async {
    _navigationService.navigateTo(Routes.homeView);
  }

  Future navigateToProfile() async {
    _navigationService.navigateTo(Routes.profileView);
  }

  Future<bool> updateImage() async {
    id = image!.id;
    if (id != null) {
      image = await _imageService.imageInGallery(id);
      if (image != null) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  showUpdateError() async {
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.error,
      title: errorTitle,
      description: 'There was a problem updating your gallery',
      mainButtonTitle: 'OK',
    );
    return dialogResult;
  }

  Future toggleFavourite({required bool favourite}) async {
    id = image!.id;
    print('toggle fave');
    favourite = !favourite;
    if (id != null) {
      String? update = await _imageService.updateFavourite(id, favourite);
      if (update == '') {
        if (await updateImage()) {
          notifyListeners();
          return favourite;
        } else {
          final dialogResult = await _dialogService.showCustomDialog(
            variant: DialogType.basic,
            data: BasicDialogStatus.error,
            title: errorTitle,
            description: 'We cannot update your favourite status',
            mainButtonTitle: 'OK',
          );
          return dialogResult;
        }
      } else {
        final dialogResult = await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.error,
          title: errorTitle,
          description: 'We cannot update your favourite status',
          mainButtonTitle: 'OK',
        );
        return dialogResult;
      }
    } else {
      print('id null');
      final dialogResult = await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: 'We cannot update your favourite status',
        mainButtonTitle: 'OK',
      );
      return dialogResult;
    }
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
