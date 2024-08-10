import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/views/home_screens/admin_home_screen.dart';
import 'package:groupchat/views/home_screens/home_screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';
import '../../core/static_keys.dart';
import '../../firebase/auth.dart';
import '../home_screens/teachers_home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = 'SplashScreen';
  @override
  State<StatefulWidget> createState() => _SplasScreenState();

}

class _SplasScreenState extends State<SplashScreen> {

  bool? pageStarted = true;

  navigate(String route, {Map<String, dynamic>? arguments}){
    Navigator.pushNamedAndRemoveUntil(context, route, (Route<dynamic> route) => false, arguments: arguments);
  }

  getUserAndNavigate(WidgetRef ref) async {
    var appUserPro = ref.watch(appUserProvider);
    if(Auth().currentUser!=null){
      await appUserPro.getCurrentUser();
      if (appUserPro.currentUser != null) {
        if (appUserPro.currentUser?.admin == true) {
          navigate(AdminHomeScreen.route);
        } else {
          if (appUserPro.currentUser?.userType == teacher) {
            navigate(TeachersHomeScreen.route);
          } else {
            navigate(HomeScreen.route);
          }
        }
      }else{
        Auth().signOut();
        navigate(LoginScreen.route);
      }
    }else{
      Auth().signOut();
      navigate(LoginScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Consumer(builder: (ctx, ref, child){
            if(pageStarted==true){
              pageStarted = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getUserAndNavigate(ref);
              });
            }
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.mainBackground),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Image.asset(
                  Images.logoAroundEU,
                  height: 180.0.sp,
                  width: 180.0.sp,
                  fit: BoxFit.fill,
                ),
              ),
            );
          },)),
    );
  }

}