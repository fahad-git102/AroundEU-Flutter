import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/data/users_model.dart';
import 'package:groupchat/repositories/users_repository.dart';
import 'package:groupchat/views/auth/login_screen.dart';
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
import '../../core/validation.dart';
import '../../firebase/auth.dart';
import '../../firebase/auth_exception_handling.dart';

class RegisterScreen extends StatefulWidget{
  static const route = 'RegisterScreen';
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
  String selectedCountryCode = '+39';
  final _formKey = GlobalKey<FormState>();

  updateState(){
    setState(() {

    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    surNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    countryController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
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
                  child: Form(
                    key: _formKey,
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
                          validator: (value) {
                            return Validation().validateEmptyField(value, message: 'First name required'.tr());
                          },
                        ),
                        SizedBox(height: 5.0.sp,),
                        CustomTextField(
                          controller: surNameController,
                          labelText: "Surname".tr(),
                          validator: (value) {
                            return Validation().validateEmptyField(value, message: 'Surname required'.tr());
                          },
                        ),
                        SizedBox(height: 5.0.sp,),
                        CustomTextField(
                          controller: emailController,
                          labelText: "Email".tr(),
                          validator: (value) {
                            return Validation().validateEmptyField(value, message: 'Email required'.tr());
                          },
                        ),
                        SizedBox(height: 5.0.sp,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CountryCodePicker(
                              onChanged: (countryCode){
                                selectedCountryCode = countryCode.toString();
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
                                validator: (value) {
                                  return Validation().validateEmptyField(value, message: 'Phone required'.tr());
                                },
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
                          validator: (value) {
                            return Validation().validateEmptyField(value, message: 'Date of birth required'.tr());
                          },
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
                          validator: (value) {
                            return Validation().validateEmptyField(value, message: 'Country required'.tr());
                          },
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
                          validator: (value) {
                            return Validation().validateEmptyField(value, message: 'Password required'.tr());
                          },
                        ),
                        SizedBox(height: 5.0.sp,),
                        CustomTextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          labelText: "Confirm Password".tr(),
                          validator: (value) {
                            return Validation().validateEmptyField(value, message: 'Password required'.tr());
                          },
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
                          if(_formKey.currentState!.validate()){
                            if(passwordController.text!=confirmPasswordController.text){
                              Utilities().showErrorMessage(context, message: 'Passwords didn\'t match'.tr());
                              return;
                            }
                            isLoading = true;
                            updateState();
                            signUpUser();
                          }
                        }),
                        SizedBox(height: 50.0.sp,)
                      ],
                    ),
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
      dobController.text = pickedDate.day <10 ? "0${pickedDate.day.toString()} ${Utilities().getMonthShortName(pickedDate.month)}, ${pickedDate.year.toString()}" :
      "${pickedDate.day.toString()} ${Utilities().getMonthShortName(pickedDate.month)}, ${pickedDate.year.toString()}";
      updateState();
    }
  }

  Future<void> signUpUser() async {

    final status = await Auth().createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        name: '${firstNameController.text} ${surNameController.text}');
    if (status == AuthStatus.successful) {
      Map map = {
        'admin': false,
        'uid': Auth().currentUser?.uid,
        'firstName': firstNameController.text,
        'surName': surNameController.text,
        'email': emailController.text,
        'country': countryController.text,
        'dob': dobController.text,
        'phone': '$selectedCountryCode${phoneController.text}',
        'userType': isTeacher ? teacher : student,
        'joinedOn': DateTime.now().millisecondsSinceEpoch,
        'joined': false,
      };
      AppUser appUser = AppUser.fromMap(map);
      UsersRepository().addUser(appUser, context, () {
        Auth().signOut();
        isLoading = false;
        updateState();
        Utilities().showSuccessDialog(context,
            message: "Account created successfully".tr(),
            barrierDismissle: false,
            onBtnTap: (){
          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (route) => false);
        });
      }, (p0){
        Auth().signOut();
        isLoading = false;
        updateState();
        Utilities().showErrorMessage(context, message: p0.toString());
      });
    } else {
      isLoading = false;
      updateState();
      final error = AuthExceptionHandler.generateErrorMessage(status);
      Utilities().showErrorMessage(context, message: error);
    }
  }
  
}