import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';

class SplashScreen extends StatefulWidget {
  static const route = 'SplashScreen';
  @override
  State<StatefulWidget> createState() => _SplasScreenState();

}

class _SplasScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
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
          )),
    );
  }

}