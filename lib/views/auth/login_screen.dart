import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/views/auth/forgot_password_screen.dart';
import 'package:groupchat/views/auth/register_screen.dart';
import 'package:groupchat/views/home_screens/home_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/button.dart';
import '../../component_library/text_fields/custom_text_field.dart';
import '../../component_library/text_widgets/small_light_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../firebase/auth.dart';
import '../../firebase/auth_exception_handling.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RegisterScreen()),
                );
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
                      isLoading = true;
                      updateState();
                      signInUserWithEmailAndPassword();
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ForgotPasswordScreen()),
                    );
                  },
                ),

                SizedBox(height: 15.0.sp,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Platform.isIOS ? InkWell(
                      onTap: () async {
                        signInWithApple();
                      },
                      child: SvgPicture.asset(
                        Images.appleIcon,
                        colorFilter: ColorFilter.mode(AppColors.mainColorDark, BlendMode.srcIn),
                        height: 40.0.sp,
                        width: 40.0.sp,
                      ),
                    ): Container(),
                    Platform.isIOS ? SizedBox(width: 11.0.sp,) : Container(),
                    InkWell(
                      onTap: (){
                        isLoading = true;
                        updateState();
                        facebookLogin();
                      },
                      child: SvgPicture.asset(
                        Images.facebookIcon,
                        colorFilter: ColorFilter.mode(AppColors.mainColorDark, BlendMode.srcIn),
                        height: 40.0.sp,
                        width: 40.0.sp,
                      ),
                    ),
                    SizedBox(width: 11.0.sp,),
                    InkWell(
                      onTap: (){
                        isLoading = true;
                        updateState();
                        googleSignIn();
                      },
                      child: SvgPicture.asset(
                        Images.googleIcon,
                        colorFilter: ColorFilter.mode(AppColors.mainColorDark, BlendMode.srcIn),
                        height: 40.0.sp,
                        width: 40.0.sp,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInUserWithEmailAndPassword() async {
    final status = await Auth().signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    if (status == AuthStatus.successful) {
      Utilities().showSnackbar(context, 'Auth successful.. $status');
    } else {
      isLoading = false;
      updateState();
      final error = AuthExceptionHandler.generateErrorMessage(status);
      Utilities().showSnackbar(context, error);
    }
  }

  googleSignIn(){

  }

  facebookLogin(){

  }

  signInWithApple(){

  }
}