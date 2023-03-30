import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

import '../../app/app.locator.dart';
import '../../app/fonts.dart';
import '../../services/validation_service.dart';
import 'change_pw_view_model.dart';

class ChangePwView extends StatefulWidget {
  const ChangePwView({super.key});

  @override
  State<ChangePwView> createState() => PwState();
}

class PwState extends State<ChangePwView> {
  final _validationService = locator<ValidationService>();
  TextEditingController _newPasswordField = TextEditingController();
  TextEditingController _duplicatePasswordField = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangePwViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ChangePwViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _key,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [secondaryBackgroundColour, backgroundColour]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Change Password',
                  style: titleFont,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _newPasswordField,
                  validator: _validationService.validateFormPassword,
                  obscureText: true, //hide password characters
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                TextFormField(
                  controller: _duplicatePasswordField,
                  validator: _validationService.validateFormPassword,
                  obscureText: true, //hide password characters
                  decoration: const InputDecoration(
                    labelText: "Retype New Password",
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      model.formErrorMessage,
                      style: formErrorFont,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width / 1.74,
                  height: MediaQuery.of(context).size.height / 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: primaryColour,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_newPasswordField.text != '' &&
                          _duplicatePasswordField.text != '') {
                        if (_newPasswordField.text ==
                            _duplicatePasswordField.text) {
                          await model.requestChangePassword(
                            newPassword: _newPasswordField.text,
                          );
                        } else {
                          model.updateFormErrorMessage('Passwords must match');
                        }
                      }
                    },
                    child: const Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.height / 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: primaryColour),
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await await model.cancelRequest();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: primaryColour),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
