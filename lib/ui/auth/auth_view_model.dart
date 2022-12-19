import 'package:flutter/cupertino.dart';
import 'package:gallery_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';

class AuthViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future signUp({
    required String email,
    required String password,
  }) async {
    setBusy(true);
  }
}
