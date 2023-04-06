import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

import '../../app/app.locator.dart';
import '../../app/fonts.dart';
import '../../services/validation_service.dart';
import 'forgot_pw_view_model.dart';

class ForgotPwView extends StatefulWidget {
  const ForgotPwView({super.key});

  @override
  State<ForgotPwView> createState() => ForgotPwState();
}

class ForgotPwState extends State<ForgotPwView> {
  final _validationService = locator<ValidationService>();
  TextEditingController _emailField = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPwViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ForgotPwViewModel(),
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
                  'Forgot Password',
                  style: titleFont,
                ),
                const Text(
                  '''send reset email''',
                  style: subTitleFont,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailField,
                  validator: _validationService.validateFormPassword,
                  textInputAction: TextInputAction.done,
                  obscureText: true, //hide password characters
                  decoration: const InputDecoration(
                    labelText: "Email",
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
                      if (_emailField.text != '') {
                        await model.requestForgotPassword(
                          _emailField.text,
                        );
                      } else {
                        model.updateFormErrorMessage(
                            'You must enter your email');
                      }
                    },
                    child: const Text(
                      "Send",
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
