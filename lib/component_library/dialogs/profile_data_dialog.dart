import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/data/users_model.dart';
import 'package:groupchat/firebase/auth.dart';
import 'package:groupchat/views/home_screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/disabled_focus_node.dart';
import '../../core/size_config.dart';
import '../../core/static_keys.dart';
import '../../core/utilities_class.dart';
import '../../core/validation.dart';
import '../../firebase/fcm_service.dart';
import '../../firebase/firebase_crud.dart';
import '../../providers/app_user_provider.dart';
import '../../repositories/users_repository.dart';
import '../../views/profile_screens/full_image_screen.dart';
import '../buttons/button.dart';
import '../buttons/radio_button_with_text.dart';
import '../image_widgets/circle_image_avatar.dart';
import '../text_fields/custom_text_field.dart';
import '../text_fields/simple_text_field.dart';
import '../text_widgets/small_light_text.dart';

class ProfileDataDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileDataDialogState();
}

class _ProfileDataDialogState extends State<ProfileDataDialog> {
  XFile? pickedFile;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  bool? isLoading = false;
  bool isTeacher = false;
  final _formKey = GlobalKey<FormState>();

  updateState() {
    setState(() {});
  }

  @override
  void initState() {
    if (Auth().currentUser != null) {
      nameController.text = Auth().currentUser?.displayName ?? '';
      emailController.text = Auth().currentUser?.email ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.sp),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 6.sp,),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                    child: ExtraMediumText(
                      title: 'Please complete your profile'.tr(),
                      textColor: AppColors.lightBlack,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 16.sp,),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
                    child: Stack(
                      children: <Widget>[
                        pickedFile != null
                            ? SizedBox(
                                height: 100.0.sp,
                                width: 100.sp,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.backGroundLightWhite,
                                  radius: 60.0,
                                  child: ClipOval(
                                    child: Image.file(
                                      File(pickedFile!.path),
                                      height: 170.0.sp,
                                      width: 170.0.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: Auth().currentUser?.photoURL != null &&
                                        Auth().currentUser?.photoURL?.isNotEmpty ==
                                            true
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FullImageScreen(
                                              imageUrl:
                                                  Auth().currentUser?.photoURL ??
                                                      '',
                                            ),
                                          ),
                                        );
                                      }
                                    : () {},
                                child: CircleImageAvatar(
                                  imagePath: Auth().currentUser?.photoURL,
                                  size: 100.0.sp,
                                ),
                              ),
                        Positioned(
                            bottom: 1,
                            right: 1,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: 3.0.sp, bottom: 3.0.sp),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black87.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset:
                                            const Offset(1, 1), // Shadow position
                                      ),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.sp))),
                                child: InkWell(
                                  onTap: () async {
                                    Utilities().showImagePickerDialog(context,
                                        onCameraTap: () async {
                                      Navigator.of(context).pop();
                                      pickedFile = await Utilities.pickImage(
                                          imageSource: 'camera');
                                      updateState();
                                    }, onGalleryTap: () async {
                                      Navigator.of(context).pop();
                                      pickedFile = await Utilities.pickImage(
                                          imageSource: 'gallery');
                                      updateState();
                                    });
                                  },
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 15.0.sp,
                                    color: const Color(0xFF404040),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: SmallLightText(
                    title: 'Email'.tr(),
                    textColor: AppColors.lightBlack,
                  ),
                ),
                SizedBox(
                  height: 4.0.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 13.0.sp),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.lightFadedTextColor, width: 0.4.sp),
                        borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                    child: SimpleTextField(
                      controller: emailController,
                      hintText: 'Email'.tr(),
                      validator: (value) {
                        return Validation().validateEmptyField(value, message: 'Email required'.tr());
                      },
                      noBorder: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: SmallLightText(
                    title: 'Name'.tr(),
                    textColor: AppColors.lightBlack,
                  ),
                ),
                SizedBox(
                  height: 4.0.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 13.0.sp),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.lightFadedTextColor, width: 0.4.sp),
                        borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                    child: SimpleTextField(
                      controller: nameController,
                      hintText: 'Name'.tr(),
                      validator: (value) {
                        return Validation().validateEmptyField(value, message: 'Name required'.tr());
                      },
                      noBorder: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: SmallLightText(
                    title: 'Date of Birth'.tr(),
                    textColor: AppColors.lightBlack,
                  ),
                ),
                SizedBox(
                  height: 4.0.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 13.0.sp),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.lightFadedTextColor, width: 0.4.sp),
                        borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                    child: Row(
                      children: [
                        Expanded(
                          child: SimpleTextField(
                            controller: dobController,
                            hintText: "Date of Birth".tr(),
                            noBorder: true,
                            focusNode: AlwaysDisabledFocusNode(),
                            validator: (value) {
                              return Validation().validateEmptyField(value,
                                  message: 'Date of birth required'.tr());
                            },
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.calendar_month,
                            color: AppColors.mainColorDark,
                          ),
                          onTap: () async {
                            datePicker();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: SmallLightText(
                    title: 'About'.tr(),
                    textColor: AppColors.lightBlack,
                  ),
                ),
                SizedBox(
                  height: 4.0.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 13.0.sp),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.lightFadedTextColor, width: 0.4.sp),
                        borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                    child: SimpleTextField(
                      controller: aboutController,
                      minLines: 3,
                      hintText: 'About'.tr(),
                      validator: (value) {
                        return Validation().validateEmptyField(value, message: 'About required'.tr());
                      },
                      noBorder: true,
                    ),
                  ),
                ),
                SizedBox(height: 12.sp,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: Row(
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
                ),
                SizedBox(
                  height: 20.0.sp,
                ),
                isLoading == true
                    ? SpinKitPulse(
                        color: AppColors.mainColorDark,
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.sp),
                        child: Consumer(
                          builder: (ctx, ref, child) {
                            var userPro = ref.watch(appUserProvider);
                            return Button(text: 'Save'.tr(), tapAction: () {
                              if(_formKey.currentState!.validate()){
                                updateProfile(userPro);
                              }
                            });
                          }
                        ),
                      ),
                SizedBox(
                  height: 12.0.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> datePicker() async {
    DateTime? pickedDate =
        await Utilities().datePicker(context, AppColors.mainColorDark);
    if (pickedDate != null) {
      dobController.text = pickedDate.day < 10
          ? "0${pickedDate.day.toString()} ${Utilities().getMonthShortName(pickedDate.month)}, ${pickedDate.year.toString()}"
          : "${pickedDate.day.toString()} ${Utilities().getMonthShortName(pickedDate.month)}, ${pickedDate.year.toString()}";
      updateState();
    }
  }

  updateProfile(AppUserProvider userPro) async {
    isLoading = true;
    updateState();
    String? imageUrl = pickedFile!=null ? await FirebaseCrud()
        .uploadImage(context: context, file: File(pickedFile!.path)) : null;
    Map<String, dynamic> map = pickedFile!=null ? {
      'firstName': nameController.text,
      'surName': '',
      'about': aboutController.text,
      'email': emailController.text,
      'dob': dobController.text,
      'admin': false,
      'userType': isTeacher ? teacher : student,
      'uid': Auth().currentUser?.uid,
      'profileUrl': imageUrl,
      'joinedOn': DateTime.now().millisecondsSinceEpoch,
    } : {
      'firstName': nameController.text,
      'surName': '',
      'joinedOn': DateTime.now().millisecondsSinceEpoch,
      'email': emailController.text,
      'dob': dobController.text,
      'admin': false,
      'userType': isTeacher ? teacher : student,
      'uid': Auth().currentUser?.uid,
      'about': aboutController.text,
    };
    UsersRepository().addUser(AppUser.fromMap(map), context, () {
      isLoading = false;
      updateState();
      userPro.getCurrentUser();
      FcmService().updateTokenOnLogin();
      Utilities().showSuccessDialog(context,
          message: 'Your profile is updated successfully'.tr(), onBtnTap: () {
            Navigator.pushNamedAndRemoveUntil(context, HomeScreen.route, (route)=> false);
          });
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context,
          message: 'Error: ${p0.toString()}'.tr(), onBtnTap: () {
            Navigator.pop(context);
          });
    });
  }
}
