import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/dialogs/select_group_categories_dialog.dart';
import 'package:groupchat/component_library/text_fields/white_back_textfield.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/group_model.dart';
import 'package:groupchat/firebase/auth.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/groups_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/validation.dart';
import '../../firebase/firebase_crud.dart';
import '../../views/profile_screens/full_image_screen.dart';
import '../image_widgets/circle_image_avatar.dart';

class AddNewGroupDialog extends StatefulWidget {
  String? businessKey;

  @override
  State<StatefulWidget> createState() => _AddNewGroupDialog();

  AddNewGroupDialog({super.key,
    required this.businessKey,
  });
}

class _AddNewGroupDialog extends State<AddNewGroupDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  List<PlatformFile>? pickedFiles;
  XFile? pickedImage;
  List<String> categories = ['Accommodation', 'Food', 'Classes', 'Others'];
  List<String>? selectedCategories = [];
  List<bool> isSelectedCategories = List.generate(4, (index) => false);
  bool? isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Consumer(builder: (ctx, ref, child){
        var appUserPro = ref.watch(appUserProvider);
        return Container(
          padding: EdgeInsets.all(13.sp),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExtraLargeMediumBoldText(
                    title: 'Add new Group'.tr(),
                    textColor: AppColors.lightBlack,
                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
                      child: Stack(
                        children: <Widget>[
                          pickedImage != null
                              ? SizedBox(
                            height: 70.0.sp,
                            width: 70.sp,
                            child: CircleAvatar(
                              backgroundColor:
                              AppColors.backGroundLightWhite,
                              radius: 60.0,
                              child: ClipOval(
                                child: Image.file(
                                  File(pickedImage!.path),
                                  height: 70.0.sp,
                                  width: 70.0.sp,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                              : CircleImageAvatar(
                                imagePath:
                                appUserPro.currentUser?.profileUrl,
                                size: 70.0.sp,
                              ),
                          Positioned(
                              bottom: 1,
                              right: 1,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 1.0.sp, bottom: 1.0.sp),
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
                                            pickedImage = await Utilities.pickImage(imageSource: 'camera');
                                            updateState();
                                          }, onGalleryTap: () async {
                                            Navigator.of(context).pop();
                                            pickedImage =
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
                  SizedBox(height: 10.sp,),
                  WhiteBackTextField(
                    controller: nameController,
                    hintText: 'Name'.tr(),
                    validator: (value) {
                      return Validation()
                          .validateEmptyField(value, message: 'Name required'.tr());
                    },
                  ),
                  SizedBox(
                    height: 7.sp,
                  ),
                  WhiteBackTextField(
                    controller: pincodeController,
                    hintText: 'Pincode'.tr(),
                    maxLength: 5,
                    allowNumersOnly: true,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      return Validation()
                          .validatePinField(value, message: 'Pincode required'.tr());
                    },
                  ),
                  SizedBox(
                    height: 7.sp,
                  ),
                  InkWell(
                    onTap: () async {
                      final result = await showDialog(
                          context: context,
                          builder: (context) => SelectGroupCategoriesDialog(
                            categories: categories,
                            isSelected: isSelectedCategories,
                          ));
                      if (result != null) {
                        selectedCategories = result as List<String>;
                        updateState();
                      }
                    },
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: AppColors.lightFadedTextColor, width: 0.4.sp),
                          borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                      child: SmallLightText(
                        fontSize: 11.5.sp,
                        title: selectedCategories?.isNotEmpty == true
                            ? selectedCategories?.join(', ')
                            : 'Select Categories'.tr(),
                        textColor: selectedCategories?.isNotEmpty == true
                            ? AppColors.lightBlack
                            : AppColors.extraLightGrey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7.sp,
                  ),
                  selectedCategories?.isNotEmpty == true
                      ? Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 7.0.sp, horizontal: 10.0.sp),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.lightFadedTextColor,
                            width: 0.4.sp),
                        borderRadius:
                        BorderRadius.all(Radius.circular(4.sp))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SmallLightText(
                          title: 'Pick files for selected categories'.tr(),
                          textColor: AppColors.lightFadedTextColor,
                          fontSize: 10.sp,
                        ),
                        SizedBox(
                          height: 3.sp,
                        ),
                        InkWell(
                          onTap: () {
                            pickFiles();
                          },
                          child: Container(
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(vertical: 8.sp),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.mainColorDark,
                                    width: 0.5.sp),
                                borderRadius:
                                BorderRadius.all(Radius.circular(4.sp)),
                                color: AppColors.white),
                            child: Center(
                                child: SvgPicture.asset(
                                  Images.pickFileIcon,
                                  height: 17.sp,
                                  width: 17.sp,
                                  color: AppColors.mainColorDark,
                                )),
                          ),
                        ),
                        SizedBox(height: 10.sp),
                        if (pickedFiles?.isNotEmpty == true)
                          SizedBox(
                            height: 30.sp,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: pickedFiles?.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 7.sp),
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 9.sp),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.blue),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: SmallLightText(
                                      title: pickedFiles?[index].name,
                                      textColor: AppColors.lightBlack,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  )
                      : Container(),
                  SizedBox(
                    height: 12.sp,
                  ),
                  isLoading == true
                      ? SpinKitPulse(
                    color: AppColors.mainColorDark,
                  )
                      : Button(
                      text: 'Save'.tr(),
                      tapAction: () {
                        FocusScope.of(context).unfocus();
                        if(_formKey.currentState!.validate()){
                          if(selectedCategories==null){
                            Utilities().showCustomToast(
                                message: 'Please select categories first'.tr(),
                                isError: true);
                            return;
                          }
                          if(selectedCategories!=null && pickedFiles == null){
                            Utilities().showCustomToast(
                                message: 'Please pick files for each category'.tr(),
                                isError: true);
                            return;
                          }
                          if(selectedCategories==null && pickedFiles!=null){
                            Utilities().showCustomToast(
                                message: 'Please select categories first'.tr(),
                                isError: true);
                            return;
                          }
                          if(selectedCategories?.length!=pickedFiles?.length){
                            Utilities().showCustomToast(
                                message: 'Please pick files for each category'.tr(),
                                isError: true);
                            return;
                          }
                          saveGroupData();
                        }
                      })
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      pickedFiles ??= [];
      if ((pickedFiles?.length ?? 0) + result.files.length >
          selectedCategories!.length) {
        String? maxLength = selectedCategories?.length.toString();
        Utilities().showCustomToast(
            message: 'You can only select up to files.'.tr(args: [maxLength!]),
            isError: true);
        return;
      }
      setState(() {
        pickedFiles?.addAll(result.files);
      });
    } else {
      print("No file selected");
    }
  }

  saveGroupData() async {
    isLoading = true;
    updateState();
    List<String> fileUrls = [];
    if (pickedFiles != null) {
      pickedFiles?.forEach((element) async {
        String? fileUrl = await FirebaseCrud()
            .uploadImage(context: context, file: File(element.path ?? ''));
        fileUrls.add(fileUrl);
      });
    }
    GroupModel groupModel = GroupModel(
        businessKey: widget.businessKey,
        createdBy: Auth().currentUser?.uid,
        name: nameController.text,
        pincode: pincodeController.text,
        createdOn: DateTime.now().millisecondsSinceEpoch,
        deleted: false,
        fileUrls: fileUrls,
        categoryList: selectedCategories,
        category: selectedCategories?.join(', '));
    if(pickedImage!=null){
      String? fileUrl = await FirebaseCrud()
          .uploadImage(context: context, file: File(pickedImage?.path ?? ''));
      groupModel.groupImage = fileUrl;
    }
    GroupsRepository().addNewGroup(groupModel, context, () {
      isLoading = false;
      updateState();
      Utilities().showCustomToast(
          message: 'Group has been created'.tr(), isError: false);
      Navigator.pop(context);
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities()
          .showCustomToast(message: 'Error: ${p0.toString()}', isError: true);
    });
  }
}
