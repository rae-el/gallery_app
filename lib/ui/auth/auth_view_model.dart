import 'package:gallery_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../app/messages.dart';
import '../../enums/basic_dialog_status.dart';
import '../../enums/dialog_type.dart';

class AuthViewModel extends BaseViewModel {
  final log = getLogger('AuthViewModel');
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();

  final String _logoLocation = 'assets/gallery_logo.png';
  String get logoLocation => _logoLocation;

  String _formErrorMessage = '';
  String get formErrorMessage => _formErrorMessage;

  Future signIn({
    required String email,
    required String password,
  }) async {
    var signInResponse =
        await _authenticationService.signIn(email: email, password: password);
    if (signInResponse == null) {
      log.i('signInResponse a success null');
      _navigationService.replaceWith(Routes.galleryView);
    } else {
      log.i('signInResponse a error');
      await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: signInResponse,
        mainButtonTitle: 'OK',
      );
    }
  }

  Future signUp({
    required String email,
    required String password,
  }) async {
    //error handle here first?
    var createNewUserResponse = await _authenticationService.createNewUser(
        email: email, password: password);
    if (createNewUserResponse == null) {
      log.i('signUpResponse a success null');
      signIn(email: email, password: password);
    } else {
      log.i('signUpResponse a error');
      _formErrorMessage = createNewUserResponse;
      notifyListeners();
      return;
    }
  }

  Future forgotPassword({required String email}) async {
    if (email != '') {
      var forgotPasswordResponse =
          await _authenticationService.forgotPassword(email: email);
      if (forgotPasswordResponse ==
          'Please check your email to finish resetting your password') {
        await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.success,
          title: successTitle,
          description: forgotPasswordResponse,
          mainButtonTitle: 'OK',
        );
      } else {
        await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.error,
          title: errorTitle,
          description: forgotPasswordResponse,
          mainButtonTitle: 'OK',
        );
      }
    } else {
      _formErrorMessage = 'Please input your email';
      notifyListeners();
    }
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
