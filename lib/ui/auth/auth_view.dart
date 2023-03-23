import 'package:flutter/material.dart';
import 'package:gallery_app/ui/auth/auth_view_model.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

import '../../app/fonts.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => AuthenticationState();
}

class AuthenticationState extends State<AuthView> {
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
                  'Login To Gallery',
                  style: maxTitleFont,
                ),
                SizedBox(
                  width: 225,
                  height: 75,
                  child: Image.asset(model.logoLocation),
                ),
                TextFormField(
                  controller: _emailField,
                  validator: model.validateFormEmail,
                  decoration: const InputDecoration(
                    hintText: "example@email.com",
                    labelText: "Email",
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                TextFormField(
                  controller: _passwordField,
                  validator: model.validateFormPassword,
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
                MaterialButton(
                  onPressed: () async {
                    await model.forgotPassword(email: _emailField.text);
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: primaryColour,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await model.signIn(
                          email: _emailField.text,
                          password: _passwordField.text);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: textColour),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await model.signUp(
                          email: _emailField.text,
                          password: _passwordField.text);
                    },
                    child: const Text(
                      "Sign Up",
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
