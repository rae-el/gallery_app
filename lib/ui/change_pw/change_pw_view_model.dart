import 'package:gallery_app/app/validators.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../app/messages.dart';
import '../../enums/basic_dialog_status.dart';
import '../../enums/dialog_type.dart';
import '../../services/auth_service.dart';

class ChangePwViewModel extends BaseViewModel {
  final log = getLogger('ChangePwViewModel');
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  String _formErrorMessage = '';
  String get formErrorMessage => _formErrorMessage;

  updateFormErrorMessage(String newErrorMsg) {
    _formErrorMessage = newErrorMsg;
    notifyListeners();
  }

  Future cancelRequest() async {
    await _navigationService.navigateTo(Routes.profileView);
  }

  Future requestChangePassword({
    required String? newPassword,
  }) async {
    var validationMessage = validateFormPassword(newPassword);
    if (validationMessage != null) {
      updateFormErrorMessage(validationMessage);
      notifyListeners();
    } else {
      log.i('password passed validation');
      try {
        var changePwResponse = await _authenticationService.changePassword(
            newPassword: newPassword as String);
        switch (changePwResponse) {
          case true:
            _navigationService.back();
            final dialogResult = await _dialogService.showCustomDialog(
              variant: DialogType.basic,
              data: BasicDialogStatus.success,
              title: successTitle,
              description: 'Changed Password',
              mainButtonTitle: 'OK',
            );
            return dialogResult;
          default:
            _formErrorMessage = _authenticationService.returnMessage;
            return;
        }
      } catch (e) {
        log.e(e);
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
