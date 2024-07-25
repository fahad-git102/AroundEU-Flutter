import 'package:flutter/material.dart';
import 'package:groupchat/views/auth/login_screen.dart';
import 'package:groupchat/views/auth/splash_screen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'CeraPro',
          textTheme: const TextTheme(
            bodyText1: TextStyle(fontFamily: 'CeraPro'),
            bodyText2: TextStyle(fontFamily: 'CeraPro'),
            headline1: TextStyle(fontFamily: 'CeraPro'),
            headline2: TextStyle(fontFamily: 'CeraPro'),
            // Add more text styles as needed
          ),
        ),
        home: LoginScreen(),
      );
    });
  }
}
