import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:gallery_app/enums/basic_dialog_status.dart';
import 'package:gallery_app/enums/dialog_type.dart';
import 'package:gallery_app/ui/auth/auth_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';
import '../setup/test_helpers.mocks.dart';

void main() {
  group('AuthViewmodelTest - ', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
    final navigationService = getAndRegisterNavigationService();
    final authenticationService = getAndRegisterAuthenticationService();
    final dialogService = getAndRegisterDialogService();
    final validationService = getAndRegisterValidationService();

    AuthViewModel getModel() => AuthViewModel();
    String? email;
    String? password;

    group('requestSignIn', () {
      test('if no input for email and password do not navigate to gallery',
          () async {
        email = null;
        password = null;
        var model = getModel();
        model.requestSignIn(email, password);
        verifyNever(navigationService.replaceWith(Routes.galleryView));
      });
      /*test('if no input for email do not navigate to gallery', () async {
        email = null;
        password = 'fewjvpwrim';
        var model = getModel();
        model.requestSignIn(email, password);
        verifyNever(model.signIn(email: '', password: ''));
      });*/
      test('if no input for password do not navigate to gallery', () async {
        email = 'unknown@email.com';
        password = null;
        var model = getModel();
        model.requestSignIn(email, password);
        verifyNever(navigationService.replaceWith(Routes.galleryView));
      });
      /*test('if unknown email and password do not navigate to gallery',
          () async {
        email = 'unknown@email.com';
        password = 'UNKNWN';
        var model = _getModel();
        model.requestSignIn(email, password);
        verifyNever(navigationService.replaceWith(Routes.galleryView));
      });*/
    });
    group('requestSignUp', () {
      /*test('if no input for email and password do not navigate to gallery',
          () async {
        //failing ?
        email = null;
        password = null;
        var model = _getModel();
        model.requestSignUp(email, password);

        verify(validationService.validateFormEmail(email));
      });*/
      /*test('if no input for email do not navigate to gallery', () async {
        //failing ?
        email = null;
        password = 'UNKNWN';
        var model = _getModel();
        model.requestSignUp(email, password);
        verifyNever(navigationService.replaceWith(Routes.galleryView));
      });*/
      /*test('if no input for email do not navigate to gallery', () async {
        //failing ?
        email = 'unknown@email.com';
        password = null;
        var model = _getModel();
        model.requestSignUp(email, password);
        verifyNever(navigationService.replaceWith(Routes.galleryView));
      });*/
      /*test('if valid input for email & password navigate to gallery', () async {
        email = 'unknown@email.com';
        password = 'UNKNWN';
        var model = _getModel();
        model.requestSignUp(email, password);
        verify(navigationService.replaceWith(Routes.galleryView));
      });*/
    });
  });
}
