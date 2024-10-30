import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/text_fields/simple_text_field.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/users_repository.dart';
import 'package:groupchat/views/profile_screens/full_image_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../firebase/firebase_crud.dart';
import '../image_widgets/circle_image_avatar.dart';
import '../text_widgets/small_light_text.dart';

class UpdateProfileDialog extends StatefulWidget {

  String? firstName, surName, about;


  @override
  State<StatefulWidget> createState() => _UpdateProfileDialogState();

  UpdateProfileDialog({
    this.firstName,
    this.surName,
    this.about,
  });
}

class _UpdateProfileDialogState extends State<UpdateProfileDialog> {
  XFile? pickedFile;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  bool? isLoading = false;

  updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    firstNameController.dispose();
    surnameController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    firstNameController.text = widget.firstName ?? '';
    surnameController.text = widget.surName ?? '';
    aboutController.text = widget.about ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Consumer(
        builder: (ctx, ref, child) {
          var appUserPro = ref.watch(appUserProvider);
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.all(13.0.sp),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0.sp,
                      ),
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
                                        backgroundColor:
                                            AppColors.backGroundLightWhite,
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
                                      onTap: appUserPro.currentUser?.profileUrl !=
                                              null
                                          ? () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullImageScreen(
                                                    imageUrl: appUserPro
                                                            .currentUser
                                                            ?.profileUrl ??
                                                        '',
                                                  ),
                                                ),
                                              );
                                            }
                                          : () {},
                                      child: CircleImageAvatar(
                                        imagePath:
                                            appUserPro.currentUser?.profileUrl,
                                        size: 100.0.sp,
                                      ),
                                    ),
                              Positioned(
                                  bottom: 1,
                                  right: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 3.0.sp, bottom: 3.0.sp),
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black87.withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: const Offset(
                                                  1, 1), // Shadow position
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.sp))),
                                      child: InkWell(
                                        onTap: () async {
                                          Utilities().showImagePickerDialog(context,
                                              onCameraTap: () async {
                                                Navigator.of(context).pop();
                                                pickedFile = await Utilities.pickImage(imageSource: 'camera');
                                                updateState();
                                              }, onGalleryTap: () async {
                                                Navigator.of(context).pop();
                                                pickedFile =
                                                await Utilities.pickImage(imageSource: 'gallery');
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
                      SmallLightText(
                        title: 'First Name'.tr(),
                        textColor: AppColors.lightBlack,
                      ),
                      SizedBox(
                        height: 4.0.sp,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0.sp, horizontal: 13.0.sp),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.lightFadedTextColor,
                                width: 0.4.sp),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.sp))),
                        child: SimpleTextField(
                          controller: firstNameController,
                          noBorder: true,
                        ),
                      ),
                      SizedBox(
                        height: 10.0.sp,
                      ),
                      SmallLightText(
                        title: 'Surname'.tr(),
                        textColor: AppColors.lightBlack,
                      ),
                      SizedBox(
                        height: 4.0.sp,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0.sp, horizontal: 13.0.sp),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.lightFadedTextColor,
                                width: 0.4.sp),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.sp))),
                        child: SimpleTextField(
                          controller: surnameController,
                          noBorder: true,
                        ),
                      ),
                      SizedBox(
                        height: 10.0.sp,
                      ),
                      SmallLightText(
                        title: 'About'.tr(),
                        textColor: AppColors.lightBlack,
                      ),
                      SizedBox(
                        height: 4.0.sp,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0.sp, horizontal: 13.0.sp),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.lightFadedTextColor,
                                width: 0.4.sp),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.sp))),
                        child: SimpleTextField(
                          controller: aboutController,
                          noBorder: true,
                        ),
                      ),
                      SizedBox(
                        height: 20.0.sp,
                      ),
                      isLoading == true
                          ? SpinKitPulse(
                              color: AppColors.mainColorDark,
                            )
                          : Button(text: 'Save'.tr(), tapAction: () {
                            updateProfile(appUserPro);
                      }),
                      SizedBox(
                        height: 12.0.sp,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 1,
                  right: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(3.0.sp),
                      child: Icon(
                        Icons.close,
                        color: AppColors.lightBlack,
                        size: 20.0.sp,
                      ),
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }

  updateProfile(AppUserProvider userPro, {String? profileUrl}) async {
    isLoading = true;
    updateState();
    String? imageUrl = pickedFile!=null ? await FirebaseCrud()
        .uploadImage(context: context, file: File(pickedFile!.path)) : null;
    Map<String, dynamic> map = pickedFile!=null ? {
      'firstName': firstNameController.text,
      'surName': surnameController.text,
      'about': aboutController.text,
      'profileUrl': imageUrl
    } : {
      'firstName': firstNameController.text,
      'surName': surnameController.text,
      'about': aboutController.text,
    };
    UsersRepository().updateCurrentUser(map, context, () {
      isLoading = false;
      updateState();
      userPro.getCurrentUser();
      Utilities().showSuccessDialog(context,
          message: 'Your profile is updated successfully'.tr(), onBtnTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context,
          message: 'Error: ${p0.toString()}'.tr(), onBtnTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }
}
