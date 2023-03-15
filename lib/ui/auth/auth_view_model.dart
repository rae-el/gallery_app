import 'package:gallery_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';

class AuthViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final authenticationService = locator<AuthenticationService>();

  final String _logoLocation = 'assets/gallery_logo.png';
  String get logoLocation => _logoLocation;

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

  Future forgotPassword({required String email}) async {
    authenticationService.forgotPassword(email);
    //add error catching
  }

  //Form validation
  String? validateFormEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'Whoops! An email address is required';
    }
    String regexPattern = r'\w+@\w\.\w+';
    RegExp regex = RegExp(regexPattern);
    if (!regex.hasMatch(formEmail)) {
      return "Whoops! That's not an email format";
    }
    return '';
  }

  String? validateFormPassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Whoops! A password is required';
    }
    String regexPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(regexPattern);
    if (!regex.hasMatch(formPassword)) {
      return '''Password needs to be at least 8 characters,
      include an uppercase letter, lowercase letter, number and symbol.''';
    }
    return '';
  }
}
