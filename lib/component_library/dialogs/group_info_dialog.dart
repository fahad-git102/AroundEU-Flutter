import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groupchat/component_library/dialogs/select_group_categories_dialog.dart';
import 'package:groupchat/component_library/text_widgets/medium_bold_text.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/data/group_model.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/groups_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/utilities_class.dart';
import '../../core/validation.dart';
import '../../firebase/firebase_crud.dart';
import '../../views/categories_screens/pdf_view_screen.dart';
import '../buttons/button.dart';
import '../image_widgets/circle_image_avatar.dart';
import '../text_fields/white_back_textfield.dart';
import '../text_widgets/small_light_text.dart';

class GroupInfoDialog extends ConsumerStatefulWidget {
  GroupModel? groupModel;
  Function()? onMembersTap;
  Function()? onDeleteTap;

  @override
  ConsumerState<GroupInfoDialog> createState() => _GroupInfoDialogState();

  GroupInfoDialog({
    super.key,
    this.groupModel,
    this.onDeleteTap,
    this.onMembersTap,
  });
}

class _GroupInfoDialogState extends ConsumerState<GroupInfoDialog> {
  bool? isEdit = false;
  final _formKey = GlobalKey<FormState>();
  XFile? pickedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  List<String> categories = ['Accommodation', 'Food', 'Classes', 'Others'];
  List<String?>? selectedCategories = [];
  List<String?>? pickedFilesNames;
  List<PlatformFile>? pickedFiles=[];
  String? selectedCategoriesText;
  bool? isLoading = false;
  List<bool> isSelectedCategories = List.generate(4, (index) => false);
  List<String?>? fileUrls = [];

  @override
  void dispose() {
    nameController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  updateState() {
    setState(() {});
  }

  void updateIsSelectedCategories() {
    for (int i = 0; i < categories.length; i++) {
      if (selectedCategories!.contains(categories[i])) {
        isSelectedCategories[i] = true;
      } else {
        isSelectedCategories[i] = false;
      }
    }
  }

  @override
  void initState() {
    nameController.text = widget.groupModel?.name ?? '';
    pincodeController.text = widget.groupModel?.pincode ?? '';
    selectedCategories = widget.groupModel?.categoryList ?? [];
    fileUrls?.addAll(widget.groupModel!.fileUrls??[]);
    pickedFilesNames??=[];
    pickedFilesNames?.addAll(fileUrls!);
    updateIsSelectedCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appUserPro = ref.watch(appUserProvider);
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: EdgeInsets.all(13.sp),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MediumBoldText(
                            title: widget.groupModel?.name,
                            textColor: AppColors.lightBlack,
                          ),
                        ),
                        isEdit==false?InkWell(
                          onTap: widget.onMembersTap,
                          child: Padding(
                            padding: EdgeInsets.all(3.0.sp),
                            child: Icon(
                              Icons.groups,
                              color: AppColors.mainColorDark,
                              size: 16.sp,
                            ),
                          ),
                        ):Container(),
                        isEdit == false && (appUserPro.currentUser?.admin == true || appUserPro.currentUser?.userType == coordinator)
                            ? InkWell(
                                onTap: () {
                                  isEdit = true;
                                  updateState();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(3.0.sp),
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColors.mainColorDark,
                                    size: 16.sp,
                                  ),
                                ),
                              )
                            : Container()
                      ],
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
                                    imagePath: widget.groupModel?.groupImage,
                                    size: 70.0.sp,
                                  ),
                            Visibility(
                              visible: isEdit ?? false,
                              child: Positioned(
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
                                              color: Colors.black87
                                                  .withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: const Offset(
                                                  1, 1), // Shadow position
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.sp))),
                                      child: InkWell(
                                        onTap: () async {
                                          Utilities().showImagePickerDialog(
                                              context, onCameraTap: () async {
                                            Navigator.of(context).pop();
                                            pickedImage =
                                                await Utilities.pickImage(
                                                    imageSource: 'camera');
                                            updateState();
                                          }, onGalleryTap: () async {
                                            Navigator.of(context).pop();
                                            pickedImage =
                                                await Utilities.pickImage(
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
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    WhiteBackTextField(
                      controller: nameController,
                      hintText: 'Name'.tr(),
                      enabled: isEdit,
                      validator: (value) {
                        return Validation().validateEmptyField(value,
                            message: 'Name required'.tr());
                      },
                    ),
                    isEdit == true
                        ? SizedBox(
                            height: 7.sp,
                          )
                        : Container(),
                    isEdit == true
                        ? WhiteBackTextField(
                            controller: pincodeController,
                            hintText: 'Pincode'.tr(),
                            maxLength: 5,
                            allowNumersOnly: true,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              return Validation().validatePinField(value,
                                  message: 'Pincode required'.tr());
                            },
                          )
                        : Container(),
                    SizedBox(
                      height: 7.sp,
                    ),
                    InkWell(
                      onTap: () async {
                        if (isEdit == true) {
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
                        }
                      },
                      child: Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.lightFadedTextColor,
                                width: 0.4.sp),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.sp))),
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
                                  title:
                                      isEdit == false?'Files for selected categories'.tr():'Pick files for selected categories'.tr(),
                                  textColor: AppColors.lightFadedTextColor,
                                  fontSize: 10.sp,
                                ),
                                isEdit == true?SizedBox(
                                  height: 3.sp,
                                ):Container(),
                                isEdit == true && selectedCategories!.length>(pickedFilesNames!.length+pickedFiles!.length)?InkWell(
                                  onTap: () {
                                    pickFiles();
                                  },
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.sp),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.mainColorDark,
                                            width: 0.5.sp),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.sp)),
                                        color: AppColors.white),
                                    child: Center(
                                        child: SvgPicture.asset(
                                      Images.pickFileIcon,
                                      height: 17.sp,
                                      width: 17.sp,
                                      color: AppColors.mainColorDark,
                                    )),
                                  ),
                                ):Container(),
                                SizedBox(height: 10.sp),
                                if (pickedFilesNames?.isNotEmpty == true)
                                  SizedBox(
                                    height: 25.sp,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: pickedFilesNames?.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => PdfViewScreen(
                                                    title: Utilities().getFileNameFromStorageUrl(pickedFilesNames?[index]??''),
                                                    url: pickedFilesNames?[index]??'',
                                                  )),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 7.sp),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.sp),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Center(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SmallLightText(
                                                    fontSize: 8.sp,
                                                    title: Utilities().getFileNameFromStorageUrl(pickedFilesNames?[index]??''),
                                                    textColor: AppColors.lightBlack,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(width: 7.sp,),
                                                  isEdit == true?InkWell(
                                                    onTap: (){
                                                      pickedFilesNames?.removeAt(index);
                                                      updateState();
                                                    },
                                                      child: SvgPicture.asset(Images.closeNormal, height: 9.sp, width: 9.sp,)):Container()
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(height: 10.sp),
                                if (pickedFiles?.isNotEmpty == true)
                                  SizedBox(
                                    height: 25.sp,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: pickedFiles?.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: (){

                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 7.sp),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.sp),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.blue),
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                            child: Center(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SmallLightText(
                                                    fontSize: 8.sp,
                                                    title: pickedFiles?[index].name,
                                                    textColor: AppColors.lightBlack,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(width: 7.sp,),
                                                  isEdit==true?InkWell(
                                                      onTap: (){
                                                        pickedFiles?.removeAt(index);
                                                        updateState();
                                                      },
                                                      child: SvgPicture.asset(Images.closeNormal, height: 9.sp, width: 9.sp,)):Container()
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(height: 5.sp,)
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 12.sp,
                    ),
                    isEdit == true ? isLoading == true
                        ? SpinKitPulse(
                      color: AppColors.mainColorDark,
                    )
                        : Button(
                        text: 'Save'.tr(),
                        tapAction: () {
                          if(_formKey.currentState!.validate()){
                            updateGroupData();
                          }
                        }):Container(),
                  ],
                )),
          ),
        ));
  }

  updateGroupData() async {
    if(selectedCategories?.length!=(pickedFilesNames!.length+pickedFiles!.length)){
      Utilities().showCustomToast(message: 'Please pick files for each category'.tr(), isError: true);
      return;
    }
    isLoading = true;
    updateState();
    Map<String, dynamic> map ={
      'name': nameController.text,
      'pincode': pincodeController.text
    };
    if(pickedImage!=null){
      String? imageUrl = await FirebaseCrud()
          .uploadImage(context: context, file: File(pickedImage!.path));
      map['groupImage']= imageUrl;
    }
    if(selectedCategories!=null&&selectedCategories?.isNotEmpty==true){
      map['categoryList']= selectedCategories;
      map['category']= selectedCategories?.join(', ');
    }
    if (pickedFiles != null && pickedFiles?.isNotEmpty==true) {
      List<String> fileUrls = [];
      fileUrls = await Future.wait(
        pickedFiles!.map((file) async {
          String? fileUrl = await FirebaseCrud().uploadImage(context: context, file: File(file.path ?? ''));
          return fileUrl ?? '';
        }).toList(),
      );
      pickedFilesNames?.forEach((item) {
        fileUrls.add(item ?? '');
      });
      map['fileUrls'] = fileUrls;
    } else if (pickedFilesNames?.length != widget.groupModel?.fileUrls?.length) {
      map['fileUrls'] = pickedFilesNames;
    }

    GroupsRepository().updateGroup(map, widget.groupModel?.key??'', context, (){
      isLoading = false;
      updateState();
      Navigator.pop(context);
      Utilities().showCustomToast(message: 'Group updated successfully'.tr(), isError: false);
    }, (p0){
      isLoading = false;
      updateState();
      Utilities().showCustomToast(message: p0.toString(), isError: true);
    });
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      pickedFiles ??= [];
      // pickedFilesNames ??= [];
      if ((pickedFiles?.length ?? 0) + result.files.length >
          selectedCategories!.length) {
        String? maxLength = selectedCategories?.length.toString();
        Utilities().showCustomToast(
            message: 'You can only select up to files.'.tr(args: [maxLength!]),
            isError: true);
        return;
      }
      pickedFiles?.addAll(result.files);
      // for (var item in result.files){
      //   pickedFilesNames?.add(item.name);
      // }
      updateState();
    } else {
      print("No file selected");
    }
  }
}
