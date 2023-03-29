import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/services/validation_service.dart';
import 'package:mockito/mockito.dart';
import '../setup/test_helpers.dart';

void main() {
  group('ValidationTest - ', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('validateFormEmail - ', () {
      /*test('email is null return string', () {
        var service = getAndRegisterValidationService();
        var email;
        service.validateFormEmail(email);
        verify(service.hasValidationMsg);
      });*/
    });
  });
}
