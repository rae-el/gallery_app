import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:gallery_app/ui/auth/auth_view_model.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_helpers.dart';

void main() {
  group('AuthViewmodelTest - ', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
  });
  group('signIn', () {
    test('if signInResponse is null navigate to gallery', () async {
      final navigationService = getAndRegisterNavigationService();
      final authenticationService = getAndRegisterAuthenticationService();
      var model = AuthViewModel();
      model.signIn(email: '', password: '');
      var signInResponse =
          await authenticationService.signIn(email: '', password: '');
      verifyNever(navigationService.replaceWith(Routes.galleryView));
    });
  });
}
