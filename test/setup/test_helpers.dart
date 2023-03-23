import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/main.dart';
import 'package:gallery_app/services/auth_service.dart';
import 'package:gallery_app/services/gallery_service.dart';
import 'package:gallery_app/services/image_service.dart';
import 'package:gallery_app/services/user_service.dart';
import 'package:mockito/annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'test_helpers.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationService>(),
  MockSpec<NavigationService>(),
  MockSpec<GalleryService>(),
  MockSpec<ImageService>(),
  MockSpec<UserService>(),
])
void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

void registerServices() {
  getAndRegisterAuthenticationService();
  getAndRegisterNavigationService();
  getAndRegisterGalleryService();
  getAndRegisterImageService();
  getAndRegisterUserService();
}

void unregisterService() {
  locator.unregister<AuthenticationService>();
  locator.unregister<NavigationService>();
  locator.unregister<GalleryService>();
  locator.unregister<ImageService>();
  locator.unregister<UserService>();
}

AuthenticationService getAndRegisterAuthenticationService() {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();
  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

NavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

GalleryService getAndRegisterGalleryService() {
  _removeRegistrationIfExists<GalleryService>();
  final service = MockGalleryService();
  locator.registerSingleton<GalleryService>(service);
  return service;
}

ImageService getAndRegisterImageService() {
  _removeRegistrationIfExists<ImageService>();
  final service = MockImageService();
  locator.registerSingleton<ImageService>(service);
  return service;
}

UserService getAndRegisterUserService() {
  _removeRegistrationIfExists<UserService>();
  final service = MockUserService();
  locator.registerSingleton<UserService>(service);
  return service;
}
