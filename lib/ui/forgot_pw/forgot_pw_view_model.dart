import 'package:gallery_app/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../app/messages.dart';
import '../../enums/basic_dialog_status.dart';
import '../../enums/dialog_type.dart';
import '../../services/auth_service.dart';

class ForgotPwViewModel extends BaseViewModel {
  final log = getLogger('ForgotPwViewModel');
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _validationService = locator<ValidationService>();

  String _formErrorMessage = '';
  String get formErrorMessage => _formErrorMessage;

  updateFormErrorMessage(String newErrorMsg) {
    _formErrorMessage = newErrorMsg;
    notifyListeners();
  }

  cancelRequest() {
    _navigationService.clearStackAndShow(Routes.authView);
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
        _navigationService.clearStackAndShow(Routes.authView);
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
