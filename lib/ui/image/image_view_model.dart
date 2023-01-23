import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../services/auth_service.dart';

class ImageViewModel extends BaseViewModel {
  //get image in question
  final String _imageLocation = 'assets/gallery_logo.png';
  String get imageLocation => _imageLocation;

  final authenticationService = locator<AuthenticationService>();
  final navigationService = locator<NavigationService>();

  //check if user logged in, if yes navigate to home, if not navigate to auth view

  Future navigate() async {
    navigationService.navigateTo(Routes.homeView);
  }
}
