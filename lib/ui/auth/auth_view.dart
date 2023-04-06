import 'package:flutter/material.dart';
import 'package:gallery_app/ui/auth/auth_view_model.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

import '../../app/app.locator.dart';
import '../../app/fonts.dart';
import '../../services/validation_service.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => AuthenticationState();
}

class AuthenticationState extends State<AuthView> {
  final _validationService = locator<ValidationService>();

  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => AuthViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _key,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              //color: backgroundColour,
              image: DecorationImage(
                  image: AssetImage(model.backgroundLocation),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '''Welcome,''',
                  style: maxTitleFont,
                ),
                const Text(
                  '''to your gallery''',
                  style: titleFont,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 20,
                  //child: Image.asset(model.logoLocation),
                ),
                TextFormField(
                  controller: _emailField,
                  validator: _validationService.validateFormEmail,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: "example@email.com",
                    labelText: "Email",
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                TextFormField(
                  controller: _passwordField,
                  validator: _validationService.validateFormPassword,
                  textInputAction: TextInputAction.done,
                  obscureText: true, //hide password characters
                  decoration: const InputDecoration(
                    labelText: "Password",
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                Text(
                  model.formErrorMessage,
                  style: formErrorFont,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 200,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.74,
                  height: MediaQuery.of(context).size.height / 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: primaryColour,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await model.requestSignIn(
                          _emailField.text, _passwordField.text);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 200,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.height / 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: primaryColour),
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await model.requestSignUp(
                          _emailField.text, _passwordField.text);
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: primaryColour),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    await model.requestForgotPassword(_emailField.text);
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 14, color: primaryColour),
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
