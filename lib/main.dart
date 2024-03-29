import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gallery_app/app/app.locator.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:gallery_app/ui/shared/setup_dialog_ui.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/app.router.dart';
import 'services/firebase_options.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupDialogUi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //final router = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery',
      theme: ThemeData(
        //basic theme data that could use some updating
        brightness: Brightness.dark,
        primaryColor: primaryColour,
        highlightColor: secondaryColour,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: textColour),
          bodyMedium: TextStyle(color: textColour),
          labelLarge: TextStyle(color: textColour, fontSize: 17),
          labelSmall: TextStyle(color: primaryColour, fontSize: 15),
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
        colorScheme: const ColorScheme(
            error: errorColour,
            background: backgroundColour,
            brightness: Brightness.dark,
            onBackground: textColour,
            onError: backgroundColour,
            onPrimary: backgroundColour,
            onSecondary: backgroundColour,
            onSurface: textColour,
            primary: primaryColour,
            secondary: secondaryColour,
            surface: secondaryBackgroundColour),
      ),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
