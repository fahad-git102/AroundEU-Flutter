import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/firebase/fcm_service.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/views/auth/forgot_password_screen.dart';
import 'package:groupchat/views/auth/register_screen.dart';
import 'package:groupchat/views/admin_screens/admin_home_screen.dart';
import 'package:groupchat/views/home_screens/home_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/button.dart';
import '../../component_library/text_fields/custom_text_field.dart';
import '../../component_library/text_widgets/small_light_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/validation.dart';
import '../../firebase/auth.dart';
import '../../firebase/auth_exception_handling.dart';

class LoginScreen extends StatefulWidget {
  static const route = "LoginScreen";

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  updateState() {
    setState(() {});
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      print('Error: $e');
    }
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
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0.sp),
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
        child: Stack(
          children: [
            Container(
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
                child: Form(
                  key: _formKey,
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
                        validator: (value) {
                          return Validation().validateEmail(value);
                        },
                      ),
                      SizedBox(
                        height: 10.0.sp,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        labelText: "Password".tr(),
                        obscureText: true,
                        validator: (value) {
                          return Validation().validateEmptyField(value,
                              message: 'Password required'.tr());
                        },
                      ),
                      SizedBox(
                        height: 30.0.sp,
                      ),
                      Consumer(builder: (ctx, ref, child) {
                        var usersPro = ref.watch(appUserProvider);
                        return Button(
                            text: "Log In".tr(),
                            tapAction: () {
                              if (_formKey.currentState!.validate()) {
                                isLoading = true;
                                updateState();
                                signInUserWithEmailAndPassword(usersPro);
                              }
                            });
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
                                builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15.0.sp,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  isLoading = true;
                                  updateState();
                                  facebookLogin();
                                },
                                child: SvgPicture.asset(
                                  Images.facebookIcon,
                                  colorFilter: ColorFilter.mode(
                                      AppColors.mainColorDark, BlendMode.srcIn),
                                  height: 40.0.sp,
                                  width: 40.0.sp,
                                ),
                              ),
                              SizedBox(
                                width: 11.0.sp,
                              ),
                              InkWell(
                                onTap: () {
                                  isLoading = true;
                                  updateState();
                                  googleSignIn();
                                },
                                child: SvgPicture.asset(
                                  Images.googleIcon,
                                  colorFilter: ColorFilter.mode(
                                      AppColors.mainColorDark, BlendMode.srcIn),
                                  height: 40.0.sp,
                                  width: 40.0.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 13.sp,
                          ),
                          Platform.isIOS
                              ? ExtraMediumText(
                                  title: 'OR'.tr(),
                                  textColor: AppColors.lightBlack,
                                )
                              : Container(),
                          SizedBox(
                            height: 13.sp,
                          ),
                          Platform.isIOS
                              ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                child: SignInWithAppleButton(
                                    onPressed: signInWithApple),
                              )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FullScreenLoader(
              loading: isLoading,
            )
          ],
        ),
      ),
    );
  }

  Future<void> signInUserWithEmailAndPassword(AppUserProvider usersPro) async {
    isLoading = true;
    updateState();
    final status = await Auth().signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    if (status == AuthStatus.successful) {
      await usersPro.getCurrentUser();
      isLoading = false;
      updateState();
      FcmService().updateTokenOnLogin();
      if (usersPro.currentUser != null) {
        if (usersPro.currentUser?.admin == true) {
          navigate(AdminHomeScreen.route);
        } else {
          navigate(HomeScreen.route);
        }
      } else {
        Auth().signOut();
        Utilities()
            .showErrorMessage(context, message: 'User does not exists'.tr());
      }
    } else {
      isLoading = false;
      updateState();
      final error = AuthExceptionHandler.generateErrorMessage(status);
      Utilities().showErrorMessage(context, message: error);
    }
  }

  navigate(String route) {
    isLoading = false;
    updateState();
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  googleSignIn() {}

  facebookLogin() {}
}
