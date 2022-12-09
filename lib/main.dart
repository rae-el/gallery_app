import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gallery_app/ui/authentication_view.dart';
import 'package:gallery_app/utlis/colors.dart';
import 'firebase_options.dart';

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
        errorColor: Colors.red[500],
        highlightColor: secondaryColour,
        textTheme: const TextTheme(
          headline1: TextStyle(fontWeight: FontWeight.bold),
          bodyText1: TextStyle(color: textColour),
          bodyText2: TextStyle(color: textColour),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColour, // background (button) color
            foregroundColor: Colors.white, // foreground (text) color
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColour,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.accent,
        ),
      ),
      //first page is the authentication
      home: Authentication(),
    );
  }
}
