import 'package:gallery_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';


class AuthViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final authenticationService = locator<AuthenticationService>();

  Future signIn({
    required String email,
    required String password,
  }) async {
    if (await authenticationService.signIn(email, password)) {
      navigationService.navigateTo(Routes.homeView);
    }
  }

  Future signUp({
    required String email,
    required String password,
  }) async {
    if (await authenticationService.signUp(email, password)) {
      signIn(email: email, password: password);
    } else {
      return;
    }
  }
}
