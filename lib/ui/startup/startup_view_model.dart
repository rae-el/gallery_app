import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../services/auth_service.dart';

class StartupViewModel extends BaseViewModel implements Initialisable {
  /* this is where I put the variables and basic function for the view */
  final String _logoLocation = 'assets/gallery_logo.png';
  String get logoLocation => _logoLocation;

  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  @override
  void initialise() async {
    runBusyFuture(navigate());
    // This will be called when init state cycle runs
    //this works but so quick that you don't see it, consider adding a delay
  }
  //check if user logged in, if yes navigate to home, if not navigate to auth view

  Future navigate() async {
    setBusy(true);
    if (await _authenticationService.isUserLoggedIn() == User) {
      _navigationService.navigateTo(Routes.galleryView);
    } else {
      _navigationService.navigateTo(Routes.authView);
    }
  }
}
