import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/app/app.logger.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../services/auth_service.dart';

class StartupViewModel extends BaseViewModel implements Initialisable {
  final log = getLogger('StarupViewModel');
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  final String _logoLocation = 'assets/monstera_logo.png';
  String get logoLocation => _logoLocation;

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  @override
  void initialise() async {
    runBusyFuture(isCurrentUserLoggedIn());
    // This will be called when init state cycle runs
    //this works but so quick that you don't see it, consider adding a delay
  }
  //check if user logged in, if yes navigate to home, if not navigate to auth view

  Future navigate({required bool loggedIn}) async {
    if (loggedIn) {
      _navigationService.replaceWith(Routes.galleryView);
    } else {
      _navigationService.replaceWith(Routes.authView);
    }
  }

  Future isCurrentUserLoggedIn() async {
    log.i('is there a logged in user, set variable');
    _loggedIn = await _authenticationService.isUserLoggedIn();
    Future.delayed(const Duration(seconds: 3), () {
      log.i('next run navigation');
      navigate(loggedIn: _loggedIn);
    });
  }
}
