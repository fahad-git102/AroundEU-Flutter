import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/views/auth/login_screen.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA2ukLzcnUv4WLoqhFmX9fC79QCjZoG0lo',
        appId: '1:942050510362:android:8ca22ab38aadedd148f3a3',
        messagingSenderId: '942050510362',
        projectId: 'eprojectconsult-9d70e',
        storageBucket: 'eprojectconsult-9d70e.appspot.com',
      )
  );
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
          primarySwatch: createMaterialColor(AppColors.mainColor),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
          useMaterial3: true,
          fontFamily: 'CeraPro',
        ),
        home: LoginScreen(),
      );
    });
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
