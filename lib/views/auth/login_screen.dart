import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groupchat/component_library/dialogs/profile_data_dialog.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
  bool _isTermsAccepted = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  updateState() {
    setState(() {});
  }

  // Future<void> signInWithApple() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );
  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: credential.identityToken,
  //       accessToken: credential.authorizationCode,
  //     );
  //
  //     await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void> signInWithApple(AppUserProvider usersPro) async {
    User? user;
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    AuthorizationCredentialAppleID? appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
    } catch (e) {
      print('Error: ${e.toString()}');
    }

    if (appleCredential != null) {
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      try {
        user =
            (await FirebaseAuth.instance.signInWithCredential(oauthCredential)).user;

        checkUserExists(user, context, usersPro);

      } on FirebaseAuthException catch (e) {
        Utilities().showCustomToast(message: e.message, isError: true);
      }
      return null;
    }
  }

  Future<void> checkUserExists(User? user, BuildContext context, AppUserProvider usersPro) async {
    if (user == null) {
      Utilities().showCustomToast(message: "User not found!", isError: true);
      return;
    }
    isLoading = true;
    updateState();
    String uid = user.uid;
    final databaseReference = FirebaseDatabase.instance.ref();
    try {
      final userSnapshot = await databaseReference.child(users).child(uid).get();
      isLoading = false;
      updateState();
      if (userSnapshot.exists) {
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
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ProfileDataDialog(),
        );
      }
    } catch (e) {
      isLoading = false;
      updateState();
      Utilities().showCustomToast(message: "Error: $e", isError: true);
    }
  }

  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10.0.sp,
                        ),
                        Image.asset(
                          Images.logoAroundEU,
                          height: 110.0.sp,
                          width: 110.0.sp,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: 10.0.sp,
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
                        SizedBox(height: 15.sp,),
                        Row(
                          children: [
                            Checkbox(
                              value: _isTermsAccepted,
                              onChanged: (value) {
                                setState(() {
                                  _isTermsAccepted = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: _launchURL,
                                child: Text.rich(
                                  TextSpan(
                                    text: 'I agree to the ',
                                    style: TextStyle(fontSize: 10.sp),
                                    children: [
                                      TextSpan(
                                        text: 'Terms and Conditions',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: AppColors.blue,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.blue, // Changes the underline color
                                          decorationStyle: TextDecorationStyle.solid,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                                  if(_isTermsAccepted==true){
                                    isLoading = true;
                                    updateState();
                                    signInUserWithEmailAndPassword(usersPro);
                                  }else{
                                    Utilities().showCustomToast(message: 'Please accept the terms and conditions first'.tr(), isError: true);
                                  }
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
                                  child: Consumer(
                                    builder: (ctx, ref, child) {
                                      var usersPro = ref.watch(appUserProvider);
                                      return SignInWithAppleButton(
                                          onPressed: (){
                                            signInWithApple(usersPro);
                                          }
                                      );
                                    }
                                  ),
                                )
                                : Container(),
                            SizedBox(height: 20.sp,),
                            Padding(
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
                            SizedBox(height: 30.sp,)
                          ],
                        ),
                      ],
                    ),
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

  void _launchURL() async {
    // const url = 'https://www.termsfeed.com/live/60a5b8b9-d440-4eff-a25a-21a8e9617b5b'; // Replace with your URL
    const url = 'https://app.enzuzo.com/policies/tos/9a7d476a-dd8f-11ef-9188-7f55d2c57fd2';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the URL.';
    }
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
