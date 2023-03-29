import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

import '../../app/fonts.dart';
import '../../app/validators.dart';
import 'change_pw_view_model.dart';

class ChangePwView extends StatefulWidget {
  const ChangePwView({super.key});

  @override
  State<ChangePwView> createState() => PwState();
}

class PwState extends State<ChangePwView> {
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
        body: Form(
          key: _key,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: backgroundColour,
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
                  validator: validateFormPassword,
                  obscureText: true, //hide password characters
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                TextFormField(
                  controller: _duplicatePasswordField,
                  validator: validateFormPassword,
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
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
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
                      style: TextStyle(color: textColour),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    await model.cancelRequest();
                  },
                  child: const Text(
                    "Cancel",
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
