import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:gallery_app/ui/image/image_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ImageViewModel extends BaseViewModel implements Initialisable {
  final _navigationService = locator<NavigationService>();

  bool _favourited = false;
  bool get favourited => _favourited;

  @override
  void initialise() async {
    // TODO: implement initialise
  }

  Future navigateToHome() async {
    _navigationService.navigateTo(Routes.homeView);
  }

  Future navigateToProfile() async {
    _navigationService.navigateTo(Routes.profileView);
  }

  toggleFavourite() {
    print('toggle fave');
    _favourited = !_favourited;
    notifyListeners();
    return _favourited;
  }

  //gesture functions
  //double tap, add / remove from liked
  //pinch, zoom
  //long hold, option to delete (maybe)
}
