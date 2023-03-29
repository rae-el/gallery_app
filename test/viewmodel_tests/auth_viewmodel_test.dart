import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:gallery_app/enums/basic_dialog_status.dart';
import 'package:gallery_app/enums/dialog_type.dart';
import 'package:gallery_app/ui/auth/auth_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('AuthViewmodelTest - ', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
    final authenticationService = getAndRegisterAuthenticationService();
    final navigationService = getAndRegisterNavigationService();
    final dialogService = getAndRegisterDialogService();
    var model = AuthViewModel();
    String? email;
    String? password;

    group('requestSignIn', () {
      test('if no input for username and password do not navigate to gallery',
          () async {
        email = null;
        password = null;
        model.requestSignIn(email, password);
        verifyNever(navigationService.replaceWith(Routes.galleryView));
      });
      test('if unknown username and password do not navigate to gallery',
          () async {
        email = 'unknown@email.com';
        password = 'UNKNWN';
        model.requestSignIn(email, password);
        verifyNever(navigationService.replaceWith(Routes.galleryView));
      });
    });
    group('requestSignUp', () {
      test('if no input for username and password do not navigate to gallery',
          () async {
        email = null;
        password = null;
        model.requestSignUp(email, password);
        verifyNever(navigationService.replaceWith(Routes.galleryView));
      });
    });
  });
}
