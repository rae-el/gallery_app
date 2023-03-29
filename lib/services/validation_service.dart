class ValidationService {
  String? emailValidationMsg;
  String? passwordValidationMsg;
  bool hasValidationMsg = false;

  String? validateFormEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      emailValidationMsg = 'An email address is required. ';
      hasValidationMsg = true;
      return emailValidationMsg;
    }
    String regexPattern = r'.+@.+\..+';
    RegExp regex = RegExp(regexPattern);
    if (!regex.hasMatch(formEmail)) {
      emailValidationMsg = "That's not an email format. ";
      hasValidationMsg = true;
      return emailValidationMsg;
    }
    return null;
  }

  String? validateFormPassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      passwordValidationMsg = 'A password is required. ';
      hasValidationMsg = true;
      return passwordValidationMsg;
    }
    String regexPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(regexPattern);
    if (!regex.hasMatch(formPassword)) {
      passwordValidationMsg = '''Password needs to be at least 8 characters,
      include an uppercase letter, lowercase letter, number and symbol.''';
      hasValidationMsg = true;
      return passwordValidationMsg;
    }
    return null;
  }
}
