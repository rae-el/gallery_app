String? validateFormEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Whoops! An email address is required';
  }
  String regexPattern = r'\w+@\w\.\w+';
  RegExp regex = RegExp(regexPattern);
  if (!regex.hasMatch(formEmail)) {
    return "Whoops! That's not an email format";
  }
  return '';
}

String? validateFormPassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Whoops! A password is required';
  }
  String regexPattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(regexPattern);
  if (!regex.hasMatch(formPassword)) {
    return '''Password needs to be at least 8 characters,
      include an uppercase letter, lowercase letter, number and symbol.''';
  }
  return '';
}
