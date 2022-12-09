import 'package:flutter/material.dart';
import 'package:gallery_app/net/flutterfire.dart';
import 'package:gallery_app/ui/home_view.dart';
import 'package:gallery_app/utlis/colors.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: backgroundColour,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailField,
              decoration: const InputDecoration(
                hintText: "example@email.com",
                labelText: "Email",
              ),
            ),
            TextFormField(
              controller: _passwordField,
              obscureText: true, //hide password characters
              decoration: const InputDecoration(
                labelText: "Password",
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
                  bool shouldNavigate =
                      await signIn(_emailField.text, _passwordField.text);
                  if (shouldNavigate) {
                    // Navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(),
                      ),
                    );
                  }
                  //handle error by else and then create or fill a widget with the error
                },
                child: const Text("Login"),
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
                  bool shouldNavigate =
                      await signUp(_emailField.text, _passwordField.text);
                  if (shouldNavigate) {
                    // Navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(),
                      ),
                    );
                  }
                  //handle error by else and then create or fill a widget with the error
                },
                child: const Text("Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
