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

  Future updateImage() async {
    _galleryId = await _galleryService.getGalleryID() as String;
    await _galleryService.getGalleryImages(_galleryId);
    id = image!.id;
    image = await _imageService.imageInGallery(id);
    notifyListeners();
  }

  Future showUpdateError() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.error,
      title: errorTitle,
      description: 'There was a problem updating your gallery',
      mainButtonTitle: 'OK',
    );
  }

  Future toggleFavourite({required bool favourite}) async {
    id = image!.id;
    print('toggle fave');
    favourite = !favourite;
    if (id != null) {
      String? update = await _imageService.updateFavourite(id, favourite);
      if (update == '') {
        updateImage();
      } else {
        await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.error,
          title: errorTitle,
          description: 'We cannot update your favourite status',
          mainButtonTitle: 'OK',
        );
      }
    } else {
      print('id null');
      await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: 'We cannot update your favourite status',
        mainButtonTitle: 'OK',
      );
    }
  }

  Future requestDelete() async {
    id = image!.id;
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.basic,
      data: BasicDialogStatus.warning,
      title: 'DELETE',
      description: 'Are you sure you would like to delete this image?',
      mainButtonTitle: 'YES',
      secondaryButtonTitle: 'CANCEL',
    );
    if (dialogResult != null) {
      if (dialogResult.confirmed) {
        print('confirmed delete');
        if (id != null) {
          var deleteResponse =
              await _imageService.requestDeleteImage(imageId: id as String);
          if (deleteResponse == '') {
            navigateToHome();
          } else {
            await _dialogService.showCustomDialog(
              variant: DialogType.basic,
              data: BasicDialogStatus.error,
              title: errorTitle,
              description: deleteResponse,
              mainButtonTitle: 'OK',
            );
          }
        }
      } else {
        print('cancelled delete');
      }
    }
  }

  //gesture functions
  //double tap, add / remove from liked
  //pinch, zoom
  //long hold, option to delete (maybe)
}
