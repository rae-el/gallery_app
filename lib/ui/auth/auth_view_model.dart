import 'package:gallery_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';

class AuthViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();

  final String _logoLocation = 'assets/gallery_logo.png';
  String get logoLocation => _logoLocation;

  String _formErrorMessage = '';
  String get formErrorMessage => _formErrorMessage;

  Future signIn({
    required String email,
    required String password,
  }) async {
    if (await _authenticationService.signIn(email, password)) {
      _navigationService.navigateTo(Routes.homeView);
    }
  }

  Future signUp({
    required String email,
    required String password,
  }) async {
    var signUpResponse = await _authenticationService.signUp(email, password);
    if (signUpResponse == '') {
      signIn(email: email, password: password);
    } else if (signUpResponse == 'ERROR') {
      notifyListeners();
      return;
    } else {
      _formErrorMessage = signUpResponse;
      notifyListeners();
      return;
    }
  }

  Future forgotPassword({required String email}) async {
    _authenticationService.forgotPassword(email);
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
