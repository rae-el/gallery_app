import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/app/app.router.dart';
import 'package:gallery_app/ui/startup/startup_view_model.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_helpers.dart';

void main() {
  group('StartupViewmodelTest - ', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('navigate - ', () {
      test('if no logged in user navigate to Auth View', () async {
        final navigationService = getAndRegisterNavigationService();
        var model = StartupViewModel();
        model.navigate(loggedIn: false);
        verify(navigationService.replaceWith(Routes.authView));
      });
      test('check for loggin logged in, if null navigate to Auth View',
          () async {
        final navigationService = getAndRegisterNavigationService();
        final authenticationService = getAndRegisterAuthenticationService();
        bool user = await authenticationService.isUserLoggedIn();
        var model = StartupViewModel();
        model.navigate(loggedIn: user);
        verify(navigationService.replaceWith(Routes.authView));
      });
      test('if logged in user navigate to Gallery View', () async {
        final navigationService = getAndRegisterNavigationService();
        var model = StartupViewModel();
        model.navigate(loggedIn: true);
        verify(navigationService.replaceWith(Routes.galleryView));
      });
    });
  });
}
