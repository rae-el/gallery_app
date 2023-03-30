import 'package:gallery_app/services/validation_service.dart';
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
  final _validationService = locator<ValidationService>();

  final String _logoLocation = 'assets/monstera_logo.png';
  String get logoLocation => _logoLocation;

  final String _backgroundLocation = 'assets/leaves_plant_green.jpg';
  String get backgroundLocation => _backgroundLocation;

  String _formErrorMessage = '';
  String get formErrorMessage => _formErrorMessage;

  requestSignIn(String? email, String? password) {
    String passwordValidationResponse = '';
    String? emailValidationResponse =
        _validationService.validateFormEmail(email);
    if (password == null || password.isEmpty) {
      passwordValidationResponse = 'Password is required';
    }
    if (emailValidationResponse == null && passwordValidationResponse.isEmpty) {
      signIn(email: email as String, password: password as String);
    } else {
      _formErrorMessage =
          '$emailValidationResponse $passwordValidationResponse';
      notifyListeners();
    }
  }

  Future signIn({
    required String email,
    required String password,
  }) async {
    var signInResponse =
        await _authenticationService.signIn(email: email, password: password);
    if (signInResponse == null) {
      log.i('signInResponse a success null');
      _navigationService.replaceWith(Routes.galleryView,
          transition: TransitionsBuilders.fadeIn);
    } else {
      log.i('signInResponse a error');
      await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        data: BasicDialogStatus.error,
        title: errorTitle,
        description: signInResponse,
        mainButtonTitle: 'OK',
      );
      _formErrorMessage = '';
      notifyListeners();
    }
  }

  requestSignUp(String? email, String? password) {
    var emailValidationResponse = _validationService.validateFormEmail(email);
    var passwordValidationResponse =
        _validationService.validateFormPassword(password);
    if (emailValidationResponse == null && passwordValidationResponse == null) {
      signUp(email: email as String, password: password as String);
    } else {
      _formErrorMessage =
          '$emailValidationResponse $passwordValidationResponse';
      notifyListeners();
    }
  }

  Future signUp({
    required String email,
    required String password,
  }) async {
    var createNewUserResponse = await _authenticationService.createNewUser(
        email: email, password: password);
    if (createNewUserResponse == null) {
      log.i('signUpResponse a success null');
      signIn(email: email, password: password);
    } else {
      log.i('signUpResponse a error');
      _formErrorMessage = createNewUserResponse;
      notifyListeners();
    }
  }

  requestForgotPassword(String? email) {
    if (email == null) {
      _formErrorMessage = 'Please input your email. ';
      notifyListeners();
    } else {
      var emailValidationResponse = _validationService.validateFormEmail(email);
      if (emailValidationResponse == null) {
        forgotPassword(email: email);
        _formErrorMessage = '';
        notifyListeners();
      } else {
        _formErrorMessage = emailValidationResponse;
        notifyListeners();
      }
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
        _formErrorMessage = '';
        notifyListeners();
      } else {
        await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.error,
          title: errorTitle,
          description: forgotPasswordResponse,
          mainButtonTitle: 'OK',
        );
        _formErrorMessage = '';
        notifyListeners();
      }
    } else {
      _formErrorMessage = 'Please input your email. ';
      notifyListeners();
    }
    //add error catching
  }
}
