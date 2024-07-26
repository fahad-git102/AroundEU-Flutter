import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/back_button.dart';
import '../../component_library/buttons/radio_button_with_text.dart';
import '../../component_library/loaders/full_screen_loader.dart';
import '../../component_library/text_fields/custom_text_field.dart';
import '../../component_library/text_widgets/extra_large_medium_bold_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/disabled_focus_node.dart';
import '../../core/utilities_class.dart';

class RegisterScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
  
}

class _RegisterScreenState extends State<RegisterScreen>{

  TextEditingController firstNameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool? isLoading = false;
  bool isTeacher = false;

  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 18.0.sp,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: BackIconButton(
                          size: 24.0.sp,
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Image.asset(
                        Images.logoAroundEU,
                        height: 120.0.sp,
                        width: 120.0.sp,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 10.0.sp,),
                      ExtraLargeMediumBoldText(
                          title: "Sign Up".tr(),
                          textAlign: TextAlign.center,
                          textColor: AppColors.lightBlack),
                      SizedBox(
                        height: 20.0.sp,
                      ),
                      CustomTextField(
                        controller: firstNameController,
                        labelText: "First Name".tr(),
                      ),
                      SizedBox(height: 5.0.sp,),
                      CustomTextField(
                        controller: surNameController,
                        labelText: "Surname".tr(),
                      ),
                      SizedBox(height: 5.0.sp,),
                      CustomTextField(
                        controller: emailController,
                        labelText: "Email".tr(),
                      ),
                      SizedBox(height: 5.0.sp,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CountryCodePicker(
                            onChanged: (countryCode){

                            },
                            initialSelection: 'IT',
                            favorite: const ['+39','IT'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: phoneController,
                              labelText: "Phone".tr(),
                              allowNumbersOnly: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0.sp,),
                      CustomTextField(
                        controller: dobController,
                        labelText: "Date of Birth".tr(),
                        focusNode: AlwaysDisabledFocusNode(),
                        suffixIcon: InkWell(
                          child: Icon(
                            Icons.calendar_month,
                            color: AppColors.mainColorDark,
                          ),
                          onTap: () async {
                            datePicker();
                          },
                        ),
                        onTap: () {
                          datePicker();
                        },
                      ),
                      SizedBox(height: 5.0.sp,),
                      CustomTextField(
                        controller: countryController,
                        labelText: "Country".tr(),
                        focusNode: AlwaysDisabledFocusNode(),
                        onTap: (){
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false, // optional. Shows phone code before the country name.
                            onSelect: (Country country) {
                              countryController.text = country.name;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 5.0.sp,),
                      CustomTextField(
                        controller: passwordController,
                        obscureText: true,
                        labelText: "Password".tr(),
                      ),
                      SizedBox(height: 5.0.sp,),
                      CustomTextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        labelText: "Confirm Password".tr(),
                      ),
                      SizedBox(height: 25.0.sp,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RadioButtonWithTextOption(
                              title: "Teacher".tr(),
                              active: isTeacher,
                              titleColor: AppColors.extraLightBlack,
                              thumbColor: AppColors.mainColorDark,
                              size: 17.0.sp,
                              onTap: () {
                                isTeacher = true;
                                updateState();
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioButtonWithTextOption(
                              title: "Student".tr(),
                              active: !isTeacher,
                              size: 17.0.sp,
                              thumbColor: AppColors.mainColorDark,
                              titleColor: AppColors.extraLightBlack,
                              onTap: () {
                                isTeacher = false;
                                updateState();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0.sp,),
                      Button(text: 'Sign Up'.tr(), tapAction: (){

                      }),
                      SizedBox(height: 50.0.sp,)
                    ],
                  ),
                ),
              ),
            ),
            FullScreenLoader(
              loading: isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> datePicker() async {
    DateTime? pickedDate =
    await Utilities().datePicker(context, AppColors.mainColorDark);
    if (pickedDate != null) {
      dobController.text =
      "${pickedDate.day.toString()}-${pickedDate.month.toString()}-${pickedDate.year.toString()}";
      updateState();
    }
  }
  
}