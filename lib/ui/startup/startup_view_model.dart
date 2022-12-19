import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  /* this is where I put the variables and basic function for the view */
  final String _logoLocation = 'assets/gallery_logo.png';
  String get logoLocation => _logoLocation;

  final navigationService = locator<NavigationService>();

  void navigateToHome() {
    navigationService.navigateTo(Routes.homeView);
  }
}
