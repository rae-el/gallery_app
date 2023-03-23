import 'package:gallery_app/ui/change_pw/change_pw_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/messages.dart';
import '../../enums/basic_dialog_status.dart';
import '../../enums/dialog_type.dart';
import '../../services/auth_service.dart';

class ChangePwViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  String _formErrorMessage = '';
  String get formErrorMessage => _formErrorMessage;

  String? validateFormPassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      _formErrorMessage = 'Whoops! A password is required';
      return 'Whoops! A password is required';
    }
    String regexPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(regexPattern);
    if (!regex.hasMatch(formPassword)) {
      _formErrorMessage = '''Password needs to be at least 8 characters,
      include an uppercase letter, lowercase letter, number and symbol.''';
      return '''Password needs to be at least 8 characters,
      include an uppercase letter, lowercase letter, number and symbol.''';
    }
    return '';
  }

  updateFormErrorMessage(String newErrorMsg) {
    _formErrorMessage = newErrorMsg;
    notifyListeners();
  }

  Future cancelRequest() async {
    await _navigationService.navigateTo(Routes.profileView);
  }

  Future requestChangePassword({
    required String newPassword,
  }) async {
    print('password change request');
    if (newPassword == null || newPassword.isEmpty) {
      updateFormErrorMessage('Whoops! A password is required');
      return;
    }
    String regexPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(regexPattern);
    if (!regex.hasMatch(newPassword)) {
      updateFormErrorMessage(
          '''Password needs to be at least 8 characters, include an uppercase letter, lowercase letter, number and symbol.''');
      return;
    } else {
      print('password passed validation');
      try {
        var changePwResponse = await _authenticationService.changePassword(
            newPassword: newPassword);
        switch (changePwResponse) {
          case '':
            _navigationService.back();
            final dialogResult = await _dialogService.showCustomDialog(
              variant: DialogType.basic,
              data: BasicDialogStatus.success,
              title: successTitle,
              description: 'Changed Password',
              mainButtonTitle: 'OK',
            );
            return dialogResult;
          case 'ERROR':
            final dialogResult = await _dialogService.showCustomDialog(
              variant: DialogType.basic,
              data: BasicDialogStatus.error,
              title: errorTitle,
              description: 'Could not change password',
              mainButtonTitle: 'OK',
            );
            return dialogResult;
          default:
            _formErrorMessage = changePwResponse;
            return;
        }
      } catch (e) {
        final dialogResult = await _dialogService.showCustomDialog(
          variant: DialogType.basic,
          data: BasicDialogStatus.error,
          title: errorTitle,
          description: 'Could not change password',
          mainButtonTitle: 'OK',
        );
        return dialogResult;
      }
    }
  }
}
