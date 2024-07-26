import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/back_button.dart';
import '../../component_library/buttons/button.dart';
import '../../component_library/loaders/full_screen_loader.dart';
import '../../component_library/text_fields/custom_text_field.dart';
import '../../component_library/text_widgets/extra_large_medium_bold_text.dart';
import '../../component_library/text_widgets/extra_medium_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';

class ForgotPasswordScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();

}

class _ForgotPasswordState extends State<ForgotPasswordScreen>{
  TextEditingController emailController = TextEditingController();
  bool? isLoading = false;

  updateState(){
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            child: Stack(
              children: [
                SizedBox(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  child: Center(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.symmetric(horizontal: 25.0.sp),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightBlack, width: 1.3.sp),
                          borderRadius: BorderRadius.all(Radius.circular(6.0.sp)),
                          color: AppColors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.5, 1.0),
                                blurRadius: 6.0)
                          ]),
                      padding: EdgeInsets.all(20.0.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ExtraLargeMediumBoldText(
                            title: "Forgot Password".tr(),
                            textColor: AppColors.lightBlack,
                            fontSize: 20.0.sp,
                          ),
                          SizedBox(height: 13.0.sp),
                          ExtraMediumText(
                            fontWeight: FontWeight.normal,
                            title: "Enter email address".tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          SizedBox(height: 12.0.sp,),
                          CustomTextField(controller: emailController, labelText: "Email".tr(), keyboardType: TextInputType.emailAddress),
                          SizedBox(height: 20.0.sp),
                          Button(text: "Send Email".tr(), btnColor: AppColors.mainColor, tapAction: () async {
                            if(emailController.text.isEmpty){
                              Utilities().showSnackbar(context, "Please provide a valid email".tr());
                            }else{
                              isLoading = true;
                              updateState();
                              sendEmail();
                            }
                          })
                        ],
                      ),
                    ),
                  ),
                ),
                FullScreenLoader(
                  loading: isLoading,
                ),
                Positioned(
                  top: 20.0,
                  left: 16.0,
                  child: BackIconButton(
                    size: 24.0.sp,
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                  )
                ),
              ],
            )
          )
      ),
    );
  }

  sendEmail(){

  }

}