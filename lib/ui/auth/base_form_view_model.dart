import 'package:stacked/stacked.dart';

abstract class BaseFormViewModel extends BaseViewModel {
  bool _showValidation = false;
  bool get showValidation => _showValidation;

  String _validationMessage = "";
  //this is null?
  String get validationMessage => _validationMessage;

  Map<String, String> valueMap = Map<String, String>();

  void setShowValidation(bool value) {
    _showValidation = value;
    notifyListeners();
  }

  void setValidationMessage(String value) {
    _validationMessage = value;
    _showValidation = _validationMessage?.isNotEmpty ?? false;
  }

  void setData(Map<String, String> data) {
    valueMap = data;
    setShowValidation(false);
    setValidationMessage("");

    setFormStatus();
    notifyListeners();
  }

  void setFormStatus();
}
