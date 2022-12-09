import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gallery_app/ui/auth/authentication_view.dart';
import 'package:gallery_app/ui/startup/startup_view.dart';
import 'package:gallery_app/app/colors.dart';
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery',
      theme: ThemeData(
        //basic theme data that could use some updating
        brightness: Brightness.dark,
        primaryColor: primaryColour,
        errorColor: tertiaryColour,
        highlightColor: secondaryColour,
        textTheme: const TextTheme(
          headline1: TextStyle(fontWeight: FontWeight.bold),
          bodyText1: TextStyle(color: textColour),
          bodyText2: TextStyle(color: textColour),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColour, // background (button) color
            foregroundColor: textColour, // foreground (text) color
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: primaryColour,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.accent,
        ),
      ),
      //first page is the authentication
      home: const StartupView(),
    );
  }
}
