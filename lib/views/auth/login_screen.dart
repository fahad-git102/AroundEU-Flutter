import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/button.dart';
import '../../component_library/text_fields/custom_text_field.dart';
import '../../component_library/text_widgets/small_light_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10.0.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmallLightText(
              title: "Don't have an account?".tr(),
              textColor: AppColors.fadedTextColor,
            ),
            SizedBox(
              width: 4.0.sp,
            ),
            InkWell(
              onTap: () {

              },
              child: Padding(
                padding:
                EdgeInsets.symmetric(vertical: 5.0.sp),
                child: SmallLightText(
                  fontWeight: FontWeight.w800,
                  title: "Sign Up".tr(),
                  textColor: AppColors.lightBlack,
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.mainBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50.0.sp,
                ),
                Image.asset(
                  Images.logoAroundEU,
                  height: 120.0.sp,
                  width: 120.0.sp,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 20.0.sp,
                ),
                CustomTextField(
                  controller: emailController,
                  labelText: "Email".tr(),
                ),
                SizedBox(
                  height: 10.0.sp,
                ),
                CustomTextField(
                  controller: passwordController,
                  labelText: "Password".tr(),
                  obscureText: true,
                ),
                SizedBox(
                  height: 30.0.sp,
                ),
                Button(
                    text: "Log In".tr(),
                    tapAction: () {

                    }),
                InkWell(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0.sp),
                      child: SmallLightText(
                        title: "Forgot Password ?".tr(),
                        textColor: AppColors.fadedTextColor2,
                      ),
                    ),
                  ),
                  onTap: () {

                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}