import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../services/auth_service.dart';

class StartupViewModel extends BaseViewModel implements Initialisable {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  final String _logoLocation = 'assets/gallery_logo.png';
  String get logoLocation => _logoLocation;

  bool _userLoggedIn = false;
  bool get userLoggedIn => _userLoggedIn;

  @override
  void initialise() async {
    runBusyFuture(getCurrentUser());
    // This will be called when init state cycle runs
    //this works but so quick that you don't see it, consider adding a delay
  }
  //check if user logged in, if yes navigate to home, if not navigate to auth view

  void navigate({required bool loggedIn}) {
    if (loggedIn) {
      _navigationService.replaceWith(Routes.galleryView);
    } else {
      _navigationService.replaceWith(Routes.authView);
    }
  }

  Future getCurrentUser() async {
    _userLoggedIn = await _authenticationService.isUserLoggedIn();
    navigate(loggedIn: _userLoggedIn);
  }
}
